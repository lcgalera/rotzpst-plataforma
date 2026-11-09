import { quantile } from "d3-array";

/** Quebras por quantis para o mapa coroplético (5 classes → 4 limites). */
export function quebras(valores: number[]): number[] {
  const ord = [...valores].sort((a, b) => a - b);
  return [0.2, 0.4, 0.6, 0.8].map((q) => quantile(ord, q)!);
}

/** Índice da classe (0..4) de um valor, dados os limites. */
export function classe(v: number, limites: number[]): number {
  let i = 0;
  while (i < limites.length && v > limites[i]) i++;
  return i;
}
