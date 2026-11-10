"use client";

import { Botao } from "@/components/ui/Botao";

/** Erro inesperado (ex.: banco fora do ar). Texto do PLANO-DESIGN §8; sem detalhes técnicos para o leitor. */
export default function Erro({ retry }: { error: unknown; retry: () => void }) {
  return (
    <main className="container" style={{ paddingBlock: "var(--e-16)" }}>
      <p className="rotulo">Erro</p>
      <h1>Não conseguimos carregar agora.</h1>
      <p style={{ marginBlock: "var(--e-4) var(--e-6)" }}>Tente de novo em instantes.</p>
      <Botao onClick={() => retry()}>Tentar de novo</Botao>
    </main>
  );
}
