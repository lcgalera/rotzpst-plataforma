import Link from "next/link";
import { Suspense } from "react";
import { Menu, MenuLista } from "@/components/ui/Menu";
import s from "./Cabecalho.module.css";

const ITENS = [
  { href: "/explorar", rotulo: "Explorar" },
  { href: "/paises", rotulo: "Países" },
  { href: "/comparar", rotulo: "Comparar" },
  { href: "/metodologia", rotulo: "Metodologia" },
  { href: "/busca", rotulo: "Buscar" },
];

export function Cabecalho() {
  return (
    <header className={s.cabecalho}>
      <a href="#conteudo" className={s.pular}>
        Pular para o conteúdo
      </a>
      <div className={`container ${s.linha}`}>
        <Link href="/" className={s.marca} aria-label="rotzx, página inicial">
          rotzx
        </Link>
        <Suspense fallback={<MenuLista itens={ITENS} />}>
          <Menu itens={ITENS} />
        </Suspense>
      </div>
    </header>
  );
}

export function Rodape() {
  return (
    <footer className={s.rodape}>
      <div className="container">
        <p>
          Dados: Banco Mundial (World Development Indicators) e FMI (World Economic Outlook). Mapas: Natural
          Earth. Cada número mostra sua fonte e a data de atualização.{" "}
          <Link href="/metodologia">Como trabalhamos</Link> · <Link href="/privacidade">Privacidade</Link>.
        </p>
      </div>
    </footer>
  );
}
