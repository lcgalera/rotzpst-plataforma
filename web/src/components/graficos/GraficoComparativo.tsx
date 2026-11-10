"use client";

import { max, min } from "d3-array";
import { scaleLinear } from "d3-scale";
import { line } from "d3-shape";
import { useEffect, useId, useRef, useState } from "react";
import { compacto, formatarValorTexto } from "@/lib/formato";
import type { Ponto } from "./Grafico";
import s from "./Grafico.module.css";

export type Serie = { nome: string; pontos: Ponto[] };

/** Até 4 séries: cor da paleta de dados + forma do marcador (nunca só cor). */
const CORES = ["var(--d-1)", "var(--d-2)", "var(--d-3)", "var(--d-4)"];
const FORMAS = ["circulo", "quadrado", "triangulo", "losango"] as const;
const ALTURA = 240;
const MARGEM = { topo: 16, base: 28, esquerda: 52 };
const PX_POR_CARACTERE = 7.2;
const ALTURA_ROTULO = 15;

function Marcador({
  forma,
  x,
  y,
  cor,
}: {
  forma: (typeof FORMAS)[number];
  x: number;
  y: number;
  cor: string;
}) {
  const r = 4;
  if (forma === "quadrado") return <rect x={x - r} y={y - r} width={r * 2} height={r * 2} fill={cor} />;
  if (forma === "triangulo")
    return <path d={`M${x},${y - r - 1}L${x + r + 1},${y + r}L${x - r - 1},${y + r}Z`} fill={cor} />;
  if (forma === "losango")
    return (
      <path d={`M${x},${y - r - 1}L${x + r + 1},${y}L${x},${y + r + 1}L${x - r - 1},${y}Z`} fill={cor} />
    );
  return <circle cx={x} cy={y} r={r} fill={cor} />;
}

function trechos(pontos: Ponto[]): Ponto[][] {
  const out: Ponto[][] = [];
  for (const p of pontos) {
    const atual = out.at(-1);
    if (atual && p.periodo - atual.at(-1)!.periodo === 1) atual.push(p);
    else out.push([p]);
  }
  return out;
}

/** Afasta rótulos que se sobrepõem, mantendo a ordem vertical. Exportado para teste. */
export function separarRotulos(ys: number[], minimo: number, topo: number, base: number): number[] {
  const ordem = ys.map((y, i) => ({ y, i })).sort((a, b) => a.y - b.y);
  for (let k = 1; k < ordem.length; k++) {
    if (ordem[k].y - ordem[k - 1].y < minimo) ordem[k].y = ordem[k - 1].y + minimo;
  }
  const excesso = (ordem.at(-1)?.y ?? 0) - base;
  if (excesso > 0) for (const o of ordem) o.y = Math.max(topo, o.y - excesso);
  const out = new Array<number>(ys.length);
  for (const o of ordem) out[o.i] = o.y;
  return out;
}

