import Link from "next/link";
import type { ComponentProps, ReactNode } from "react";
import s from "./Botao.module.css";

type Variante = "primario" | "secundario" | "terciario";

type Comum = { variante?: Variante; children: ReactNode; className?: string };
type ComoBotao = Comum & Omit<ComponentProps<"button">, "className"> & { href?: undefined };
type ComoLink = Comum & { href: string } & Omit<ComponentProps<typeof Link>, "className" | "href">;

/** Primário: grafite sobre papel, invertido no hover. Secundário: contorno 1px. Terciário: texto sublinhado. */
export function Botao(props: ComoBotao | ComoLink) {
  const { variante = "primario", className, children, ...resto } = props;
  const classe = `${s.botao} ${s[variante]} ${className ?? ""}`;
  if ("href" in resto && resto.href !== undefined) {
    return (
      <Link className={classe} {...(resto as Omit<ComoLink, keyof Comum>)}>
        {children}
      </Link>
    );
  }
  return (
    <button type="button" className={classe} {...(resto as ComponentProps<"button">)}>
      {children}
    </button>
  );
}
