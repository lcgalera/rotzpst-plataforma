/**
 * Módulos geométricos (inspiração Athos Bulcão): círculo, semicírculo, quarto de círculo e retângulo.
 * Uso: marcador de seção e separador, 1 a 2 cores por vez. Sempre decorativos (aria-hidden).
 */

export type Forma = "circulo" | "semicirculo" | "quarto" | "retangulo";
export type CorModulo = "verde-mata" | "azul-profundo" | "terracota" | "ocre" | "grafite" | "areia";
export type Rotacao = 0 | 90 | 180 | 270;

const CAMINHOS: Record<Forma, string> = {
  circulo: "M50 0a50 50 0 1 1 0 100a50 50 0 1 1 0-100z",
  semicirculo: "M0 100a50 50 0 0 1 100 0z",
  quarto: "M0 0h100a100 100 0 0 1-100 100z",
  retangulo: "M0 0h100v100h-100z",
};

export function Modulo({
  forma,
  cor,
  rotacao = 0,
  tamanho = "var(--e-6)",
}: {
  forma: Forma;
  cor: CorModulo;
  rotacao?: Rotacao;
  tamanho?: string;
}) {
  return (
    <svg
      viewBox="0 0 100 100"
      aria-hidden="true"
      focusable="false"
      style={{ width: tamanho, height: tamanho, display: "block" }}
    >
      <path d={CAMINHOS[forma]} fill={`var(--cor-${cor})`} transform={`rotate(${rotacao} 50 50)`} />
    </svg>
  );
}

/** Composição pequena para abrir seções: até 3 módulos em linha, no máximo 2 cores. */
export function MarcadorSecao({
  modulos,
  tamanho = "var(--e-4)",
}: {
  modulos: { forma: Forma; cor: CorModulo; rotacao?: Rotacao }[];
  tamanho?: string;
}) {
  const cores = new Set(modulos.map((m) => m.cor));
  if (cores.size > 2) throw new Error("MarcadorSecao: use no máximo 2 cores por vez (PLANO-DESIGN §4).");
  return (
    <span aria-hidden="true" style={{ display: "inline-flex", gap: 0, verticalAlign: "middle" }}>
      {modulos.map((m, i) => (
        <Modulo key={i} {...m} tamanho={tamanho} />
      ))}
    </span>
  );
}
