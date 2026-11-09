import "server-only";

import { timingSafeEqual } from "node:crypto";
import { sql } from "./dados";
import type { Bloco } from "./noticias";

/** Categorias de erro marcadas pelo revisor (base da taxa de erro). */
export const CATEGORIAS_ERRO = {
  fato_incorreto: "Fato incorreto ou distorcido",
  citacao_fora_de_contexto: "Citação fora de contexto",
  interpretacao_sem_base: "Interpretação sem base no texto",
  impacto_sem_base: "Impacto sem base no texto",
  pais_errado: "País errado ou faltando",
  tema_errado: "Tema errado",
  nao_neutro: "Linguagem não neutra",
  outro: "Outro (explicar na nota)",
} as const;
export type CategoriaErro = keyof typeof CATEGORIAS_ERRO;

/** Confere credencial Basic Auth contra REVISAO_SENHA (usuário fixo "revisor"). Sem senha configurada, nega. */
export function autorizado(cabecalho: string | null): boolean {
  const senha = process.env.REVISAO_SENHA;
  if (!senha || !cabecalho?.startsWith("Basic ")) return false;
  const esperado = Buffer.from(`revisor:${senha}`);
  const recebido = Buffer.from(Buffer.from(cabecalho.slice(6), "base64").toString("utf8"));
  return recebido.length === esperado.length && timingSafeEqual(recebido, esperado);
}

export type Pendente = {
  id: number;
  noticiaId: number;
  titulo: string;
  url: string;
  publicadoEm: string;
  editoria: string | null;
  resumo: string;
  fato: Bloco;
  interpretacao: Bloco | null;
  impacto: Bloco | null;
  paises: string[];
  temas: string[];
  modelo: string;
  provedor: string;
  avisos: string[];
};

/** Sem cache: o painel sempre mostra o estado atual. */
export async function listarPendentes(): Promise<Pendente[]> {
  const linhas = await sql()`
    SELECT a.id, a.noticia_id, n.titulo, n.url, n.publicado_em, n.editoria, a.resumo, a.fato, a.interpretacao,
           a.impacto, a.paises, a.temas, a.modelo, a.provedor, a.validacao
    FROM analises a JOIN noticias n ON n.id = a.noticia_id
    WHERE a.status = 'aguardando_revisao'
    ORDER BY n.publicado_em DESC`;
  return linhas.map((r) => ({
    id: Number(r.id),
    noticiaId: Number(r.noticia_id),
    titulo: r.titulo,
    url: r.url,
    publicadoEm: new Date(r.publicado_em).toISOString(),
    editoria: r.editoria,
    resumo: r.resumo,
    fato: r.fato,
    interpretacao: r.interpretacao,
    impacto: r.impacto,
    paises: r.paises.map((p: string) => p.trim()),
    temas: r.temas,
    modelo: r.modelo,
    provedor: r.provedor,
    avisos: r.validacao?.avisos ?? [],
  }));
}

export async function contagens(): Promise<Record<string, number>> {
  const linhas = await sql()`SELECT status, count(*)::int AS n FROM analises GROUP BY status`;
  return Object.fromEntries(linhas.map((r) => [r.status, r.n]));
}

export async function registrarRevisao(
  analiseId: number,
  decisao: "aprovada" | "rejeitada",
  erros: CategoriaErro[],
  nota: string | null,
): Promise<boolean> {
  const validos = erros.filter((e) => e in CATEGORIAS_ERRO);
  const r = await sql()`
    UPDATE analises SET status = ${decisao}, erros = ${validos}, revisao_nota = ${nota}, revisado_em = now()
    WHERE id = ${analiseId} AND status = 'aguardando_revisao'`;
  return r.count === 1;
}
