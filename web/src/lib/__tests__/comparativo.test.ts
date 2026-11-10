import { describe, expect, it } from "vitest";
import { separarRotulos } from "@/components/graficos/GraficoComparativo";

describe("rótulos diretos do comparador", () => {
  it("afasta rótulos colados mantendo a ordem", () => {
    const out = separarRotulos([100, 102, 104], 15, 0, 300);
    expect(out[1] - out[0]).toBeGreaterThanOrEqual(15);
    expect(out[2] - out[1]).toBeGreaterThanOrEqual(15);
  });

  it("não deixa passar da base", () => {
    const out = separarRotulos([290, 295], 15, 0, 300);
    expect(Math.max(...out)).toBeLessThanOrEqual(300);
  });

  it("não mexe em rótulos já afastados", () => {
    expect(separarRotulos([10, 100], 15, 0, 300)).toEqual([10, 100]);
  });
});
