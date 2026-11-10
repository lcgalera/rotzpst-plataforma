import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { Bandeira } from "@/components/ui/Bandeira";
import { EstadoVazio } from "@/components/ui/EstadoVazio";
import { listarPaises } from "@/lib/dados";
import { buscarNoticias } from "@/lib/noticias";
import { slugPais } from "@/lib/slug";
import s from "./busca.module.css";

export const metadata: Metadata = { title: "Busca", robots: { index: false } };

async function Resultados({ searchParams }: { searchParams: PageProps<"/busca">["searchParams"] }) {
  const sp = await searchParams;
  const q = String([sp.q].flat()[0] ?? "")
    .trim()
    .slice(0, 80);
  const form = (
    <form method="get" action="/busca" role="search" className={s.form}>
      <label htmlFor="q" className="visualmente-oculto">
        Buscar países e notícias
      </label>
      <input
        id="q"
        name="q"
        type="search"
        defaultValue={q}
        placeholder="Ex.: Argentina, Selic, Senado"
        className={s.campo}
      />
      <button type="submit" className={s.botao}>
        Buscar
      </button>
    </form>
  );
  if (q.length < 2)
    return (
      <>
        {form}
        <p className={s.dica}>Digite pelo menos 2 letras.</p>
      </>
    );

  const termo = slugPais(q);
  const [paises, noticias] = await Promise.all([listarPaises(), buscarNoticias(q)]);
  const achados = paises
    .filter((p) => p.slug.includes(termo) || p.iso3.toLowerCase() === termo)
    .sort((a, b) => Number(b.piloto) - Number(a.piloto) || a.nome.localeCompare(b.nome, "pt-BR"))
    .slice(0, 12);

  return (
    <>
      {form}
      <section aria-labelledby="r-paises" className={s.secao}>
        <h2 id="r-paises">Países ({achados.length})</h2>
        {achados.length ? (
          <ul className={s.lista}>
            {achados.map((p) => (
              <li key={p.iso3}>
                <Link href={`/pais/${p.slug}`}>
                  <Bandeira iso2={p.iso2} nome={p.nome} /> {p.nome}
                </Link>
                {!p.piloto && <span className={s.nota}> · cobertura parcial</span>}
              </li>
            ))}
          </ul>
        ) : (
          <p className={s.nota}>Nenhum país com esse nome.</p>
        )}
      </section>
      <section aria-labelledby="r-noticias" className={s.secao}>
        <h2 id="r-noticias">Notícias ({noticias.length})</h2>
        {noticias.length ? (
          <ul className={s.listaNoticias}>
            {noticias.map((n) => (
              <li key={n.id}>
                <Link href={`/noticia/${n.id}`} className={s.tituloNoticia}>
                  {n.titulo}
                </Link>
                <p className={s.nota}>
                  {n.veiculo} ·{" "}
                  {new Date(n.publicadoEm).toLocaleDateString("pt-BR", { timeZone: "America/Sao_Paulo" })}
                </p>
                <p>{n.resumo}</p>
              </li>
            ))}
          </ul>
        ) : (
          <EstadoVazio titulo={`Nenhuma notícia publicada menciona “${q}”.`}>
            <p>A busca procura no título e no resumo das notícias já revisadas.</p>
          </EstadoVazio>
        )}
      </section>
    </>
  );
}

export default function Busca(props: PageProps<"/busca">) {
  return (
    <main className="container">
      <header style={{ paddingBlock: "var(--e-12) var(--e-6)" }}>
        <p className="rotulo">Busca</p>
        <h1>Países e notícias</h1>
      </header>
      <Suspense fallback={<Carregamento />}>
        <Resultados searchParams={props.searchParams} />
      </Suspense>
    </main>
  );
}
