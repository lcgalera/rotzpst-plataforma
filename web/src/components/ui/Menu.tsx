"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import s from "./Menu.module.css";

export type ItemMenu = { href: string; rotulo: string };

/** Menu conciso; estado ativo por sublinhado de 2px e aria-current. */
export function Menu({ itens, rotulo = "Principal" }: { itens: ItemMenu[]; rotulo?: string }) {
  const caminho = usePathname();
  return (
    <nav aria-label={rotulo} className={s.menu}>
      <ul>
        {itens.map((i) => {
          const ativo = i.href === "/" ? caminho === "/" : caminho.startsWith(i.href);
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
