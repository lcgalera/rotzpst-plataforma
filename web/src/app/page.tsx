import Link from "next/link";

/** Home provisória. A home editorial de verdade é da Fase 4 / Design D. */
export default function Home() {
  return (
    <main className="container">
      <div className="grade" style={{ paddingBlock: "var(--e-24)" }}>
        <div className="col-7">
          <p className="rotulo">Em construção</p>
          <h1 className="titulo-display">rotzx</h1>
          <p style={{ marginTop: "var(--e-6)", fontSize: "var(--t-lg)" }}>
            Economia, geopolítica e inteligência global. Ainda não há dados publicados aqui.
          </p>
          <p style={{ marginTop: "var(--e-4)" }}>
            <Link href="/design">Ver o sistema de design</Link>
          </p>
        </div>
      </div>
    </main>
  );
}
