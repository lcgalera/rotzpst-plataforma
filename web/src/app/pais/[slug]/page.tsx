import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Suspense } from "react";
import { Grafico, type TipoGrafico } from "@/components/graficos/Grafico";
import { MarcadorSecao } from "@/components/grafismo/Modulo";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { Abas } from "@/components/ui/Abas";
import { Bandeira } from "@/components/ui/Bandeira";
import { EstadoVazio } from "@/components/ui/EstadoVazio";
import { FonteDado } from "@/components/ui/FonteDado";
import { NoticiaAnalise } from "@/components/noticias/NoticiaAnalise";
import { Kpi } from "@/components/ui/Kpi";
import {
  type Indicador,
  listarIndicadores,
  listarPaises,
  obterPaisPorSlug,
  type SerieDoPais,
  seriesDoPais,
} from "@/lib/dados";
import { type NoticiaPublicada, noticiasDoPais } from "@/lib/noticias";
import s from "./pais.module.css";

/** Ordem de leitura dos indicadores na página. */
const ORDEM = [
  "pib",
  "pib_crescimento",
  "pib_per_capita",
  "inflacao",
  "desemprego",
  "divida_publica_pib",
  "balanca_bens_servicos",
  "populacao",
];
const TIPO: Record<string, TipoGrafico> = {
  pib_crescimento: "barras",
  inflacao: "barras",
  balanca_bens_servicos: "barras",
  populacao: "area",
};
/** Barras ficam legíveis com até ~25 anos; linhas mostram a série inteira. */
const ANO_INICIAL_BARRAS = 2000;
const DEFASAGEM_ANOS = 3;

export async function generateStaticParams() {
  const paises = await listarPaises();
  return paises.filter((p) => p.piloto).map((p) => ({ slug: p.slug }));
}

export async function generateMetadata(props: PageProps<"/pais/[slug]">): Promise<Metadata> {
  const { slug } = await props.params;
  const pais = await obterPaisPorSlug(slug);
  if (!pais) return { title: "País não encontrado" };
  return {
    title: pais.nome,
    description: `${pais.nome}: panorama de economia, política e geopolítica, com fonte e data em cada dado.`,
  };
}

function SecaoIndicador({ ind, serie }: { ind: Indicador; serie: SerieDoPais | undefined }) {
  if (!serie || serie.pontos.length === 0) {
    return (
      <section className={s.indicador} aria-labelledby={`ind-${ind.codigo}`}>
        <h3 id={`ind-${ind.codigo}`}>{ind.nome}</h3>
        <EstadoVazio titulo="Ainda não temos dados desse indicador para este país.">
          <p>{ind.descricao}</p>
        </EstadoVazio>
      </section>
    );
  }
  const tipo = TIPO[ind.codigo] ?? "linha";
  const pontos =
    tipo === "barras" ? serie.pontos.filter((p) => p.periodo >= ANO_INICIAL_BARRAS) : serie.pontos;
  const ultimo = serie.pontos.at(-1)!;
  const primeiro = pontos[0];
  // Defasagem medida contra a data em que a própria fonte foi atualizada (não contra o relógio do visitante).
  const anoFonte = serie.atualizadoNaFonteEm ? Number(serie.atualizadoNaFonteEm.slice(0, 4)) : null;
  const defasado = anoFonte !== null && anoFonte - ultimo.periodo > DEFASAGEM_ANOS;
  return (
    <section className={s.indicador} aria-labelledby={`ind-${ind.codigo}`}>
      <h3 id={`ind-${ind.codigo}`}>{ind.nome}</h3>
      <p className={s.descricao}>
        {ind.descricao}{" "}
        {tipo === "barras" && serie.pontos[0].periodo < ANO_INICIAL_BARRAS
          ? `Gráfico desde ${ANO_INICIAL_BARRAS}.`
          : ""}
      </p>
      {defasado && (
        <p className={s.aviso}>
          O dado mais recente disponível na fonte é de {ultimo.periodo}. A fonte não publicou valores mais
          novos para este país.
        </p>
      )}
      {pontos.length > 1 ? (
        <Grafico
          pontos={pontos}
          unidade={ind.unidade}
          tipo={tipo}
          titulo={`${ind.nome}, ${primeiro.periodo} a ${ultimo.periodo}`}
          descricao={`Série anual de ${ind.nome.toLowerCase()} (${ind.unidade}). Último valor: ${ultimo.periodo}.`}
        />
      ) : (
        <p className={s.descricao}>
          Só há um ano disponível ({ultimo.periodo}); não dá para traçar uma série.
        </p>
      )}
      <FonteDado
        sigla={serie.fonte.sigla}
        url={serie.fonte.url}
        atualizadoEm={serie.atualizadoNaFonteEm}
        extra={ind.notaMetodologica}
      />
    </section>
  );
}

