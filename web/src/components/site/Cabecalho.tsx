import Link from "next/link";
import { Menu } from "@/components/ui/Menu";
import s from "./Cabecalho.module.css";

const ITENS = [
  { href: "/explorar", rotulo: "Explorar" },
  { href: "/paises", rotulo: "Países" },
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
        <Menu itens={ITENS} />
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
          Earth. Cada número mostra sua fonte e a data de atualização.
        </p>
      </div>
    </footer>
  );
}
