/** "Coreia do Sul" → "coreia-do-sul". Usado nas URLs de país (/pais/coreia-do-sul). */
export function slugPais(nome: string): string {
  return nome
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}
