/**
 * Gera docs/contraste.md a partir de tokens.css e da lista de pares.
 * Uso: pnpm contraste            (escreve o relatório)
 *      pnpm contraste --checar   (falha se o relatório estiver desatualizado)
 * Pares reprovados aparecem no relatório como pendência de decisão; trocar cor exige OK (PLANO-DESIGN 13.3).
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { formatarRazao, META, passa, razaoContraste } from "../src/lib/contraste.ts";
import { PARES } from "../src/lib/pares-contraste.ts";
import { resolverHex } from "../src/lib/tokens.ts";

const aqui = dirname(fileURLToPath(import.meta.url));
const css = readFileSync(resolve(aqui, "../src/styles/tokens.css"), "utf8");
const destino = resolve(aqui, "../../docs/contraste.md");

const ROTULO_USO = {
  texto: "Texto normal (4,5:1)",
  "texto-grande": "Texto grande (3:1)",
  interface: "Interface/gráfico (3:1)",
  decorativo: "Decorativo (sem meta)",
} as const;

const linhas = PARES.map((p) => {
  const hf = resolverHex(css, p.frente);
  const hb = resolverHex(css, p.fundo);
  const r = razaoContraste(hf, hb);
  const ok = passa(r, p.uso);
  return { ...p, hf, hb, r, ok };
});

const reprovados = linhas.filter((l) => l.ok === false);

const md = `# Relatório de contraste

> Gerado automaticamente por \`web/scripts/contraste.ts\` a partir de \`web/src/styles/tokens.css\`.
> **Não editar à mão.** Rode \`pnpm contraste\` dentro de \`web/\` para atualizar.

Metas (PLANO-DESIGN.md, seção 2): **${formatarRazao(META.texto!)}** para texto normal; **${formatarRazao(META["texto-grande"]!)}** para texto grande (≥ 24px, ou ≥ 18,66px em negrito) e elementos de interface/gráficos. Pares decorativos são listados só por transparência.

| Frente | Fundo | Razão | Uso | Resultado | Onde |
|---|---|---:|---|---|---|
${linhas
  .map(
    (l) =>
      `| \`--${l.frente}\` ${l.hf} | \`--${l.fundo}\` ${l.hb} | ${formatarRazao(l.r)} | ${ROTULO_USO[l.uso]} | ${
        l.ok === null ? "—" : l.ok ? "✅ passa" : "❌ reprova"
      } | ${l.onde} |`,
  )
  .join("\n")}

## Resumo

- Pares avaliados com meta: ${linhas.filter((l) => l.ok !== null).length}
- Reprovados: ${reprovados.length}${
  reprovados.length
    ? "\n" +
      reprovados
        .map((l) => `  - \`--${l.frente}\` sobre \`--${l.fundo}\` (${formatarRazao(l.r)}): ${l.onde}`)
        .join("\n")
    : ""
}
`;

if (process.argv.includes("--checar")) {
  let atual = "";
  try {
    atual = readFileSync(destino, "utf8");
  } catch {
    /* arquivo ausente conta como desatualizado */
  }
  if (atual !== md) {
    console.error("docs/contraste.md desatualizado. Rode `pnpm contraste`.");
    process.exit(1);
  }
  console.log(`Relatório de contraste em dia (${reprovados.length} reprovado(s) pendente(s)).`);
} else {
  writeFileSync(destino, md);
  console.log(`docs/contraste.md atualizado (${reprovados.length} reprovado(s)).`);
}
