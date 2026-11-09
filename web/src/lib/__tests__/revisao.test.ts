import { afterEach, describe, expect, it, vi } from "vitest";
import { autorizado } from "../revisao";

const basic = (u: string, p: string) => "Basic " + Buffer.from(`${u}:${p}`).toString("base64");

describe("autorização do painel de revisão", () => {
  afterEach(() => vi.unstubAllEnvs());

  it("nega tudo quando REVISAO_SENHA não está configurada", () => {
    vi.stubEnv("REVISAO_SENHA", "");
    expect(autorizado(basic("revisor", ""))).toBe(false);
  });

  it("aceita só usuário e senha corretos", () => {
    vi.stubEnv("REVISAO_SENHA", "s3gredo");
    expect(autorizado(basic("revisor", "s3gredo"))).toBe(true);
    expect(autorizado(basic("revisor", "errada"))).toBe(false);
    expect(autorizado(basic("admin", "s3gredo"))).toBe(false);
    expect(autorizado(null)).toBe(false);
    expect(autorizado("Bearer abc")).toBe(false);
  });
});