function SecaoNoticias({ tema, noticias }: { tema: string; noticias: NoticiaPublicada[] }) {
  if (noticias.length === 0) return null;
  return (
    <section aria-labelledby={`noticias-${tema}`} className={s.noticias}>
      <h2 id={`noticias-${tema}`} className={s.tituloSecao}>
        Notícias recentes
      </h2>
      {noticias.map((n) => (
        <NoticiaAnalise key={n.id} n={n} />
      ))}
    </section>
  );
}

async function Conteudo({ params }: { params: PageProps<"/pais/[slug]">["params"] }) {
  const { slug } = await params;
  const pais = await obterPaisPorSlug(slug);
  if (!pais) notFound();
  const [series, indicadores, noticias] = await Promise.all([
    seriesDoPais(pais.iso3),
    listarIndicadores(),
    noticiasDoPais(pais.iso3),
  ]);
  const doTema = (t: string) => noticias.filter((n) => n.temas.includes(t));
  const porCodigo = new Map(series.map((x) => [x.indicador.codigo, x]));
  const ordenados = ORDEM.map((c) => indicadores.find((i) => i.codigo === c)).filter(
    (i): i is Indicador => !!i,
  );

  const economia = (
    <>
      {!pais.piloto && (
        <EstadoVazio titulo="Este país ainda não faz parte do conjunto com dados completos.">
          <p>
            Começamos pelos países do G20 e pelos vizinhos do Brasil. O que houver deste país aparece abaixo;
            o resto fica vazio até ser coletado e verificado.
          </p>
        </EstadoVazio>
      )}
      <section aria-labelledby="destaques" className={s.destaques}>
        <h2 id="destaques" className="visualmente-oculto">
          Indicadores mais recentes
        </h2>
        <div className={s.kpis}>
          {ordenados.map((ind) => {
            const serie = porCodigo.get(ind.codigo);
            const ult = serie?.pontos.at(-1) ?? null;
            const ant = serie && serie.pontos.length > 1 ? serie.pontos.at(-2)! : null;
            return (
              <Kpi
                key={ind.codigo}
                rotulo={ind.nome}
                valor={ult?.valor ?? null}
                unidade={ind.unidade}
                periodo={ult?.periodo ?? null}
                anterior={ant}
                fonte={serie?.fonte.sigla ?? null}
                atualizadoEm={serie?.atualizadoNaFonteEm ?? null}
                nota={ind.notaMetodologica}
              />
            );
          })}
        </div>
      </section>
      <SecaoNoticias tema="economia" noticias={doTema("economia")} />
      <section aria-labelledby="series" className={s.series}>
        <h2 id="series" className={s.tituloSecao}>
          <MarcadorSecao
            modulos={[
              { forma: "semicirculo", cor: "verde-mata" },
              { forma: "quarto", cor: "terracota", rotacao: 90 },
            ]}
          />{" "}
          Séries históricas
        </h2>
        <div className={s.grade}>
          {ordenados.map((ind) => (
            <SecaoIndicador key={ind.codigo} ind={ind} serie={porCodigo.get(ind.codigo)} />
          ))}
        </div>
      </section>
    </>
  );

  const porTema = (tema: string, nome: string) =>
    doTema(tema).length ? (
      <SecaoNoticias tema={tema} noticias={doTema(tema)} />
    ) : (
      <EstadoVazio titulo={`Ainda não há conteúdo de ${nome} publicado para este país.`}>
        <p>
          Esta seção reúne notícias organizadas em fato, interpretação e impacto, sempre com link para as
          fontes originais. Só aparecem depois de revisadas por uma pessoa.
        </p>
      </EstadoVazio>
    );

  return (
    <>
      <header className={`grade ${s.cabecalho}`}>
        <div className="col-8">
          <p className="rotulo">{pais.regiao ?? "País"}</p>
          <h1 className={s.nome}>
            <Bandeira iso2={pais.iso2} nome={pais.nome} tamanho="m" /> {pais.nome}
          </h1>
        </div>
        <p className={`col-4 ${s.meta}`}>
          {pais.piloto ? "Indicadores completos" : "Cobertura parcial"} · código ISO {pais.iso3}
        </p>
      </header>
      <Abas
        rotulo={`${pais.nome}: panorama`}
        abas={[
          { id: "economia", rotulo: "Economia", conteudo: economia },
          { id: "politica", rotulo: "Política", conteudo: porTema("politica", "política") },
          { id: "geopolitica", rotulo: "Geopolítica", conteudo: porTema("geopolitica", "geopolítica") },
        ]}
      />
    </>
  );
}

export default function PaginaPais(props: PageProps<"/pais/[slug]">) {
  return (
    <main className="container">
      <Suspense fallback={<Carregamento />}>
        <Conteudo params={props.params} />
      </Suspense>
    </main>
  );
}
