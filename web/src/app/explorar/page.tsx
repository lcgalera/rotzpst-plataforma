import type { Metadata } from "next";
import { Suspense } from "react";
import { Carregamento, fraseCarregamentoLigada } from "@/components/grafismo/Carregamento";
import { MapaPlano } from "@/components/mapa/MapaPlano";
import { listarIndicadores, listarPaises, ultimosValores } from "@/lib/dados";
import { formatarValorTexto } from "@/lib/formato";
import { Explorador, type Resumo } from "./Explorador";

export const metadata: Metadata = {
  title: "Explorar",
  description: "Explore os países no globo ou no mapa plano, com os principais indicadores de cada um.",
};

const NO_PAINEL = ["pib", "pib_per_capita", "pib_crescimento", "inflacao", "populacao"];
const NO_MAPA = "pib_per_capita";

async function Conteudo() {
  const [paises, indicadores, ...series] = await Promise.all([
    listarPaises(),
    listarIndicadores(),
    ...NO_PAINEL.map((c) => ultimosValores(c)),
  ]);
  const resumo: Resumo = {};
  NO_PAINEL.forEach((cod, i) => {
    const ind = indicadores.find((x) => x.codigo === cod)!;
    for (const v of series[i].valores) {
      (resumo[v.iso3] ??= []).push({
        rotulo: ind.nome,
        texto: formatarValorTexto(v.valor, ind.unidade),
        periodo: v.periodo,
      });
    }
  });
  const mapa = series[NO_PAINEL.indexOf(NO_MAPA)];
  const indMapa = indicadores.find((x) => x.codigo === NO_MAPA)!;
  const fonteBm = series[0].fonte;

  return (
    <Explorador
      paises={paises.map(({ isoNum, iso3, iso2, nome, slug, piloto, regiao }) => ({
        isoNum,
        iso3,
        iso2,
        nome,
        slug,
        piloto,
        regiao,
      }))}
      resumo={resumo}
      fonte={{ sigla: fonteBm?.sigla ?? "", atualizadoEm: series[0].atualizadoNaFonteEm }}
      frase={fraseCarregamentoLigada()}
      mapaPlano={
        <MapaPlano
          paises={paises}
          valores={mapa.valores}
          indicadorNome={indMapa.nome}
          unidade={indMapa.unidade}
          fonte={mapa.fonte ? { sigla: mapa.fonte.sigla, url: mapa.fonte.url } : null}
          atualizadoEm={mapa.atualizadoNaFonteEm}
        />
      }
    />
  );
}

export default function Explorar() {
  return (
    <main className="container">
      <header className="grade" style={{ paddingTop: "var(--e-12)" }}>
        <div className="col-8">
          <p className="rotulo">Explorar</p>
          <h1>O mundo, país por país</h1>
        </div>
      </header>
      <Suspense fallback={<Carregamento />}>
        <Conteudo />
      </Suspense>
    </main>
  );
}
