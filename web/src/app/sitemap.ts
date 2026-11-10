import type { MetadataRoute } from "next";
import { listarPaises } from "@/lib/dados";
import { noticiasRecentes } from "@/lib/noticias";
import { URL_SITE } from "@/lib/site";

/** Páginas públicas: fixas, todos os países e as notícias publicadas. Datas vêm dos dados, não do relógio. */
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const [paises, noticias] = await Promise.all([listarPaises(), noticiasRecentes(500)]);
  const fixas = ["", "/explorar", "/paises", "/comparar", "/metodologia", "/privacidade"].map((p) => ({
    url: `${URL_SITE}${p}`,
    changeFrequency: "weekly" as const,
    priority: p === "" ? 1 : 0.6,
  }));
  return [
    ...fixas,
    ...paises.map((p) => ({
      url: `${URL_SITE}/pais/${p.slug}`,
      changeFrequency: "monthly" as const,
      priority: p.piloto ? 0.8 : 0.3,
    })),
    ...noticias.map((n) => ({
      url: `${URL_SITE}/noticia/${n.id}`,
      lastModified: n.revisadoEm ?? n.publicadoEm,
      changeFrequency: "yearly" as const,
      priority: 0.5,
    })),
  ];
}
