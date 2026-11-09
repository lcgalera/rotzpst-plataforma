import Link from "next/link";

export default function NaoEncontrado() {
  return (
    <main className="container" style={{ paddingBlock: "var(--e-16)" }}>
      <p className="rotulo">404</p>
      <h1>Página não encontrada</h1>
      <p style={{ marginTop: "var(--e-4)" }}>
        O endereço pode estar errado ou a página foi movida. <Link href="/paises">Ver a lista de países</Link>
        .
      </p>
    </main>
  );
}
