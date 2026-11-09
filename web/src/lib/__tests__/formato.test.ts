import { describe, expect, it } from "vitest";
import { compacto, formatarData, formatarValor, formatarValorTexto, formatarVariacao } from "../formato";
import { slugPais } from "../slug";

describe("formato pt-BR", () => {
  it("compacta números grandes", () => {
    expect(compacto(2_279_920_092_492)).toBe("2,28 tri");
    expect(compacto(7_978_888_855)).toBe("7,98 bi");
    expect(compacto(-3_500_000)).toBe("−3,5 mi");
    expect(compacto(950)).toBe("950");
  });

  it("formata por unidade", () => {
    expect(formatarValor(2.279e12, "USD").numero).toBe("US$ 2,28 tri");
    expect(formatarValor(-8e9, "USD").numero).toBe("−US$ 8 bi");
    expect(formatarValor(5.0167, "%")).toEqual({ numero: "5,0", unidade: "%" });
    expect(formatarValor(-0.42, "%").numero).toBe("−0,4");
    expect(formatarValor(212_812_405, "pessoas")).toEqual({ numero: "212,8", unidade: "milhões de pessoas" });
    expect(formatarValor(1_438_000_000, "pessoas").unidade).toBe("bilhões de pessoas");
    expect(formatarValorTexto(93.33, "% do PIB")).toBe("93,3% do PIB");
  });

  it("variação sempre com sinal", () => {
    expect(formatarVariacao(0.4, "%")).toBe("+0,4 p.p.");
    expect(formatarVariacao(-1.25, "% do PIB")).toBe("−1,3 p.p.");
    expect(formatarVariacao(0, "%")).toBe("±0,0 p.p.");
    expect(formatarVariacao(-2e11, "USD")).toBe("−US$ 200 bi");
    expect(formatarVariacao(-0.03, "%")).toBe("±0,0 p.p.");
    expect(formatarVariacao(813_832, "pessoas")).toBe("+813,8 mil pessoas");
    expect(formatarVariacao(2_500_000, "pessoas")).toBe("+2,5 mi de pessoas");
  });

  it("data em dd/mm/aaaa", () => {
    expect(formatarData("2026-10-08")).toBe("08/10/2026");
  });

  it("slug de país", () => {
    expect(slugPais("Coreia do Sul")).toBe("coreia-do-sul");
    expect(slugPais("África do Sul")).toBe("africa-do-sul");
    expect(slugPais("Ilhas Malvinas (Falkland)")).toBe("ilhas-malvinas-falkland");
  });
});
