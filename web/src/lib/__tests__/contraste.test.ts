import { describe, expect, it } from "vitest";
import { formatarRazao, hexParaRgb, luminancia, passa, razaoContraste } from "../contraste";

describe("contraste WCAG", () => {
  it("converte hex curto e longo", () => {
    expect(hexParaRgb("#fff")).toEqual([255, 255, 255]);
    expect(hexParaRgb("#294D68")).toEqual([41, 77, 104]);
  });

  it("rejeita hex inválido", () => {
    expect(() => hexParaRgb("#12")).toThrow();
    expect(() => hexParaRgb("azul")).toThrow();
  });

  it("calcula luminância nos extremos", () => {
    expect(luminancia("#000000")).toBe(0);
    expect(luminancia("#FFFFFF")).toBeCloseTo(1, 10);
  });

  it("preto sobre branco é 21:1 e é simétrico", () => {
    expect(razaoContraste("#000", "#fff")).toBeCloseTo(21, 5);
    expect(razaoContraste("#fff", "#000")).toBeCloseTo(21, 5);
  });

  it("bate com valor de referência conhecido (#767676 sobre branco ≈ 4,54)", () => {
    expect(razaoContraste("#767676", "#FFFFFF")).toBeCloseTo(4.54, 2);
  });

  it("aplica as metas por uso", () => {
    expect(passa(4.5, "texto")).toBe(true);
    expect(passa(4.49, "texto")).toBe(false);
    expect(passa(3, "interface")).toBe(true);
    expect(passa(1, "decorativo")).toBeNull();
  });

  it("formata em pt-BR", () => {
    expect(formatarRazao(4.5)).toBe("4,50:1");
  });
});
