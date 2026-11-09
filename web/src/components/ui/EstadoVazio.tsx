import type { ReactNode } from "react";
import s from "./EstadoVazio.module.css";

/** Estado vazio honesto: diz o que falta e, quando houver, por quê. Nunca preenche com estimativa. */
export function EstadoVazio({ titulo, children }: { titulo: string; children?: ReactNode }) {
  return (
    <div className={s.vazio} role="status">
      <p className={s.titulo}>{titulo}</p>
      {children && <div className={s.corpo}>{children}</div>}
    </div>
  );
}
