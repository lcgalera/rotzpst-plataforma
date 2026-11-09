import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import { PARES } from "../pares-contraste";
import { lerAliases, lerCores, resolverHex } from "../tokens";

const CSS = readFileSync(join(__dirname, "../../styles/tokens.css"), "utf8");

describe("tokens.css", () => {
  it("contém as cores do PLANO-DESIGN.md com os valores exatos", () => {
    const cores = Object.fromEntries(lerCores(CSS).map((c) => [c.nome, c.hex]));
    expect(cores).toMatchObject({
      "cor-papel": "#F5F1E8",
      "cor-areia": "#DDD6C9",
      "cor-grafite": "#252622",
      "cor-grafite-suave": "#55564F",
      "cor-linha": "#D0C9BB",
      "cor-verde-mata": "#355C4B",
      "cor-azul-profundo": "#294D68",
      "cor-terracota": "#B96549",
      "cor-terracota-texto": "#9C4A33",
      "cor-ocre": "#D7A64B",
      "d-1": "#294D68",
      "d-5": "#D7A64B",
      "d-pos": "#2F6F8F",
      "d-neg": "#B4492E",
      "d-seq-5": "#294D68",
    });
  });

  it("resolve aliases semânticos", () => {
    expect(lerAliases(CSS).texto).toBe("cor-grafite");
    expect(resolverHex(CSS, "--link")).toBe("#9C4A33");
    expect(resolverHex(CSS, "foco")).toBe("#294D68");
  });

  it("falha alto para token inexistente", () => {
    expect(() => resolverHex(CSS, "cor-que-nao-existe")).toThrow();
  });

  it("todo par de contraste aponta para tokens existentes", () => {
    for (const p of PARES) {
      expect(() => resolverHex(CSS, p.frente)).not.toThrow();
      expect(() => resolverHex(CSS, p.fundo)).not.toThrow();
    }
  });
});
