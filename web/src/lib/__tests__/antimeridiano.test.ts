import { describe, expect, it } from "vitest";
import { desdobrarAnel } from "@/components/globo/comum";

describe("antimeridiano", () => {
  it("deixa a longitude contínua ao cruzar ±180°", () => {
    const anel = [
      [179, -16],
      [-179.5, -16.5],
      [-179, -17],
      [179.5, -17],
      [179, -16],
    ];
    const out = desdobrarAnel(anel);
    for (let i = 1; i < out.length; i++) expect(Math.abs(out[i][0] - out[i - 1][0])).toBeLessThan(180);
    expect(out[1][0]).toBeCloseTo(180.5);
  });

  it("não mexe em anel comum", () => {
    const anel = [
      [-50, -10],
      [-40, -10],
      [-45, 0],
      [-50, -10],
    ];
    expect(desdobrarAnel(anel)).toEqual(anel);
  });
});
