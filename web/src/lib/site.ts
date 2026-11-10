/** URL pública do site (sitemap, links canônicos, Open Graph). Definir NEXT_PUBLIC_SITE_URL no deploy. */
export const URL_SITE = (process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000").replace(/\/$/, "");

/** Serializa JSON-LD sem permitir fechar a tag <script> (recomendação do guia de JSON-LD do Next). */
export function jsonLd(dados: object): string {
  return JSON.stringify(dados).replace(/</g, "\\u003c");
}
