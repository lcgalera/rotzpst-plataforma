import "server-only";

import { cacheLife } from "next/cache";
import postgres from "postgres";
import { slugPais } from "./slug";

/**
 * Leitura dos dados publicados (Postgres). Só leitura; a escrita é da ingestão (ingest/).
 * Toda série sai de `series_com_fonte`, então nunca chega à interface um valor sem fonte e data.
 * Cache 'days': as fontes atualizam no máximo algumas vezes por mês.
 */

let _sql: postgres.Sql | null = null;

export function sql(): postgres.Sql {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error("DATABASE_URL não definida (ver .env.example).");
  _sql ??= postgres(url, { max: 5, idle_timeout: 20 });
  return _sql;
}

export type Pais = {
  iso3: string;
  iso2: string;
  isoNum: string;
  nome: string;
  slug: string;
  regiao: string | null;
  piloto: boolean;
  temGeometria: boolean;
};

export type Indicador = {
  codigo: string;
  nome: string;
  unidade: string;
  categoria: string;
  descricao: string;
  notaMetodologica: string | null;
  fonteId: string;
  codigoNaFonte: string;
};

export type PontoSerie = { periodo: number; valor: number };

export type Fonte = {
  id: string;
  nome: string;
  sigla: string;
  url: string;
  licenca: string;
  licencaUrl: string;
  atribuicao: string;
  frequencia: string;
  observacoes: string | null;
};

export type SerieDoPais = {
  indicador: Indicador;
  pontos: PontoSerie[]; // ordem crescente de período
  fonte: Fonte;
  edicaoFonte: string | null;
  atualizadoNaFonteEm: string | null; // AAAA-MM-DD
};

type LinhaPais = {
  iso3: string;
  iso2: string;
  iso_num: string;
  nome_pt: string;
  regiao: string | null;
  piloto: boolean;
  geometria_ref: string | null;
};

function paraPais(r: LinhaPais): Pais {
  return {
    iso3: r.iso3,
    iso2: r.iso2,
    isoNum: r.iso_num,
    nome: r.nome_pt,
    slug: slugPais(r.nome_pt),
    regiao: r.regiao,
    piloto: r.piloto,
    temGeometria: r.geometria_ref !== null,
  };
}

export async function listarPaises(): Promise<Pais[]> {
  "use cache";
  cacheLife("days");
  const linhas = await sql()<LinhaPais[]>`
    SELECT iso3, iso2, iso_num, nome_pt, regiao, piloto, geometria_ref FROM paises ORDER BY nome_pt`;
  return linhas.map(paraPais);
}

export async function obterPaisPorSlug(slug: string): Promise<Pais | null> {
  const paises = await listarPaises();
  return paises.find((p) => p.slug === slug) ?? null;
}

export async function listarIndicadores(): Promise<Indicador[]> {
  "use cache";
  cacheLife("days");
  const linhas = await sql()`
    SELECT codigo, nome_pt, unidade, categoria, descricao, nota_metodologica, fonte_id, codigo_na_fonte
    FROM indicadores ORDER BY codigo`;
  return linhas.map((r) => ({
    codigo: r.codigo,
    nome: r.nome_pt,
    unidade: r.unidade,
    categoria: r.categoria,
    descricao: r.descricao,
    notaMetodologica: r.nota_metodologica,
    fonteId: r.fonte_id,
    codigoNaFonte: r.codigo_na_fonte,
  }));
}

export async function listarFontes(): Promise<Fonte[]> {
  "use cache";
  cacheLife("days");
  const linhas = await sql()`SELECT * FROM fontes_dados ORDER BY id`;
  return linhas.map((r) => ({
    id: r.id,
    nome: r.nome,
    sigla: r.sigla,
    url: r.url,
    licenca: r.licenca,
    licencaUrl: r.licenca_url,
    atribuicao: r.atribuicao,
    frequencia: r.frequencia,
    observacoes: r.observacoes,
  }));
}

