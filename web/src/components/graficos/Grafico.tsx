"use client";

import { extent, max, min } from "d3-array";
import { scaleBand, scaleLinear } from "d3-scale";
import { area, line } from "d3-shape";
import { useEffect, useId, useRef, useState } from "react";
import { compacto, formatarValorTexto } from "@/lib/formato";
import s from "./Grafico.module.css";

export type Ponto = { periodo: number; valor: number };
export type TipoGrafico = "linha" | "area" | "barras";

const ALTURA = 220;
const MARGEM = { topo: 16, base: 28, esquerda: 52 };
/** Largura aproximada de um caractere do rótulo direto (t-sm, 600), para reservar margem à direita. */
const PX_POR_CARACTERE = 7.5;

/** Divide a série onde falta ano: a linha não "inventa" o trecho ausente. */
function trechos(pontos: Ponto[]): Ponto[][] {
  const out: Ponto[][] = [];
  for (const p of pontos) {
    const atual = out.at(-1);
    if (atual && p.periodo - atual.at(-1)!.periodo === 1) atual.push(p);
    else out.push([p]);
  }
  return out;
}

function rotuloEixo(v: number, unidade: string): string {
  if (unidade === "USD") return compacto(v).replace(" tri", "tri").replace(" bi", "bi").replace(" mi", "mi");
  if (unidade === "pessoas") return compacto(v).replace(" ", "");
  return new Intl.NumberFormat("pt-BR", { maximumFractionDigits: 1 }).format(v).replace(/^-/, "−");
}

/**
 * Gráfico editorial: eixos discretos, linhas finas, rótulo direto no último ponto, destaque seletivo.
 * Sem JS ele já renderiza (largura padrão); no cliente se ajusta à largura do contêiner sem pular layout.
 */
