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

export async function noticiasDoPais(iso3: string, limite = 30): Promise<NoticiaPublicada[]> {
  "use cache";
  cacheLife("hours");
  cacheTag(TAG_NOTICIAS);
  const linhas = await sql()`
    SELECT n.id, n.titulo, n.url, n.veiculo, n.publicado_em, a.resumo, a.fato, a.interpretacao, a.impacto,
           a.temas, a.paises, a.modelo, a.revisado_em, f.nome AS fonte_nome, f.licenca_url
    FROM analises a
    JOIN noticias n ON n.id = a.noticia_id
    JOIN fontes_dados f ON f.id = n.fonte_id
    WHERE a.status = 'aprovada' AND ${iso3} = ANY(a.paises) AND n.excluida_motivo IS NULL
    ORDER BY n.publicado_em DESC
    LIMIT ${limite}`;
  return linhas.map((r) => ({
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
  }));
}
