import Link from "next/link";
import { Suspense } from "react";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { MarcadorSecao } from "@/components/grafismo/Modulo";
import { MapaPlano } from "@/components/mapa/MapaPlano";
import { Bandeira } from "@/components/ui/Bandeira";
import { EstadoVazio } from "@/components/ui/EstadoVazio";
import { destaquesPiloto, listarIndicadores, listarPaises, ultimosValores } from "@/lib/dados";
import { formatarData, formatarValor } from "@/lib/formato";
import { noticiasRecentes } from "@/lib/noticias";
import s from "./home.module.css";

const DESTAQUES = [
  { indicador: "pib_crescimento", ordem: "maior" as const, rotulo: "Maior crescimento do PIB" },
  { indicador: "pib_crescimento", ordem: "menor" as const, rotulo: "Menor crescimento do PIB" },
  { indicador: "inflacao", ordem: "maior" as const, rotulo: "Maior inflação" },
  { indicador: "divida_publica_pib", ordem: "maior" as const, rotulo: "Maior dívida pública" },
];

function dataPt(iso: string): string {
  return new Date(iso).toLocaleDateString("pt-BR", {
    timeZone: "America/Sao_Paulo",
    day: "2-digit",
    month: "long",
  });
}

async function Cenario() {
  const noticias = await noticiasRecentes(5);
  if (noticias.length === 0) {
    return (
      <EstadoVazio titulo="Ainda não há notícias revisadas publicadas.">
        <p>As notícias aparecem aqui depois de passar pela revisão humana.</p>
      </EstadoVazio>
    );
  }
  const [manchete, ...demais] = noticias;
  return (
    <div className={`grade ${s.cenario}`}>
      <article className={`col-7 ${s.manchete}`} aria-labelledby="manchete">
        <p className="rotulo">
          {manchete.veiculo} · {dataPt(manchete.publicadoEm)}
        </p>
        <h1 id="manchete" className={s.tituloManchete}>
          <Link href={`/noticia/${manchete.id}`}>{manchete.titulo}</Link>
        </h1>
        <p className={s.resumoManchete}>{manchete.resumo}</p>
        <p className={s.fatoManchete}>
          <strong>Fato.</strong> {manchete.fato.texto}
        </p>
        <p className={s.rotuloIa}>
          Resumo gerado por IA e revisado por uma pessoa · baseado só no texto original
        </p>
      </article>
      <aside className={`col-4 ${s.lateral}`} aria-labelledby="cenario">
        <h2 id="cenario" className={s.tituloLateral}>
          O cenário agora
        </h2>
        <ol className={s.listaCenario}>
          {demais.map((n) => (
            <li key={n.id}>
              <p className="rotulo">{dataPt(n.publicadoEm)}</p>
              <Link href={`/noticia/${n.id}`} className={s.itemCenario}>
                {n.titulo}
              </Link>
            </li>
          ))}
        </ol>
      </aside>
    </div>
  );
}

async function Destaques() {
  const destaques = await destaquesPiloto(DESTAQUES);
  return (
    <section aria-labelledby="destaques" className={s.secao}>
      <h2 id="destaques" className={s.tituloSecao}>
        <MarcadorSecao
          modulos={[
            { forma: "circulo", cor: "azul-profundo" },
            { forma: "semicirculo", cor: "terracota" },
          ]}
        />{" "}
        Destaques entre os países acompanhados
      </h2>
      <div className={s.destaques}>
        {destaques.map((d) => {
          const f = formatarValor(d.valor, d.unidade);
          return (
            <div key={d.rotulo} className={s.destaque}>
              <p className={s.rotuloDestaque}>
                {d.rotulo} · {d.periodo}
              </p>
              <p className={s.valorDestaque}>
                <span className="num">{f.numero}</span>
                {f.unidade && <span className={s.unidade}>{f.unidade}</span>}
              </p>
              <p>
                <Link href={`/pais/${d.pais.slug}`} className={s.paisDestaque}>
                  <Bandeira iso2={d.pais.iso2} nome={d.pais.nome} /> {d.pais.nome}
                </Link>
              </p>
              <p className={s.notaDestaque}>
                Comparação entre {d.comparados} países com dado de {d.periodo}. Fonte: {d.fonte.sigla}
                {d.atualizadoNaFonteEm ? `, atualizado em ${formatarData(d.atualizadoNaFonteEm)}` : ""}.
              </p>
            </div>
          );
        })}
      </div>
    </section>
  );
}

async function Mapa() {
  const [paises, indicadores, mapa] = await Promise.all([
    listarPaises(),
    listarIndicadores(),
    ultimosValores("pib_per_capita"),
  ]);
  const ind = indicadores.find((i) => i.codigo === "pib_per_capita")!;
  return (
    <section aria-labelledby="mundo" className={s.secao}>
      <div className={s.cabecaMapa}>
        <h2 id="mundo" className={s.tituloSecao}>
          O mundo em um mapa
        </h2>
        <p>
          <Link href="/explorar">Abrir o globo interativo</Link> ·{" "}
          <Link href="/comparar">Comparar países</Link>
        </p>
      </div>
      <MapaPlano
        paises={paises}
        valores={mapa.valores}
        indicadorNome={ind.nome}
        unidade={ind.unidade}
        fonte={mapa.fonte ? { sigla: mapa.fonte.sigla, url: mapa.fonte.url } : null}
        atualizadoEm={mapa.atualizadoNaFonteEm}
      />
    </section>
  );
}

export default function Home() {
  return (
    <main className="container">
      <Suspense fallback={<Carregamento />}>
        <Cenario />
      </Suspense>
      <Suspense fallback={<Carregamento />}>
        <Destaques />
      </Suspense>
      <Suspense fallback={<Carregamento />}>
        <Mapa />
      </Suspense>
    </main>
  );
}
