import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { Bandeira } from "@/components/ui/Bandeira";
import { listarPaises } from "@/lib/dados";
import s from "./paises.module.css";

export const metadata: Metadata = {
  title: "Países",
  description: "Todos os países e territórios ISO, com os do G20 e os vizinhos do Brasil em destaque.",
};

async function Lista() {
  const paises = await listarPaises();
  const piloto = paises.filter((p) => p.piloto);
  const outros = paises.filter((p) => !p.piloto);
  return (
    <>
      <section aria-labelledby="completos" className={s.secao}>
        <h2 id="completos">Com indicadores completos</h2>
        <p className="rotulo">G20 e vizinhos do Brasil · {piloto.length} países</p>
        <ul className={s.lista}>
          {piloto.map((p) => (
            <li key={p.iso3}>
              <Link href={`/pais/${p.slug}`} className={s.item}>
                <Bandeira iso2={p.iso2} nome={p.nome} /> {p.nome}
              </Link>
            </li>
          ))}
        </ul>
      </section>
      <section aria-labelledby="demais" className={s.secao}>
        <h2 id="demais">Demais países e territórios</h2>
        <p className="rotulo">Cobertura parcial · {outros.length} códigos ISO 3166-1</p>
        <ul className={`${s.lista} ${s.compacta}`}>
          {outros.map((p) => (
            <li key={p.iso3}>
              <Link href={`/pais/${p.slug}`} className={s.item}>
                {p.nome}
              </Link>
            </li>
          ))}
        </ul>
      </section>
    </>
  );
}

export default function Paises() {
  return (
    <main className="container">
      <header className="grade" style={{ paddingTop: "var(--e-12)" }}>
        <div className="col-8">
          <p className="rotulo">Países</p>
          <h1>Panorama por país</h1>
        </div>
      </header>
      <Suspense fallback={<Carregamento />}>
        <Lista />
      </Suspense>
    </main>
  );
}
