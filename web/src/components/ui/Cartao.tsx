import type { ReactNode } from "react";
import s from "./Cartao.module.css";

/** Cartão plano: sem sombra, divisória superior; título serifado, metadados em corpo pequeno. */
export function Cartao({
  titulo,
  meta,
  children,
  nivel = 3,
  borda = "topo",
}: {
  titulo: ReactNode;
  meta?: ReactNode;
  children?: ReactNode;
  nivel?: 2 | 3 | 4;
  borda?: "topo" | "completa";
}) {
  const H = `h${nivel}` as const;
  return (
    <article className={`${s.cartao} ${borda === "completa" ? s.completa : ""}`}>
      <H className={s.titulo}>{titulo}</H>
      {meta && <p className={s.meta}>{meta}</p>}
      {children && <div className={s.corpo}>{children}</div>}
    </article>
  );
}
