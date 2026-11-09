"use client";

import { useMemo, useState } from "react";
import s from "./Tabela.module.css";

export type Coluna = { id: string; rotulo: string; numerica?: boolean; ordenavel?: boolean };
/** Cada célula traz o texto exibido e o valor de ordenação (null = ausente, vai para o fim). */
export type Celula = { texto: string; valor: number | string | null };
export type Linha = { id: string; celulas: Record<string, Celula> };

type Ordem = { coluna: string; direcao: "ascending" | "descending" } | null;

/** Cabeçalho em caixa-baixa pequena, linhas finas, números à direita, ordenação por teclado (botões no cabeçalho). */
export function Tabela({
  colunas,
  linhas,
  legenda,
  ordemInicial = null,
}: {
  colunas: Coluna[];
  linhas: Linha[];
  legenda: string;
  ordemInicial?: Ordem;
}) {
  const [ordem, setOrdem] = useState<Ordem>(ordemInicial);

  const ordenadas = useMemo(() => {
    if (!ordem) return linhas;
    const fator = ordem.direcao === "ascending" ? 1 : -1;
    return [...linhas].sort((a, b) => {
      const va = a.celulas[ordem.coluna]?.valor ?? null;
      const vb = b.celulas[ordem.coluna]?.valor ?? null;
      if (va === null && vb === null) return 0;
      if (va === null) return 1;
      if (vb === null) return -1;
      if (typeof va === "number" && typeof vb === "number") return (va - vb) * fator;
      return String(va).localeCompare(String(vb), "pt-BR") * fator;
    });
  }, [linhas, ordem]);

  function alternar(id: string) {
    setOrdem((o) =>
      o?.coluna === id
        ? { coluna: id, direcao: o.direcao === "ascending" ? "descending" : "ascending" }
        : { coluna: id, direcao: "descending" },
    );
  }

  return (
    <div className={s.rolagem}>
      <table className={s.tabela}>
        <caption className={s.legenda}>{legenda}</caption>
        <thead>
          <tr>
            {colunas.map((c) => {
              const ativa = ordem?.coluna === c.id;
              return (
                <th
                  key={c.id}
                  scope="col"
                  className={c.numerica ? s.num : undefined}
                  aria-sort={ativa ? ordem!.direcao : c.ordenavel ? "none" : undefined}
                >
                  {c.ordenavel ? (
                    <button type="button" className={s.ordenar} onClick={() => alternar(c.id)}>
                      {c.rotulo}
                      <span aria-hidden="true" className={s.seta}>
                        {ativa ? (ordem!.direcao === "ascending" ? "↑" : "↓") : "↕"}
                      </span>
                    </button>
                  ) : (
                    c.rotulo
                  )}
                </th>
              );
            })}
          </tr>
        </thead>
        <tbody>
          {ordenadas.map((l) => (
            <tr key={l.id}>
              {colunas.map((c, i) => {
                const cel = l.celulas[c.id];
                const Tag = i === 0 ? "th" : "td";
                return (
                  <Tag
                    key={c.id}
                    scope={i === 0 ? "row" : undefined}
                    className={c.numerica ? s.num : undefined}
                  >
                    {cel?.texto ?? <span className={s.ausente}>sem dado</span>}
                  </Tag>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
