import { readdirSync, readFileSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import { describe, expect, it } from "vitest";

/**
 * Regra PLANO-DESIGN 13.2: nada de cores soltas fora de tokens.css.
 * Procura hex, rgb()/hsl() e nomes de cor CSS comuns em .css/.tsx/.ts de src/.
 */
const RAIZ = join(__dirname, "../..");
const PERMITIDOS = new Set(["styles/tokens.css"]);
const IGNORAR_DIRS = new Set(["__tests__"]);

function arquivos(dir: string): string[] {
  return readdirSync(dir).flatMap((n) => {
    const p = join(dir, n);
    if (statSync(p).isDirectory()) return IGNORAR_DIRS.has(n) ? [] : arquivos(p);
    return /\.(css|tsx?)$/.test(n) ? [p] : [];
  });
}

const RE_COR_SOLTA =
  /#[0-9a-fA-F]{3,8}\b|\b(?:rgba?|hsla?|oklch|lab)\(|:\s*(?:white|black|red|blue|green|gray|grey)\b/;

describe("só tokens no visual", () => {
  it("nenhuma cor solta fora de tokens.css", () => {
    const violacoes: string[] = [];
    for (const arq of arquivos(RAIZ)) {
      const rel = relative(RAIZ, arq).replaceAll("\\", "/");
      if (PERMITIDOS.has(rel)) continue;
      readFileSync(arq, "utf8")
        .split("\n")
        .forEach((linha, i) => {
          // ignora ids de âncora tipo href="#tipografia" (não são hex válidos de cor no contexto)
          const semAncoras = linha.replace(/href="#[\w-]+"/g, "");
          if (RE_COR_SOLTA.test(semAncoras)) violacoes.push(`${rel}:${i + 1}: ${linha.trim()}`);
        });
    }
    expect(violacoes).toEqual([]);
  });
});
