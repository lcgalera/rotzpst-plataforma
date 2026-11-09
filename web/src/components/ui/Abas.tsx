"use client";

import { type KeyboardEvent, type ReactNode, useId, useRef, useState } from "react";
import s from "./Abas.module.css";

export type Aba = { id: string; rotulo: string; conteudo: ReactNode };

/** Abas acessíveis (padrão WAI-ARIA): setas, Home e End trocam de aba; o conteúdo vem pronto do servidor. */
export function Abas({ abas, rotulo }: { abas: Aba[]; rotulo: string }) {
  const [ativa, setAtiva] = useState(0);
  const base = useId();
  const botoes = useRef<(HTMLButtonElement | null)[]>([]);

  function teclado(e: KeyboardEvent) {
    const n = abas.length;
    const alvo =
      e.key === "ArrowRight"
        ? (ativa + 1) % n
        : e.key === "ArrowLeft"
          ? (ativa - 1 + n) % n
          : e.key === "Home"
            ? 0
            : e.key === "End"
              ? n - 1
              : null;
    if (alvo === null) return;
    e.preventDefault();
    setAtiva(alvo);
    botoes.current[alvo]?.focus();
  }

  return (
    <div>
      <div role="tablist" aria-label={rotulo} className={s.lista} onKeyDown={teclado}>
        {abas.map((a, i) => (
          <button
            key={a.id}
            ref={(el) => {
              botoes.current[i] = el;
            }}
            type="button"
            role="tab"
            id={`${base}-aba-${a.id}`}
            aria-selected={i === ativa}
            aria-controls={`${base}-painel-${a.id}`}
            tabIndex={i === ativa ? 0 : -1}
            className={s.aba}
            onClick={() => setAtiva(i)}
          >
            {a.rotulo}
          </button>
        ))}
      </div>
      {abas.map((a, i) => (
        <div
          key={a.id}
          role="tabpanel"
          id={`${base}-painel-${a.id}`}
          aria-labelledby={`${base}-aba-${a.id}`}
          hidden={i !== ativa}
          tabIndex={0}
          className={s.painel}
        >
          {a.conteudo}
        </div>
      ))}
    </div>
  );
}
