import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { MarcadorSecao } from "@/components/grafismo/Modulo";
import { Tabela } from "@/components/ui/Tabela";
import { listarFontes, listarIndicadores, listarPaises } from "@/lib/dados";
import { qualidadeIa, wilson } from "@/lib/noticias";
import s from "./metodologia.module.css";

export const metadata: Metadata = {
  title: "Metodologia e fontes",
  description:
    "De onde vêm os dados do rotzx, como são atualizados, o que fica de fora e como a IA é verificada.",
};

const pct = (x: number) => `${(x * 100).toFixed(1).replace(".", ",")}%`;

function Titulo({ id, children }: { id: string; children: React.ReactNode }) {
  return (
    <h2 id={id} className={s.titulo}>
      <MarcadorSecao modulos={[{ forma: "quarto", cor: "verde-mata" }]} /> {children}
    </h2>
  );
}

async function Conteudo() {
  const [fontes, indicadores, paises, q] = await Promise.all([
    listarFontes(),
    listarIndicadores(),
    listarPaises(),
    qualidadeIa(),
  ]);
  const piloto = paises.filter((p) => p.piloto);
  const [lo, hi] = wilson(q.comErro, q.revisadas);

  return (
    <div className={s.corpo}>
      <section aria-labelledby="principios" className={s.secao}>
        <Titulo id="principios">Princípios</Titulo>
        <ul className={s.lista}>
          <li>
            Todo número mostra a fonte, a data em que a fonte foi atualizada e o período a que se refere.
          </li>
          <li>
            Dado ausente aparece como ausente. Nada é estimado para preencher lacunas, e projeções não entram
            nas séries.
          </li>
          <li>Fato e interpretação ficam separados; a interpretação é marcada como análise.</li>
          <li>
            Conteúdo gerado por IA é rotulado, revisado por uma pessoa antes de publicar e sempre aponta para
            o original.
          </li>
        </ul>
      </section>

      <section aria-labelledby="fontes" className={s.secao}>
        <Titulo id="fontes">Fontes</Titulo>
        <div className={s.fontes}>
          {fontes.map((f) => (
            <article key={f.id} className={s.fonte} aria-labelledby={`f-${f.id}`}>
              <h3 id={`f-${f.id}`}>
                <a href={f.url}>{f.nome}</a>
              </h3>
              <dl>
                <div>
                  <dt>Licença</dt>
                  <dd>
                    <a href={f.licencaUrl}>{f.licenca}</a>
                  </dd>
                </div>
                <div>
                  <dt>Atualização</dt>
                  <dd>{f.frequencia}</dd>
                </div>
                <div>
                  <dt>Como citamos</dt>
                  <dd>{f.atribuicao}</dd>
                </div>
                {f.observacoes && (
                  <div>
                    <dt>Observações</dt>
                    <dd>{f.observacoes}</dd>
                  </div>
                )}
              </dl>
            </article>
          ))}
        </div>
      </section>

      <section aria-labelledby="indicadores" className={s.secao}>
        <Titulo id="indicadores">Indicadores</Titulo>
        <p className={s.texto}>
          Cada indicador tem uma única fonte, para a série não misturar metodologias. Dívida pública vem do
          FMI (governo geral) porque o Banco Mundial cobre pouco os países acompanhados; os demais vêm do
          Banco Mundial.
        </p>
        <Tabela
          legenda="Indicadores e suas fontes"
          colunas={[
            { id: "nome", rotulo: "Indicador", ordenavel: true },
            { id: "unidade", rotulo: "Unidade" },
            { id: "fonte", rotulo: "Fonte", ordenavel: true },
            { id: "codigo", rotulo: "Código na fonte" },
            { id: "nota", rotulo: "Ressalva" },
          ]}
          linhas={indicadores.map((i) => ({
            id: i.codigo,
            celulas: {
              nome: { texto: i.nome, valor: i.nome },
              unidade: { texto: i.unidade, valor: i.unidade },
              fonte: {
                texto: fontes.find((f) => f.id === i.fonteId)?.sigla ?? i.fonteId,
                valor: i.fonteId,
              },
              codigo: { texto: i.codigoNaFonte, valor: null },
              nota: { texto: i.notaMetodologica ?? "—", valor: null },
            },
          }))}
        />
      </section>

      <section aria-labelledby="cobertura" className={s.secao}>
        <Titulo id="cobertura">Cobertura e atualização</Titulo>
        <ul className={s.lista}>
          <li>
            A base tem os {paises.length} países e territórios com código ISO 3166-1. Os {piloto.length}{" "}
            países do G20 e vizinhos do Brasil têm indicadores completos; os demais mostram o que houver.
          </li>
          <li>
            Muitas séries saem com meses ou anos de atraso. Quando o dado mais recente tem mais de 3 anos em
            relação à atualização da fonte, a página avisa.
          </li>
          <li>
            Os valores passam por validação de faixa. Valores incomuns, como hiperinflação, entram e ficam
            registrados para conferência.
          </li>
          <li>Se uma fonte sair do ar, o site continua mostrando o último dado válido, com a data real.</li>
        </ul>
      </section>

      <section aria-labelledby="ia" className={s.secao}>
        <Titulo id="ia">Notícias e inteligência artificial</Titulo>
        <ol className={s.lista}>
          <li>
            Coletamos os feeds de economia, política e internacional da Agência Brasil. Matérias de agências
            parceiras ou marcadas como de reprodução proibida são descartadas.
          </li>
          <li>
            A IA escreve um resumo próprio e separa fato, interpretação e impacto, usando só o texto da
            matéria. Cada bloco traz trechos literais do original; quando não há base, o campo fica vazio.
          </li>
          <li>
            Um validador automático confere cada trecho, letra por letra, e barra cópia longa do texto
            original.
          </li>
          <li>Uma pessoa revisa tudo antes de publicar. Só o que é aprovado aparece no site.</li>
        </ol>
        <div className={s.qualidade} aria-live="polite">
          {q.revisadas > 0 ? (
            <p>
              Taxa de erro medida na revisão humana:{" "}
              <strong className="num">{pct(q.comErro / q.revisadas)}</strong> ({q.comErro} de {q.revisadas}{" "}
              análises revisadas; intervalo de confiança de 95%: {pct(lo)} a {pct(hi)}).{" "}
              {q.revisadas < 50 && "A amostra ainda é pequena, por isso o intervalo é largo."}
            </p>
          ) : (
            <p>A taxa de erro ainda não foi medida: nenhuma análise foi revisada.</p>
          )}
          <p className={s.nota}>
            Conta como erro a análise rejeitada ou aprovada com algum problema marcado pelo revisor.{" "}
            {q.barradasValidador} de {q.geradas} análises geradas foram barradas antes, pelo validador
            automático.
          </p>
        </div>
      </section>

      <section aria-labelledby="mapas" className={s.secao}>
        <Titulo id="mapas">Mapas, nomes e fronteiras</Titulo>
        <ul className={s.lista}>
          <li>
            Os mapas usam o Natural Earth, que traça fronteiras <em>de facto</em>. Territórios sem código ISO
            (Kosovo, Chipre do Norte, Somalilândia) aparecem no mapa sem página própria.
          </li>
          <li>
            Os nomes seguem a forma curta usada no Brasil (Coreia do Sul, Rússia, Taiwan), não a forma oficial
            longa da norma ISO. As escolhas em casos sensíveis estão registradas e são revisáveis.
          </li>
        </ul>
      </section>

      <section aria-labelledby="limites" className={s.secao}>
        <Titulo id="limites">O que ainda não temos</Titulo>
        <ul className={s.lista}>
          <li>
            Taxa básica de juros e IDH ficaram fora por enquanto: as fontes disponíveis não cobrem bem os
            países acompanhados.
          </li>
          <li>
            Índia e África do Sul estão sem dívida pública: o FMI informa o último ano observado delas em ano
            fiscal, e a correspondência com o ano-calendário ainda não foi confirmada.
          </li>
          <li>As notícias vêm de uma única agência por enquanto, com foco no Brasil.</li>
        </ul>
        <p className={s.texto}>
          Encontrou um erro? Os dados vêm das fontes listadas acima; cada página de{" "}
          <Link href="/paises">país</Link> aponta para a origem de cada número.
        </p>
      </section>
    </div>
  );
}

export default function Metodologia() {
  return (
    <main className="container">
      <header style={{ paddingBlock: "var(--e-12) var(--e-6)" }}>
        <p className="rotulo">Metodologia</p>
        <h1>De onde vêm os dados e como verificamos</h1>
      </header>
      <Suspense fallback={<Carregamento />}>
        <Conteudo />
      </Suspense>
    </main>
  );
}
