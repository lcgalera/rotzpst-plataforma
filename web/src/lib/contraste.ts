/**
 * Contraste WCAG 2.x (luminância relativa).
 * https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio
 */

export function hexParaRgb(hex: string): [number, number, number] {
  const limpo = hex.trim().replace(/^#/, "");
  const cheio =
    limpo.length === 3
      ? limpo
          .split("")
          .map((c) => c + c)
          .join("")
      : limpo;
  if (!/^[0-9a-fA-F]{6}$/.test(cheio)) {
    throw new Error(`Cor hexadecimal inválida: ${hex}`);
  }
  return [0, 2, 4].map((i) => parseInt(cheio.slice(i, i + 2), 16)) as [number, number, number];
}

function canalLinear(c8: number): number {
  const c = c8 / 255;
  return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
}

export function luminancia(hex: string): number {
  const [r, g, b] = hexParaRgb(hex).map(canalLinear);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

export function razaoContraste(a: string, b: string): number {
  const la = luminancia(a);
  const lb = luminancia(b);
  const [claro, escuro] = la > lb ? [la, lb] : [lb, la];
  return (claro + 0.05) / (escuro + 0.05);
}

/** Metas do PLANO-DESIGN.md: 4,5:1 texto normal; 3:1 texto grande e elementos de interface. */
export type Uso = "texto" | "texto-grande" | "interface" | "decorativo";

export const META: Record<Uso, number | null> = {
  texto: 4.5,
  "texto-grande": 3,
  interface: 3,
  decorativo: null,
};

export function passa(razao: number, uso: Uso): boolean | null {
  const meta = META[uso];
  return meta === null ? null : razao >= meta;
}

export function formatarRazao(r: number): string {
  return `${r.toFixed(2).replace(".", ",")}:1`;
}
