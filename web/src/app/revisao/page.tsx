import type { Metadata } from "next";
import { Suspense } from "react";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { EstadoVazio } from "@/components/ui/EstadoVazio";
import type { Bloco } from "@/lib/noticias";
import { CATEGORIAS_ERRO, contagens, listarPendentes } from "@/lib/revisao";
import { FormRevisao } from "./FormRevisao";
import s from "./revisao.module.css";

export const metadata: Metadata = { title: "Revisão", robots: { index: false, follow: false } };

function BlocoRevisao({ rotulo, bloco }: { rotulo: string; bloco: Bloco | null }) {
  return (
    <div className={s.bloco}>
      <p className={s.rotuloBloco}>{rotulo}</p>
      {bloco ? (
        <>
          <p>{bloco.texto}</p>
          <ul className={s.citacoes}>
            {bloco.citacoes.map((c, i) => (
              <li key={i}>“{c.trecho}”</li>
            ))}
          </ul>
        </>
      ) : (
        <p className={s.vazio}>Vazio: a IA não encontrou base no texto.</p>
      )}
    </div>
  );
}

async function Lista() {
  const [pendentes, cont] = await Promise.all([listarPendentes(), contagens()]);
  return (
    <>
      <p className={s.contagem}>
        {cont.aguardando_revisao ?? 0} aguardando · {cont.aprovada ?? 0} aprovadas · {cont.rejeitada ?? 0}{" "}
        rejeitadas
      </p>
      {pendentes.length === 0 && <EstadoVazio titulo="Nada para revisar agora." />}
      {pendentes.map((p) => (
        <article key={p.id} className={s.item} aria-labelledby={`t-${p.id}`}>
          <p className="rotulo">
            {p.editoria} ·{" "}
            {new Date(p.publicadoEm).toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo" })} ·{" "}
            {p.provedor} ({p.modelo})
          </p>
          <h2 id={`t-${p.id}`} className={s.titulo}>
            <a href={p.url} target="_blank" rel="noreferrer">
              {p.titulo}
            </a>
          </h2>
          <p className={s.meta}>
            Países: {p.paises.join(", ") || "nenhum"} · Temas: {p.temas.join(", ")}
          </p>
          <p className={s.resumo}>{p.resumo}</p>
          <div className={s.blocos}>
            <BlocoRevisao rotulo="Fato" bloco={p.fato} />
            <BlocoRevisao rotulo="Interpretação" bloco={p.interpretacao} />
            <BlocoRevisao rotulo="Impacto" bloco={p.impacto} />
          </div>
          <FormRevisao analiseId={p.id} categorias={CATEGORIAS_ERRO} />
        </article>
      ))}
    </>
  );
}

export default function Revisao() {
  return (
    <main className="container">
      <header style={{ paddingBlock: "var(--e-12) var(--e-6)" }}>
        <p className="rotulo">Uso interno</p>
        <h1>Revisão de análises</h1>
        <p className={s.instrucao}>
          Abra o texto original, confira cada bloco e as citações. Marque todo erro encontrado, mesmo ao
          aprovar: é isso que mede a taxa de erro da IA.
        </p>
      </header>
      <Suspense fallback={<Carregamento />}>
        <Lista />
      </Suspense>
    </main>
  );
}