/** Todas as séries de um país, agrupadas por indicador. Indicador sem dado não aparece (a página mostra o vazio). */
export async function seriesDoPais(iso3: string): Promise<SerieDoPais[]> {
  "use cache";
  cacheLife("days");
  const [linhas, indicadores, fontes] = await Promise.all([
    sql()`
      SELECT indicador_codigo, periodo, valor, fonte_id, edicao_fonte,
             to_char(atualizado_na_fonte_em, 'YYYY-MM-DD') AS atualizado
      FROM series_com_fonte WHERE pais_iso3 = ${iso3}
      ORDER BY indicador_codigo, periodo`,
    listarIndicadores(),
    listarFontes(),
  ]);
  const porInd = new Map<string, SerieDoPais>();
  for (const r of linhas) {
    let s = porInd.get(r.indicador_codigo);
    if (!s) {
      const indicador = indicadores.find((i) => i.codigo === r.indicador_codigo)!;
      s = {
        indicador,
        pontos: [],
        fonte: fontes.find((f) => f.id === r.fonte_id)!,
        edicaoFonte: r.edicao_fonte,
        atualizadoNaFonteEm: r.atualizado,
      };
      porInd.set(r.indicador_codigo, s);
    }
    s.pontos.push({ periodo: r.periodo, valor: r.valor });
  }
  return [...porInd.values()];
}

export type UltimoValor = { iso3: string; periodo: number; valor: number };

/** Último valor disponível de um indicador em cada país (para o mapa). */
export async function ultimosValores(indicador: string): Promise<{
  valores: UltimoValor[];
  fonte: Fonte | null;
  atualizadoNaFonteEm: string | null;
}> {
  "use cache";
  cacheLife("days");
  const [linhas, fontes] = await Promise.all([
    sql()`
      SELECT DISTINCT ON (pais_iso3) pais_iso3, periodo, valor, fonte_id,
             to_char(atualizado_na_fonte_em, 'YYYY-MM-DD') AS atualizado
      FROM series WHERE indicador_codigo = ${indicador}
      ORDER BY pais_iso3, periodo DESC`,
    listarFontes(),
  ]);
  return {
    valores: linhas.map((r) => ({ iso3: r.pais_iso3, periodo: r.periodo, valor: r.valor })),
    fonte: linhas.length ? (fontes.find((f) => f.id === linhas[0].fonte_id) ?? null) : null,
    atualizadoNaFonteEm: linhas.reduce<string | null>(
      (max, r) => (r.atualizado && (!max || r.atualizado > max) ? r.atualizado : max),
      null,
    ),
  };
}

export type Destaque = {
  rotulo: string;
  pais: Pais;
  valor: number;
  unidade: string;
  periodo: number;
  comparados: number; // quantos países do piloto entraram na comparação
  fonte: Fonte;
  atualizadoNaFonteEm: string | null;
};

/**
 * Destaques calculados dos próprios dados (nada escrito à mão): o maior ou menor valor de um indicador
 * entre os países do piloto, no ano mais recente com dado para pelo menos 80% deles.
 */
export async function destaquesPiloto(
  pedidos: { indicador: string; ordem: "maior" | "menor"; rotulo: string }[],
): Promise<Destaque[]> {
  "use cache";
  cacheLife("days");
  const [paises, indicadores, fontes] = await Promise.all([
    listarPaises(),
    listarIndicadores(),
    listarFontes(),
  ]);
  const piloto = paises.filter((p) => p.piloto);
  const minimo = Math.ceil(piloto.length * 0.8);
  const saida: Destaque[] = [];
  for (const ped of pedidos) {
    const ind = indicadores.find((i) => i.codigo === ped.indicador);
    if (!ind) continue;
    const [ano] = await sql()`
      SELECT s.periodo, count(*)::int AS n FROM series s JOIN paises p ON p.iso3 = s.pais_iso3
      WHERE p.piloto AND s.indicador_codigo = ${ped.indicador}
      GROUP BY s.periodo HAVING count(*) >= ${minimo} ORDER BY s.periodo DESC LIMIT 1`;
    if (!ano) continue;
    const [linha] = await sql()`
      SELECT s.pais_iso3, s.valor, s.fonte_id, to_char(s.atualizado_na_fonte_em, 'YYYY-MM-DD') AS atualizado
      FROM series s JOIN paises p ON p.iso3 = s.pais_iso3
      WHERE p.piloto AND s.indicador_codigo = ${ped.indicador} AND s.periodo = ${ano.periodo}
      ORDER BY s.valor * ${ped.ordem === "maior" ? -1 : 1} LIMIT 1`;
    saida.push({
      rotulo: ped.rotulo,
      pais: piloto.find((p) => p.iso3 === linha.pais_iso3)!,
      valor: linha.valor,
      unidade: ind.unidade,
      periodo: ano.periodo,
      comparados: ano.n,
      fonte: fontes.find((f) => f.id === linha.fonte_id)!,
      atualizadoNaFonteEm: linha.atualizado,
    });
  }
  return saida;
}
