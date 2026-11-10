"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import s from "./Menu.module.css";

export type ItemMenu = { href: string; rotulo: string };

/** Lista do menu, sem depender da URL (serve de fallback enquanto o caminho atual não é conhecido). */
export function MenuLista({
  itens,
  rotulo = "Principal",
  caminho = null,
}: {
  itens: ItemMenu[];
  rotulo?: string;
  caminho?: string | null;
}) {
  return (
    <nav aria-label={rotulo} className={s.menu}>
      <ul>
        {itens.map((i) => {
          const ativo = caminho !== null && (i.href === "/" ? caminho === "/" : caminho.startsWith(i.href));
          return (
            <li key={i.href}>
              <Link href={i.href} aria-current={ativo ? "page" : undefined} className={s.item}>
                {i.rotulo}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}

/** Menu conciso; estado ativo por sublinhado de 2px e aria-current. Use dentro de <Suspense>. */
export function Menu({ itens, rotulo = "Principal" }: { itens: ItemMenu[]; rotulo?: string }) {
  return <MenuLista itens={itens} rotulo={rotulo} caminho={usePathname()} />;
}
