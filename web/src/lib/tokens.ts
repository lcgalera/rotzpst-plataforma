/**
 * Lê as variáveis de cor de tokens.css. Mantém tokens.css como fonte única:
 * a página /design e o relatório de contraste derivam daqui, sem cópias de hex.
 */

export type TokenCor = { nome: string; hex: string; comentario?: string };

// Comentário só conta se estiver na mesma linha da declaração ([ \t]*, não \s*).
const RE_COR = /--([a-z0-9-]+)\s*:\s*(#[0-9a-fA-F]{3,6})\s*;[ \t]*(?:\/\*[ \t]*(.*?)[ \t]*\*\/)?/g;
const RE_ALIAS = /--([a-z0-9-]+)\s*:\s*var\(--([a-z0-9-]+)\)\s*;/g;

/** Só o primeiro bloco :root (o de @media reduce redefine movimento, não cor). */
export function lerCores(css: string): TokenCor[] {
  const cores: TokenCor[] = [];
  const vistos = new Set<string>();
  for (const m of css.matchAll(RE_COR)) {
    const [, nome, hex, comentario] = m;
    if (vistos.has(nome)) continue;
    vistos.add(nome);
    cores.push({ nome, hex: hex.toUpperCase(), comentario: comentario || undefined });
  }
  return cores;
}

/** Aliases semânticos (ex.: --texto → --cor-grafite). */
export function lerAliases(css: string): Record<string, string> {
  const aliases: Record<string, string> = {};
  for (const [, nome, alvo] of css.matchAll(RE_ALIAS)) {
    aliases[nome] = alvo;
  }
  return aliases;
}

/** Resolve um token (direto ou alias) para hex. */
export function resolverHex(css: string, nome: string): string {
  const cores = new Map(lerCores(css).map((c) => [c.nome, c.hex]));
  const aliases = lerAliases(css);
  let atual = nome.replace(/^--/, "");
  for (let i = 0; i < 10; i++) {
    const hex = cores.get(atual);
    if (hex) return hex;
    const proximo = aliases[atual];
    if (!proximo) break;
    atual = proximo;
  }
  throw new Error(`Token de cor não encontrado: --${nome}`);
}