/** Várias séries na MESMA escala (comparador). Rótulo direto no fim de cada linha. */
export function GraficoComparativo({
  series,
  unidade,
  titulo,
  descricao,
}: {
  series: Serie[];
  unidade: string;
  titulo: string;
  descricao: string;
}) {
  const ref = useRef<HTMLDivElement>(null);
  const [largura, setLargura] = useState(640);
  const idT = useId();
  const idD = useId();
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const ro = new ResizeObserver(([e]) => setLargura(Math.max(280, Math.round(e.contentRect.width))));
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  const comDados = series.filter((x) => x.pontos.length > 0);
  const todos = comDados.flatMap((x) => x.pontos);
  const rotulos = comDados.map((x) => `${x.nome} ${curto(x.pontos.at(-1)!.valor, unidade)}`);
  const margemDireita = Math.ceil(Math.max(...rotulos.map((r) => r.length), 4) * PX_POR_CARACTERE) + 22;
  const W = largura;
  const x0 = MARGEM.esquerda;
  const x1 = W - margemDireita;
  const y0 = MARGEM.topo;
  const y1 = ALTURA - MARGEM.base;

  const a0 = min(todos, (p) => p.periodo)!;
  const a1 = max(todos, (p) => p.periodo)!;
  const vMin = min(todos, (p) => p.valor)!;
  const vMax = max(todos, (p) => p.valor)!;
  const x = scaleLinear().domain([a0, a1]).range([x0, x1]);
  const y = scaleLinear()
    .domain([Math.min(0, vMin), Math.max(0, vMax)])
    .nice(4)
    .range([y1, y0]);
  const ger = line<Ponto>()
    .x((p) => x(p.periodo))
    .y((p) => y(p.valor));
  const passo = Math.max(1, Math.ceil((a1 - a0) / Math.max(2, Math.floor((x1 - x0) / 70))));
  const anos: number[] = [];
  for (let a = a0; a <= a1; a++)
    if (a === a1 || ((a - a0) % passo === 0 && a1 - a >= Math.max(2, passo / 2))) anos.push(a);
  const ysRot = separarRotulos(
    comDados.map((sr) => y(sr.pontos.at(-1)!.valor)),
    ALTURA_ROTULO,
    y0,
    y1,
  );

  return (
    <figure className={s.figura}>
      <div ref={ref} className={s.area} style={{ aspectRatio: `${W} / ${ALTURA}` }}>
        <svg viewBox={`0 0 ${W} ${ALTURA}`} role="img" aria-labelledby={`${idT} ${idD}`} className={s.svg}>
          <title id={idT}>{titulo}</title>
          <desc id={idD}>{descricao}</desc>
          {y.ticks(4).map((t) => (
            <g key={t}>
              <line x1={x0} x2={x1} y1={y(t)} y2={y(t)} className={t === 0 ? s.zero : s.grade} />
              <text x={x0 - 8} y={y(t)} className={s.rotuloY} dominantBaseline="middle" textAnchor="end">
                {curto(t, unidade, true)}
              </text>
            </g>
          ))}
          {anos.map((a) => (
            <text key={a} x={x(a)} y={ALTURA - 8} className={s.rotuloX} textAnchor="middle">
              {a}
            </text>
          ))}
          {comDados.map((sr) => {
            const i = series.indexOf(sr);
            return trechos(sr.pontos).map((t, k) => (
              <path
                key={`${i}-${k}`}
                d={ger(t)!}
                fill="none"
                stroke={CORES[i]}
                strokeWidth={2}
                strokeLinejoin="round"
              />
            ));
          })}
          {comDados.map((sr, j) => {
            const i = series.indexOf(sr);
            const ult = sr.pontos.at(-1)!;
            const xr = x(ult.periodo);
            return (
              <g key={`m-${i}`}>
                <Marcador forma={FORMAS[i]} x={xr} y={y(ult.valor)} cor={CORES[i]} />
                <text x={xr + 10} y={ysRot[j]} dominantBaseline="middle" className={s.rotuloDireto}>
                  {rotulos[j]}
                </text>
              </g>
            );
          })}
        </svg>
      </div>
      <ul className={s.legenda} aria-label="Legenda">
        {series.map((sr, i) => (
          <li key={sr.nome}>
            <svg viewBox="0 0 12 12" width="12" height="12" aria-hidden="true">
              <Marcador forma={FORMAS[i]} x={6} y={6} cor={CORES[i]} />
            </svg>
            {sr.nome}
            {sr.pontos.length === 0 && <span className={s.semDado}> · sem dado</span>}
          </li>
        ))}
      </ul>
      <details className={s.tabela}>
        <summary>Ver os dados em tabela</summary>
        <div style={{ overflowX: "auto" }}>
          <table>
            <caption className="visualmente-oculto">{titulo}</caption>
            <thead>
              <tr>
                <th scope="col">ano</th>
                {series.map((sr) => (
                  <th key={sr.nome} scope="col" className={s.num}>
                    {sr.nome}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {Array.from({ length: a1 - a0 + 1 }, (_, k) => a1 - k).map((a) => (
                <tr key={a}>
                  <th scope="row">{a}</th>
                  {series.map((sr) => {
                    const p = sr.pontos.find((q) => q.periodo === a);
                    return (
                      <td key={sr.nome} className={s.num}>
                        {p ? formatarValorTexto(p.valor, unidade) : "—"}
                      </td>
                    );
                  })}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </details>
    </figure>
  );
}

function curto(v: number, unidade: string, eixo = false): string {
  if (unidade === "USD")
    return (
      (eixo ? "" : "US$ ") + compacto(v).replace(" tri", "tri").replace(" bi", "bi").replace(" mi", "mi")
    );
  if (unidade === "pessoas") return compacto(v).replace(" ", "");
  const n = new Intl.NumberFormat("pt-BR", { maximumFractionDigits: 1 }).format(v).replace(/^-/, "−");
  return eixo ? n : `${n}${unidade.startsWith("%") ? "%" : ""}`;
}
