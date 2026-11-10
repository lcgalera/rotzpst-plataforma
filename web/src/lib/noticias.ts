import "server-only";

import { cacheLife, cacheTag } from "next/cache";
import { sql } from "./dados";

/**
 * Notícias publicadas = análises APROVADAS na revisão humana.
 * Nunca seleciona `noticias.texto` (texto integral da fonte, só para uso interno).
 */

export type Bloco = { texto: string; citacoes: { trecho: string }[] };

export type NoticiaPublicada = {
  id: number;
  titulo: string;
  url: string;
  veiculo: string;
  publicadoEm: string; // ISO
  resumo: string;
  fato: Bloco;
  interpretacao: Bloco | null;
  impacto: Bloco | null;
  temas: string[];
  paises: string[];
  modelo: string;
  revisadoEm: string | null;
  fonte: { nome: string; licencaUrl: string };
};

export const TAG_NOTICIAS = "noticias";

const CAMPOS = `n.id, n.titulo, n.url, n.veiculo, n.publicado_em, a.resumo, a.fato, a.interpretacao, a.impacto,
  a.temas, a.paises, a.modelo, a.revisado_em, f.nome AS fonte_nome, f.licenca_url`;
const ORIGEM = `analises a JOIN noticias n ON n.id = a.noticia_id JOIN fontes_dados f ON f.id = n.fonte_id`;
const PUBLICADA = `a.status = 'aprovada' AND n.excluida_motivo IS NULL`;

// eslint-disable-next-line @typescript-eslint/no-explicit-any -- linha crua do driver
function paraNoticia(r: any): NoticiaPublicada {
  return {
    id: Number(r.id),
    titulo: r.titulo,
    url: r.url,
    veiculo: r.veiculo,
    publicadoEm: new Date(r.publicado_em).toISOString(),
    resumo: r.resumo,
    fato: r.fato,
    interpretacao: r.interpretacao,
    impacto: r.impacto,
    temas: r.temas,
    paises: r.paises.map((p: string) => p.trim()),
    modelo: r.modelo,
    revisadoEm: r.revisado_em ? new Date(r.revisado_em).toISOString() : null,
    fonte: { nome: r.fonte_nome, licencaUrl: r.licenca_url },
  };
}

export async function noticiasDoPais(iso3: string, limite = 30): Promise<NoticiaPublicada[]> {
  "use cache";
  cacheLife("hours");
  cacheTag(TAG_NOTICIAS);
  const linhas = await sql().unsafe(
    `SELECT ${CAMPOS} FROM ${ORIGEM} WHERE ${PUBLICADA} AND $1 = ANY(a.paises) ORDER BY n.publicado_em DESC LIMIT $2`,
    [iso3, limite],
  );
  return linhas.map(paraNoticia);
}

export async function noticiasRecentes(limite = 8): Promise<NoticiaPublicada[]> {
  "use cache";
  cacheLife("hours");
  cacheTag(TAG_NOTICIAS);
  const linhas = await sql().unsafe(
    `SELECT ${CAMPOS} FROM ${ORIGEM} WHERE ${PUBLICADA} ORDER BY n.publicado_em DESC LIMIT $1`,
    [limite],
  );
  return linhas.map(paraNoticia);
}

/** Só devolve a notícia se ela tiver análise aprovada; senão, null (vira 404). */
export async function noticiaPorId(id: number): Promise<NoticiaPublicada | null> {
  "use cache";
  cacheLife("hours");
  cacheTag(TAG_NOTICIAS);
  const linhas = await sql().unsafe(
    `SELECT ${CAMPOS} FROM ${ORIGEM} WHERE ${PUBLICADA} AND n.id = $1 LIMIT 1`,
    [id],
  );
  return linhas[0] ? paraNoticia(linhas[0]) : null;
}

/** Busca simples em título e resumo das notícias publicadas (sem diferenciar maiúsculas). */
export async function buscarNoticias(termo: string, limite = 20): Promise<NoticiaPublicada[]> {
  "use cache";
  cacheLife("hours");
  cacheTag(TAG_NOTICIAS);
  const padrao = `%${termo.replace(/[%_\\]/g, (c) => "\\" + c)}%`;
  const linhas = await sql().unsafe(
    `SELECT ${CAMPOS} FROM ${ORIGEM} WHERE ${PUBLICADA} AND (n.titulo ILIKE $1 OR a.resumo ILIKE $1)
     ORDER BY n.publicado_em DESC LIMIT $2`,
    [padrao, limite],
  );
  return linhas.map(paraNoticia);
}

export type QualidadeIa = { revisadas: number; comErro: number; geradas: number; barradasValidador: number };

/** Números da revisão humana para a página de metodologia (mesma definição de docs/taxa-erro-ia.md). */
export async function qualidadeIa(): Promise<QualidadeIa> {
  "use cache";
  cacheLife("hours");
  cacheTag(TAG_NOTICIAS);
  const [r] = await sql()`
    SELECT count(*)::int AS geradas,
           count(*) FILTER (WHERE 'reprovada_no_validador' = ANY(erros))::int AS barradas,
           count(*) FILTER (WHERE status IN ('aprovada','rejeitada') AND NOT 'reprovada_no_validador' = ANY(erros))::int AS revisadas,
           count(*) FILTER (WHERE NOT 'reprovada_no_validador' = ANY(erros)
                            AND (status = 'rejeitada' OR (status = 'aprovada' AND cardinality(erros) > 0)))::int AS com_erro
    FROM analises`;
  return { revisadas: r.revisadas, comErro: r.com_erro, geradas: r.geradas, barradasValidador: r.barradas };
}

/** Intervalo de Wilson de 95% (igual ao de ingest/jobs/taxa_erro.py). */
export function wilson(k: number, n: number, z = 1.96): [number, number] {
  if (n === 0) return [0, 1];
  const p = k / n;
  const den = 1 + (z * z) / n;
  const centro = (p + (z * z) / (2 * n)) / den;
  const margem = (z * Math.sqrt((p * (1 - p)) / n + (z * z) / (4 * n * n))) / den;
  return [Math.max(0, centro - margem), Math.min(1, centro + margem)];
}
