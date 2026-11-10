import { hexParaRgb } from "./contraste.ts";

/**
 * Simulação de daltonismo (Machado, Oliveira & Fernandes, 2009; severidade 1,0), aplicada em RGB linear,
 * e diferença de cor CIE76 (ΔE) em Lab D65. Usada para checar se as cores de séries continuam distinguíveis.
 */
export type Tipo = "normal" | "protanopia" | "deuteranopia" | "tritanopia";

const MATRIZES: Record<Exclude<Tipo, "normal">, number[][]> = {
  protanopia: [
    [0.152286, 1.052583, -0.204868],
    [0.114503, 0.786281, 0.099216],
    [-0.003882, -0.048116, 1.051998],
  ],
  deuteranopia: [
    [0.367322, 0.860646, -0.227968],
    [0.280085, 0.672501, 0.047413],
    [-0.01182, 0.04294, 0.968881],
  ],
  tritanopia: [
    [1.255528, -0.076749, -0.178779],
    [-0.078411, 0.930809, 0.147602],
    [0.004733, 0.691367, 0.3039],
  ],
};

const linear = (c: number) => {
  const v = c / 255;
  return v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4;
};

/** RGB linear (0–1) simulado para o tipo de visão. */
export function simular(hex: string, tipo: Tipo): [number, number, number] {
  const rgb = hexParaRgb(hex).map(linear) as [number, number, number];
  if (tipo === "normal") return rgb;
  const m = MATRIZES[tipo];
  return m.map((l) => Math.min(1, Math.max(0, l[0] * rgb[0] + l[1] * rgb[1] + l[2] * rgb[2]))) as [
    number,
    number,
    number,
  ];
}

function paraLab([r, g, b]: [number, number, number]): [number, number, number] {
  const x = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.95047;
  const y = 0.2126 * r + 0.7152 * g + 0.0722 * b;
  const z = (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.08883;
  const f = (t: number) => (t > 216 / 24389 ? Math.cbrt(t) : ((24389 / 27) * t + 16) / 116);
  const [fx, fy, fz] = [f(x), f(y), f(z)];
  return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}

/** Diferença de cor percebida (CIE76) entre duas cores, sob o tipo de visão. */
export function deltaE(a: string, b: string, tipo: Tipo): number {
  const [l1, a1, b1] = paraLab(simular(a, tipo));
  const [l2, a2, b2] = paraLab(simular(b, tipo));
  return Math.hypot(l1 - l2, a1 - a2, b1 - b2);
}
