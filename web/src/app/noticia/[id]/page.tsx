import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Suspense } from "react";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { NoticiaAnalise } from "@/components/noticias/NoticiaAnalise";
import { listarPaises } from "@/lib/dados";
import { noticiaPorId } from "@/lib/noticias";
import { jsonLd, URL_SITE } from "@/lib/site";

// Sem generateStaticParams: notícias chegam o tempo todo e a lista pode estar vazia no build
// (com Cache Components, generateStaticParams não pode devolver lista vazia). Cada página é gerada
// na primeira visita e fica em cache (tag "noticias").

export async function generateMetadata(props: PageProps<"/noticia/[id]">): Promise<Metadata> {
  const { id } = await props.params;
  const n = /^\d+$/.test(id) ? await noticiaPorId(Number(id)) : null;
  if (!n) return { title: "Notícia não encontrada" };
  return { title: n.titulo, description: n.resumo };
}

async function Conteudo({ params }: { params: PageProps<"/noticia/[id]">["params"] }) {
  const { id } = await params;
  if (!/^\d+$/.test(id)) notFound();
  const [n, paises] = await Promise.all([noticiaPorId(Number(id)), listarPaises()]);
  if (!n) notFound();
  const relacionados = n.paises
    .map((iso) => paises.find((p) => p.iso3 === iso))
    .filter((p): p is NonNullable<typeof p> => !!p)
    .map(({ iso3, nome, slug }) => ({ iso3, nome, slug }));
  const ld = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: n.titulo,
    abstract: n.resumo,
    inLanguage: "pt-BR",
    url: `${URL_SITE}/noticia/${n.id}`,
    datePublished: n.revisadoEm ?? n.publicadoEm,
    isBasedOn: n.url,
    sourceOrganization: { "@type": "Organization", name: n.veiculo },
    publisher: { "@type": "Organization", name: "rotzx" },
    about: relacionados.map((p) => ({ "@type": "Country", name: p.nome })),
    creditText: "Resumo gerado por IA e revisado por uma pessoa, baseado só no texto original.",
  };
  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLd(ld) }} />
      <NoticiaAnalise n={n} comoPagina paises={relacionados} />
    </>
  );
}

export default function PaginaNoticia(props: PageProps<"/noticia/[id]">) {
  return (
    <main className="container" style={{ paddingBlock: "var(--e-12)" }}>
      <Suspense fallback={<Carregamento />}>
        <Conteudo params={props.params} />
      </Suspense>
    </main>
  );
}
