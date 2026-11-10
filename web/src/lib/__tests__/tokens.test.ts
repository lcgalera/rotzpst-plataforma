import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import { passa, razaoContraste } from "../contraste";
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
      "d-5": "#6B6B63",
      "d-pos": "#2F6F8F",
      "d-neg": "#B4492E",
      "d-seq-5": "#294D68",
    });
  });

  it("ocre não é série de dados e a categórica tem 5 cores", () => {
    const nomes = lerCores(CSS).map((c) => c.nome);
    expect(nomes.filter((n) => /^d-\d+$/.test(n))).toEqual(["d-1", "d-2", "d-3", "d-4", "d-5"]);
    const ocre = resolverHex(CSS, "cor-ocre");
    const series = lerCores(CSS).filter((c) => /^d-\d+$/.test(c.nome));
    expect(series.map((c) => c.hex)).not.toContain(ocre);
  });

  it("não pega comentário da linha seguinte", () => {
    const cores = Object.fromEntries(lerCores(CSS).map((c) => [c.nome, c.comentario]));
    expect(cores["cor-azul-profundo"]).toBeUndefined();
    expect(cores["d-neutro"]).toBeUndefined();
    expect(cores["cor-ocre"]).toBe("só detalhe gráfico, nunca texto");
  });

  it("resolve aliases semânticos", () => {
    expect(lerAliases(CSS).texto).toBe("cor-grafite");
    expect(resolverHex(CSS, "--link")).toBe("#294D68");
    expect(resolverHex(CSS, "foco")).toBe("#294D68");
  });

  it("falha alto para token inexistente", () => {
    expect(() => resolverHex(CSS, "cor-que-nao-existe")).toThrow();
  });

  it("todo par permitido passa na meta; proibidos ficam fora da interface", () => {
    for (const p of PARES) {
      const r = razaoContraste(resolverHex(CSS, p.frente), resolverHex(CSS, p.fundo));
      if (!p.proibido) expect(passa(r, p.uso), `${p.frente} sobre ${p.fundo}`).not.toBe(false);
    }
    // Desde 2026-11-10 o link é azul-profundo e passa também sobre areia (antes era proibido).
    const linkAreia = PARES.find((p) => p.frente === "link" && p.fundo === "cor-areia")!;
    expect(linkAreia.proibido).toBeUndefined();
    expect(passa(razaoContraste(resolverHex(CSS, "link"), resolverHex(CSS, "cor-areia")), "texto")).toBe(
      true,
    );
  });

  it("todo par de contraste aponta para tokens existentes", () => {
    for (const p of PARES) {
      expect(() => resolverHex(CSS, p.frente)).not.toThrow();
      expect(() => resolverHex(CSS, p.fundo)).not.toThrow();
    }
  });
});