export function Grafico({
  pontos,
  unidade,
  tipo = "linha",
  titulo,
  descricao,
  anotacao,
}: {
  pontos: Ponto[];
  unidade: string;
  tipo?: TipoGrafico;
  titulo: string;
  descricao: string;
  anotacao?: { periodo: number; texto: string } | null;
}) {
  const ref = useRef<HTMLDivElement>(null);
  const [largura, setLargura] = useState(640);
  const idTitulo = useId();
  const idDesc = useId();

  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const ro = new ResizeObserver(([e]) => setLargura(Math.max(280, Math.round(e.contentRect.width))));
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  const ultimo = pontos.at(-1)!;
  const rotuloUltimo = formatarValorTexto(ultimo.valor, unidade)
    .replace(" milhões de pessoas", " mi")
    .replace(" bilhões de pessoas", " bi");
  // O rótulo direto fica à direita do último ponto; a margem cresce com ele para nunca cortar.
  const margemDireita = Math.ceil(rotuloUltimo.length * PX_POR_CARACTERE) + 14;

  const W = largura;
  const H = ALTURA;
  const dentroX0 = MARGEM.esquerda;
  const dentroX1 = W - margemDireita;
  const dentroY0 = MARGEM.topo;
  const dentroY1 = H - MARGEM.base;

  const [p0, p1] = extent(pontos, (p) => p.periodo) as [number, number];
  const vMin = min(pontos, (p) => p.valor)!;
  const vMax = max(pontos, (p) => p.valor)!;
  const incluiZero = tipo !== "linha" || vMin < 0;
  const y = scaleLinear()
    .domain([incluiZero ? Math.min(0, vMin) : vMin, incluiZero ? Math.max(0, vMax) : vMax])
    .nice(4)
    .range([dentroY1, dentroY0]);
  const ticksY = y.ticks(4);

  const anos = pontos.map((p) => p.periodo);
  const xBand = scaleBand<number>().domain(anos).range([dentroX0, dentroX1]).padding(0.25);
  const xLin = scaleLinear().domain([p0, p1]).range([dentroX0, dentroX1]);
  const xDe = (ano: number) => (tipo === "barras" ? xBand(ano)! + xBand.bandwidth() / 2 : xLin(ano));

  const passo = Math.max(1, Math.ceil((p1 - p0) / Math.max(2, Math.floor((dentroX1 - dentroX0) / 70))));
  // Marcas regulares + o último ano; tira a marca regular que ficaria colada no último ano.
  const ticksX = anos.filter((a) => a === p1 || ((a - p0) % passo === 0 && p1 - a >= Math.max(2, passo / 2)));

  const gerLinha = line<Ponto>()
    .x((p) => xDe(p.periodo))
    .y((p) => y(p.valor));
  const gerArea = area<Ponto>()
    .x((p) => xDe(p.periodo))
    .y0(y(0))
    .y1((p) => y(p.valor));

  return (
    <figure className={s.figura}>
      <div ref={ref} className={s.area} style={{ aspectRatio: `${W} / ${H}` }}>
        <svg viewBox={`0 0 ${W} ${H}`} role="img" aria-labelledby={`${idTitulo} ${idDesc}`} className={s.svg}>
          <title id={idTitulo}>{titulo}</title>
          <desc id={idDesc}>{descricao}</desc>

          {/* grade horizontal discreta */}
          {ticksY.map((t) => (
            <g key={t}>
              <line
                x1={dentroX0}
                x2={dentroX1}
                y1={y(t)}
                y2={y(t)}
                className={t === 0 && incluiZero ? s.zero : s.grade}
              />
              <text
                x={dentroX0 - 8}
                y={y(t)}
                className={s.rotuloY}
                dominantBaseline="middle"
                textAnchor="end"
              >
                {rotuloEixo(t, unidade)}
              </text>
            </g>
          ))}
          {ticksX.map((a) => (
            <text key={a} x={xDe(a)} y={H - 8} className={s.rotuloX} textAnchor="middle">
              {a}
            </text>
          ))}

          {tipo === "barras" &&
            pontos.map((p) => (
              <rect
                key={p.periodo}
                x={xBand(p.periodo)}
                width={xBand.bandwidth()}
                y={Math.min(y(p.valor), y(0))}
                height={Math.abs(y(p.valor) - y(0))}
                className={p.valor >= 0 ? s.barraPos : s.barraNeg}
              />
            ))}

          {tipo === "area" &&
            trechos(pontos).map((t, i) => <path key={i} d={gerArea(t)!} className={s.preench} />)}
          {tipo !== "barras" &&
            trechos(pontos).map((t, i) => <path key={i} d={gerLinha(t)!} className={s.linha} />)}

          {/* destaque seletivo: último ponto + rótulo direto */}
          {tipo !== "barras" && (
            <circle cx={xDe(ultimo.periodo)} cy={y(ultimo.valor)} r={3} className={s.ponto} />
          )}
          <text
            x={tipo === "barras" ? xBand(ultimo.periodo)! + xBand.bandwidth() + 6 : xDe(ultimo.periodo) + 8}
            y={y(ultimo.valor)}
            className={s.rotuloDireto}
            dominantBaseline="middle"
            textAnchor="start"
          >
            {rotuloUltimo}
          </text>

          {anotacao && pontos.some((p) => p.periodo === anotacao.periodo) && (
            <g className={s.anotacao}>
              {(() => {
                const pt = pontos.find((p) => p.periodo === anotacao.periodo)!;
                const ax = xDe(pt.periodo);
                const ay = y(pt.valor);
                const acima = ay > (dentroY0 + dentroY1) / 2;
                const ty = acima ? dentroY0 + 4 : dentroY1 - 4;
                return (
                  <>
                    <line x1={ax} x2={ax} y1={ay} y2={ty} />
                    <text x={ax + 6} y={ty} dominantBaseline={acima ? "hanging" : "auto"}>
                      {anotacao.texto}
                    </text>
                  </>
                );
              })()}
            </g>
          )}
        </svg>
      </div>

      <details className={s.tabela}>
        <summary>Ver os dados em tabela</summary>
        <table>
          <caption className="visualmente-oculto">{titulo}</caption>
          <thead>
            <tr>
              <th scope="col">ano</th>
              <th scope="col" className={s.num}>
                valor
              </th>
            </tr>
          </thead>
          <tbody>
            {[...pontos].reverse().map((p) => (
              <tr key={p.periodo}>
                <th scope="row">{p.periodo}</th>
                <td className={s.num}>{formatarValorTexto(p.valor, unidade)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </details>
    </figure>
  );
}
