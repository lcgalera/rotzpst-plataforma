import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { GraficoComparativo } from "@/components/graficos/GraficoComparativo";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { Bandeira } from "@/components/ui/Bandeira";
import { EstadoVazio } from "@/components/ui/EstadoVazio";
import { FonteDado } from "@/components/ui/FonteDado";
import { listarIndicadores, listarPaises, seriesDoPais } from "@/lib/dados";
import s from "./comparar.module.css";

export const metadata: Metadata = {
  title: "Comparar países",
  description: "Compare de 2 a 4 países nos mesmos indicadores, na mesma escala, com fonte e data.",
};

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
const ANO_INICIAL = 2000;
const MAX_PAISES = 4;

async function Comparacao({ searchParams }: { searchParams: PageProps<"/comparar">["searchParams"] }) {
  const sp = await searchParams;
  const pedidos = [sp.p]
    .flat()
    .filter((v): v is string => !!v)
    .map((v) => v.toUpperCase());
  const [paises, indicadores] = await Promise.all([listarPaises(), listarIndicadores()]);
  const piloto = paises.filter((p) => p.piloto);
  const escolhidos = [...new Set(pedidos)]
    .map((iso) => paises.find((p) => p.iso3 === iso))
    .filter((p): p is NonNullable<typeof p> => !!p)
    .slice(0, MAX_PAISES);

  const formulario = (
    <form method="get" action="/comparar" className={s.form} aria-label="Escolher países">
      {Array.from({ length: MAX_PAISES }, (_, i) => (
        <label key={i} className={s.campo}>
          <span className={s.nomeCampo}>
            País {i + 1}
            {i >= 2 && <span className={s.opcional}> · opcional</span>}
          </span>
          <select name="p" defaultValue={escolhidos[i]?.iso3 ?? ""}>
            <option value="">—</option>
            {piloto.map((p) => (
              <option key={p.iso3} value={p.iso3}>
                {p.nome}
              </option>
            ))}
          </select>
        </label>
      ))}
      <button type="submit" className={s.botao}>
        Comparar
      </button>
    </form>
  );

  if (escolhidos.length < 2) {
    return (
      <>
        {formulario}
        <EstadoVazio titulo="Escolha pelo menos dois países para comparar.">
          <p>
            Por exemplo: <Link href="/comparar?p=BRA&p=ARG&p=MEX">Brasil, Argentina e México</Link> ou{" "}
            <Link href="/comparar?p=USA&p=CHN">Estados Unidos e China</Link>. A lista inclui os países com
            indicadores completos.
          </p>
        </EstadoVazio>
      </>
    );
  }

  const todas = await Promise.all(escolhidos.map((p) => seriesDoPais(p.iso3)));
  const ordenados = ORDEM.map((c) => indicadores.find((i) => i.codigo === c)).filter(
    (i): i is NonNullable<typeof i> => !!i,
  );

  return (
    <>
      {formulario}
      <p className={s.escolhidos}>
        {escolhidos.map((p, i) => (
          <span key={p.iso3}>
            {i > 0 && " · "}
            <Link href={`/pais/${p.slug}`}>
              <Bandeira iso2={p.iso2} nome={p.nome} /> {p.nome}
            </Link>
          </span>
        ))}
      </p>
      <div className={s.grade}>
        {ordenados.map((ind) => {
          const series = escolhidos.map((p, k) => ({
            nome: p.nome,
            pontos: (todas[k].find((x) => x.indicador.codigo === ind.codigo)?.pontos ?? []).filter(
              (pt) => pt.periodo >= ANO_INICIAL,
            ),
          }));
          const fonte = todas.flat().find((x) => x.indicador.codigo === ind.codigo);
          const algum = series.some((x) => x.pontos.length > 0);
          return (
            <section key={ind.codigo} aria-labelledby={`c-${ind.codigo}`} className={s.indicador}>
              <h2 id={`c-${ind.codigo}`} className={s.titulo}>
                {ind.nome}
              </h2>
              <p className={s.descricao}>
                {ind.descricao} Desde {ANO_INICIAL}, mesma escala para todos.
              </p>
              {algum ? (
                <GraficoComparativo
                  series={series}
                  unidade={ind.unidade}
                  titulo={`${ind.nome}: ${escolhidos.map((p) => p.nome).join(", ")}`}
                  descricao={`Séries anuais de ${ind.nome.toLowerCase()} desde ${ANO_INICIAL}, na mesma escala.`}
                />
              ) : (
                <EstadoVazio titulo="Ainda não temos dados desse indicador para estes países." />
              )}
              {fonte && (
                <FonteDado
                  sigla={fonte.fonte.sigla}
                  url={fonte.fonte.url}
                  atualizadoEm={fonte.atualizadoNaFonteEm}
                  extra={ind.notaMetodologica}
                />
              )}
            </section>
          );
        })}
      </div>
    </>
  );
}

export default function Comparar(props: PageProps<"/comparar">) {
  return (
    <main className="container">
      <header style={{ paddingBlock: "var(--e-12) var(--e-6)" }}>
        <p className="rotulo">Comparar</p>
        <h1>Países lado a lado</h1>
      </header>
      <Suspense fallback={<Carregamento />}>
        <Comparacao searchParams={props.searchParams} />
      </Suspense>
    </main>
  );
}
