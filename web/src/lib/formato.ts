/** Formatação pt-BR de valores, unidades e datas. Nunca arredonda a ponto de mudar o sentido. */

const nf = (min: number, max: number) =>
  new Intl.NumberFormat("pt-BR", { minimumFractionDigits: min, maximumFractionDigits: max });

const ESCALAS: [number, string][] = [
  [1e12, "tri"],
  [1e9, "bi"],
  [1e6, "mi"],
];

/** Número grande compacto: 2.279.920.092.492 → "2,28 tri". Sinal com o caractere de menos tipográfico. */
export function compacto(v: number): string {
  const abs = Math.abs(v);
  const sinal = v < 0 ? "−" : "";
  for (const [base, sufixo] of ESCALAS) {
    if (abs >= base) return `${sinal}${nf(0, 2).format(abs / base)} ${sufixo}`;
  }
  return `${sinal}${nf(0, 0).format(abs)}`;
}

export type ValorFormatado = { numero: string; unidade: string };

/** Valor + unidade para exibição (a unidade vem separada para ficar menor e suave). */
export function formatarValor(v: number, unidade: string): ValorFormatado {
  switch (unidade) {
    case "USD":
      return { numero: `US$ ${compacto(v)}`.replace("US$ −", "−US$ "), unidade: "" };
    case "%":
      return { numero: menos(nf(1, 1).format(v)), unidade: "%" };
    case "% do PIB":
      return { numero: menos(nf(1, 1).format(v)), unidade: "% do PIB" };
    case "pessoas": {
      if (Math.abs(v) >= 1e9) return { numero: nf(1, 2).format(v / 1e9), unidade: "bilhões de pessoas" };
      if (Math.abs(v) >= 1e6) return { numero: nf(1, 1).format(v / 1e6), unidade: "milhões de pessoas" };
      return { numero: nf(0, 0).format(v), unidade: "pessoas" };
    }
    default:
      return { numero: menos(nf(0, 2).format(v)), unidade };
  }
}

export function formatarValorTexto(v: number, unidade: string): string {
  const f = formatarValor(v, unidade);
  return f.unidade
    ? f.unidade.startsWith("%")
      ? `${f.numero}${f.unidade}`
      : `${f.numero} ${f.unidade}`
    : f.numero;
}

/** Variação com sinal explícito (+/−). Em pontos percentuais para unidades em %. */
export function formatarVariacao(delta: number, unidade: string): string {
  const abs = Math.abs(delta);
  let texto: string;
  if (unidade === "%" || unidade === "% do PIB") texto = `${nf(1, 1).format(abs)} p.p.`;
  else if (unidade === "USD") texto = `US$ ${compacto(abs)}`;
  else if (unidade === "pessoas")
    texto =
      abs >= 1e6
        ? `${compacto(abs)} de pessoas`
        : abs >= 1e3
          ? `${nf(0, 1).format(abs / 1e3)} mil pessoas`
          : `${nf(0, 0).format(abs)} pessoas`;
  else texto = nf(0, 2).format(abs);
  // Sinal decidido pelo que aparece: se arredonda para zero, é "±0", nunca "−0,0".
  const zero = sentidoVariacao(delta, unidade) === 0;
  return `${zero ? "±" : delta > 0 ? "+" : "−"}${texto}`;
}

/** Sentido da variação depois do arredondamento usado na exibição: 1 sobe, −1 desce, 0 estável. */
export function sentidoVariacao(delta: number, unidade: string): -1 | 0 | 1 {
  const casas =
    unidade === "%" || unidade === "% do PIB" ? 1 : unidade === "USD" || unidade === "pessoas" ? -3 : 2;
  const fator = 10 ** casas;
  const arred = Math.round(delta * fator) / fator;
  return arred > 0 ? 1 : arred < 0 ? -1 : 0;
}

/** "2026-10-08" → "08/10/2026". */
export function formatarData(iso: string): string {
  const [a, m, d] = iso.split("-");
  return `${d}/${m}/${a}`;
}

function menos(s: string): string {
  return s.replace(/^-/, "−");
}
