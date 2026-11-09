import Link from "next/link";
import { classe, quebras } from "@/lib/classes";
import type { Pais, UltimoValor } from "@/lib/dados";
import { formatarData, formatarValorTexto } from "@/lib/formato";
import { ALTURA, formasDoMundo, LARGURA } from "./geometria";
import s from "./MapaPlano.module.css";

const CLASSES = ["--d-seq-1", "--d-seq-2", "--d-seq-3", "--d-seq-4", "--d-seq-5"];

/**
 * Mapa plano coroplético: base neutra, cor só nos países com dado, legenda com fonte e data.
 * Países do piloto são links (navegáveis por teclado). Sem dado = papel com hachura (não só cor).
 */
export function MapaPlano({
  paises,
  valores,
  indicadorNome,
  unidade,
  fonte,
  atualizadoEm,
  destaque,
}: {
  paises: Pais[];
  valores: UltimoValor[];
  indicadorNome: string;
  unidade: string;
  fonte: { sigla: string; url: string } | null;
  atualizadoEm: string | null;
  destaque?: string | null; // iso3
}) {
  const porNum = new Map(paises.map((p) => [p.isoNum, p]));
  const valorPorIso = new Map(valores.map((v) => [v.iso3, v]));
  const limites = quebras(valores.map((v) => v.valor));
  const fmt = (v: number) => formatarValorTexto(v, unidade);

  const faixas = CLASSES.map((cor, i) => {
    const de = i === 0 ? Math.min(...valores.map((v) => v.valor)) : limites[i - 1];
    const ate = i === CLASSES.length - 1 ? Math.max(...valores.map((v) => v.valor)) : limites[i];
    return { cor, de, ate };
  });

  return (
    <figure className={s.figura}>
      <svg
        viewBox={`0 0 ${LARGURA} ${ALTURA}`}
        className={s.mapa}
        role="group"
        aria-label={`Mapa: ${indicadorNome}`}
      >
        <defs>
          <pattern
            id="sem-dado"
            width="6"
            height="6"
            patternUnits="userSpaceOnUse"
            patternTransform="rotate(45)"
          >
            <rect width="6" height="6" className={s.semDadoFundo} />
            <line x1="0" y1="0" x2="0" y2="6" className={s.semDadoLinha} />
          </pattern>
        </defs>
        {formasDoMundo().map((f, i) => {
          const pais = f.id ? porNum.get(f.id) : undefined;
          const v = pais ? valorPorIso.get(pais.iso3) : undefined;
          const preenchimento = v ? `var(${CLASSES[classe(v.valor, limites)]})` : undefined;
          const ehDestaque = pais && destaque === pais.iso3;
          const forma = (
            <path
              d={f.d}
              className={`${s.pais} ${!v ? s.semDado : ""} ${ehDestaque ? s.destaque : ""}`}
              style={preenchimento ? { fill: preenchimento } : undefined}
            />
          );
          if (pais?.piloto) {
            const rotulo = v
              ? `${pais.nome}: ${indicadorNome} ${fmt(v.valor)} em ${v.periodo}`
              : `${pais.nome}: sem dado de ${indicadorNome}`;
            return (
              <Link key={i} href={`/pais/${pais.slug}`} aria-label={rotulo} className={s.link}>
                <title>{rotulo}</title>
                {forma}
              </Link>
            );
          }
          return (
            <g key={i} aria-hidden="true">
              {forma}
            </g>
          );
        })}
      </svg>

      <figcaption className={s.legenda}>
        <p className={s.legendaTitulo}>{indicadorNome} · último ano disponível em cada país</p>
        <ul className={s.faixas}>
          {faixas.map((f) => (
            <li key={f.cor}>
              <span className={s.amostra} style={{ background: `var(${f.cor})` }} aria-hidden="true" />
              <span className="num">
                {fmt(f.de)} a {fmt(f.ate)}
              </span>
            </li>
          ))}
          <li>
            <svg className={s.amostra} aria-hidden="true" viewBox="0 0 12 12">
              <rect width="12" height="12" fill="url(#sem-dado)" />
            </svg>
            <span>sem dado ou fora do piloto</span>
          </li>
        </ul>
        {fonte && (
          <p className={s.fonte}>
            Fonte: <a href={fonte.url}>{fonte.sigla}</a>
            {atualizadoEm ? `, atualizado em ${formatarData(atualizadoEm)}` : ""}. Base cartográfica: Natural
            Earth (fronteiras de facto).
          </p>
        )}
      </figcaption>
    </figure>
  );
}
