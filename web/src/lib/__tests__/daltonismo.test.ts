import { describe, expect, it } from "vitest";
import { deltaE, simular } from "../daltonismo";

describe("simulação de daltonismo", () => {
  it("cinza continua cinza (linhas das matrizes somam 1)", () => {
    for (const t of ["protanopia", "deuteranopia", "tritanopia"] as const) {
      const [r, g, b] = simular("#808080", t);
      expect(Math.abs(r - g)).toBeLessThan(0.01);
      expect(Math.abs(g - b)).toBeLessThan(0.01);
    }
  });

  it("vermelho e verde puros quase se confundem na deuteranopia, mas não na visão normal", () => {
    expect(deltaE("#ff0000", "#00ff00", "normal")).toBeGreaterThan(100);
    expect(deltaE("#ff0000", "#00ff00", "deuteranopia")).toBeLessThan(
      deltaE("#ff0000", "#00ff00", "normal") / 2,
    );
  });

  it("cor igual tem ΔE zero", () => {
    expect(deltaE("#294d68", "#294d68", "tritanopia")).toBe(0);
  });
});
