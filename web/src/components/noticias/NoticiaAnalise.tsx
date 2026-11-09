import type { Bloco, NoticiaPublicada } from "@/lib/noticias";
import s from "./NoticiaAnalise.module.css";

function dataPt(iso: string): string {
  return new Date(iso).toLocaleDateString("pt-BR", {
    timeZone: "America/Sao_Paulo",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
}

function BlocoNoticia({ rotulo, nota, bloco }: { rotulo: string; nota?: string; bloco: Bloco | null }) {
  if (!bloco) return null;
  return (
    <div className={s.bloco}>
      <p className={s.rotuloBloco}>
        {rotulo}
        {nota && <span className={s.notaBloco}> · {nota}</span>}
      </p>
      <p>{bloco.texto}</p>
    </div>
  );
}

/**
 * Notícia publicada: título e link para o original, resumo próprio e os blocos Fato / Interpretação / Impacto.
 * Interpretação é marcada como análise, não como informação apurada. Rótulo de IA sempre visível.
 */
export function NoticiaAnalise({ n }: { n: NoticiaPublicada }) {
  const todas = [n.fato, n.interpretacao, n.impacto]
    .filter((b): b is Bloco => !!b)
    .flatMap((b) => b.citacoes);
  return (
    <article className={s.noticia} aria-labelledby={`n-${n.id}`}>
      <p className={s.meta}>
        {n.veiculo} · {dataPt(n.publicadoEm)}
      </p>
      <h3 id={`n-${n.id}`} className={s.titulo}>
        <a href={n.url} rel="noopener">
          {n.titulo}
        </a>
      </h3>
      <p className={s.rotuloIa}>
        Resumo gerado por IA e revisado por uma pessoa · baseado só no texto original
      </p>
      <p className={s.resumo}>{n.resumo}</p>
      <div className={s.blocos}>
        <BlocoNoticia rotulo="Fato" bloco={n.fato} />
        <BlocoNoticia rotulo="Interpretação" nota="análise, não informação apurada" bloco={n.interpretacao} />
        <BlocoNoticia rotulo="Impacto" bloco={n.impacto} />
      </div>
      <details className={s.fontes}>
        <summary>Trechos do original usados ({todas.length})</summary>
        <ul>
          {todas.map((c, i) => (
            <li key={i}>“{c.trecho}”</li>
          ))}
        </ul>
      </details>
      <p className={s.atribuicao}>
        Fonte: <a href={n.url}>{n.veiculo}</a>. Leia a reportagem completa no site original.
      </p>
    </article>
  );
}
