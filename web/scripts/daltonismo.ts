/**
 * Gera docs/daltonismo.md: distância entre as cores de dados sob visão normal e 3 tipos de daltonismo.
 * Uso: pnpm daltonismo  |  pnpm daltonismo:checar (falha se o relatório estiver desatualizado)
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { deltaE, type Tipo } from "../src/lib/daltonismo.ts";
import { resolverHex } from "../src/lib/tokens.ts";

const aqui = dirname(fileURLToPath(import.meta.url));
const css = readFileSync(resolve(aqui, "../src/styles/tokens.css"), "utf8");
const destino = resolve(aqui, "../../docs/daltonismo.md");
const TIPOS: Tipo[] = ["normal", "protanopia", "deuteranopia", "tritanopia"];
// Abaixo disso, duas cores são difíceis de separar numa linha fina de gráfico (referência prática de visualização).
const LIMIAR = 10;

const GRUPOS = [
  {
    nome: "Categórica (séries do comparador)",
    tokens: ["d-1", "d-2", "d-3", "d-4", "d-5"],
    mitigacao: "cada série também tem forma de marcador própria e rótulo direto",
  },
  {
    nome: "Divergente (positivo × negativo)",
    tokens: ["d-pos", "d-neg"],
    mitigacao: "posição acima/abaixo do zero e sinal (+/−) no rótulo",
  },
  {
    nome: "Sequencial (mapa)",
    tokens: ["d-seq-1", "d-seq-2", "d-seq-3", "d-seq-4", "d-seq-5"],
    mitigacao: "classes vizinhas; legenda com faixas de valor",
  },
];

const fmt = (x: number) => x.toFixed(1).replace(".", ",");
let md = `# Teste de daltonismo da paleta de dados

> Gerado por \`web/scripts/daltonismo.ts\` a partir de \`tokens.css\`. **Não editar à mão.**
> Simulação de Machado, Oliveira & Fernandes (2009), severidade máxima; diferença de cor CIE76 (ΔE) em Lab.
> Par com ΔE < ${LIMIAR} é marcado com ⚠️: difícil de separar só pela cor numa linha fina.

`;
const alertas: string[] = [];
for (const g of GRUPOS) {
  const pares: [string, string][] = [];
  for (let i = 0; i < g.tokens.length; i++)
    for (let j = i + 1; j < g.tokens.length; j++) {
      if (g.nome.startsWith("Sequencial") && j !== i + 1) continue; // no mapa só importam classes vizinhas
      pares.push([g.tokens[i], g.tokens[j]]);
    }
  md += `## ${g.nome}\n\nAlém da cor: ${g.mitigacao}.\n\n| Par | ${TIPOS.join(" | ")} |\n|---|${TIPOS.map(() => "---:").join("|")}|\n`;
  for (const [a, b] of pares) {
    const ha = resolverHex(css, a);
    const hb = resolverHex(css, b);
    const cel = TIPOS.map((t) => {
      const d = deltaE(ha, hb, t);
      if (d < LIMIAR) alertas.push(`\`--${a}\` × \`--${b}\` em ${t} (ΔE ${fmt(d)})`);
      return `${fmt(d)}${d < LIMIAR ? " ⚠️" : ""}`;
    });
    md += `| \`--${a}\` × \`--${b}\` | ${cel.join(" | ")} |\n`;
  }
  md += "\n";
}
md += `## Resumo\n\n${alertas.length ? alertas.map((a) => `- ⚠️ ${a}`).join("\n") : "Nenhum par abaixo do limiar."}\n`;

if (process.argv.includes("--checar")) {
  let atual = "";
  try {
    atual = readFileSync(destino, "utf8");
  } catch {
    /* ausente = desatualizado */
  }
  if (atual !== md) {
    console.error("docs/daltonismo.md desatualizado. Rode `pnpm daltonismo`.");
    process.exit(1);
  }
  console.log(`Relatório de daltonismo em dia (${alertas.length} alerta(s)).`);
} else {
  writeFileSync(destino, md);
  console.log(`docs/daltonismo.md atualizado (${alertas.length} alerta(s)).`);
}
