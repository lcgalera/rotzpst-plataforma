import { describe, expect, it } from "vitest";
import { classe, quebras } from "../classes";

describe("classes do mapa", () => {
  it("5 classes por quantis cobrindo todos os valores", () => {
    const vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    const l = quebras(vals);
    expect(l).toHaveLength(4);
    const cls = vals.map((v) => classe(v, l));
    expect(Math.min(...cls)).toBe(0);
    expect(Math.max(...cls)).toBe(4);
    expect([...cls].sort()).toEqual(cls); // monotônico
  });
});
