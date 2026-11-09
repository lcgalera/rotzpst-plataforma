import { readFileSync } from "node:fs";
import { join } from "node:path";
import type { Metadata } from "next";
import { formatarRazao, META, passa, razaoContraste } from "@/lib/contraste";
import { PARES } from "@/lib/pares-contraste";
import { lerAliases, lerCores, resolverHex, type TokenCor } from "@/lib/tokens";
import { Componentes } from "./Componentes";
import s from "./design.module.css";

export const metadata: Metadata = {
  title: "Sistema de design",
  description: "Catálogo de cores, tipos, espaçamentos e grid do rotzx (Fase A).",
};

const CSS = readFileSync(join(process.cwd(), "src/styles/tokens.css"), "utf8");
const CORES = new Map(lerCores(CSS).map((c) => [c.nome, c]));
const ALIASES = lerAliases(CSS);
const PAPEL = resolverHex(CSS, "fundo");

/** Agrupamento por nome; os valores vêm sempre de tokens.css. */
const GRUPOS: { titulo: string; nota: string; nomes: string[] }[] = [
  {
    titulo: "Neutros",
    nota: "≈75% da interface.",
    nomes: ["cor-papel", "cor-areia", "cor-grafite", "cor-grafite-suave", "cor-linha"],
  },
  {
    titulo: "Estruturais",
    nota: "≈20%. Blocos, navegação, ênfase.",
    nomes: ["cor-verde-mata", "cor-azul-profundo"],
  },
  {
    titulo: "Destaque",
    nota: "≈5%. Terracota de marca só em elementos grandes; ocre nunca vira texto.",
    nomes: ["cor-terracota", "cor-terracota-texto", "cor-ocre"],
  },
  {
    titulo: "Dados: categórica",
    nota: "Até 5 séries (ocre não entra: some sobre o papel). Nunca depender só da cor: rotular a linha, usar forma ou textura.",
    nomes: ["d-1", "d-2", "d-3", "d-4", "d-5"],
  },
  {
    titulo: "Dados: divergente",
    nota: "Variação positiva/negativa sempre com sinal (+/−) e seta, além da cor.",
    nomes: ["d-pos", "d-neg", "d-neutro"],
  },
  {
    titulo: "Dados: sequencial",
    nota: "Mapas coropléticos, areia → azul profundo.",
    nomes: ["d-seq-1", "d-seq-2", "d-seq-3", "d-seq-4", "d-seq-5"],
  },
];

const ESCALA = [
  { nome: "t-display", amostra: "Brasil", fonte: "titulo" },
  { nome: "t-2xl", amostra: "O cenário global em uma página", fonte: "titulo" },
  { nome: "t-xl", amostra: "Inflação desacelera na zona do euro", fonte: "titulo" },
  { nome: "t-lg", amostra: "Resumo do cenário global desta semana", fonte: "corpo" },
  { nome: "t-base", amostra: "Texto corrido em IBM Plex Sans, 16px, entrelinha 1,6.", fonte: "corpo" },
  { nome: "t-sm", amostra: "Metadados, legendas e rótulos de tabela.", fonte: "corpo" },
  { nome: "t-xs", amostra: "Fonte: FMI, atualizado em 03/11/2026.", fonte: "corpo" },
] as const;

const ESPACOS = ["e-1", "e-2", "e-3", "e-4", "e-6", "e-8", "e-12", "e-16", "e-24"];

/** Veredito só para pares declarados em pares-contraste.ts; o resto é informativo (fundos, preenchimentos). */
function Amostra({ cor }: { cor: TokenCor }) {
  const r = razaoContraste(cor.hex, PAPEL);
  const par = PARES.find((p) => p.frente === cor.nome && resolverHex(CSS, p.fundo) === PAPEL);
  const ok = par ? passa(r, par.uso) : null;
  const ehPapel = cor.hex === PAPEL;
  return (
    <li className={s.amostra}>
      <span className={s.bloco} style={{ background: `var(--${cor.nome})` }} aria-hidden="true" />
      <code className={s.nomeToken}>--{cor.nome}</code>
      <span className="dados">{cor.hex}</span>
      {cor.comentario && <span className="rotulo">{cor.comentario}</span>}
      {!ehPapel && (
        <span className={s.contraste}>
          {formatarRazao(r)} sobre papel{" "}
          {ok === null ? null : ok ? (
            <span>· ✓ passa {formatarRazao(META[par!.uso]!)}</span>
          ) : (
            <strong className={s.reprova}>· ✕ abaixo de {formatarRazao(META[par!.uso]!)}</strong>
          )}
        </span>
      )}
    </li>
  );
}

export default function DesignPage() {
  const pares = PARES.map((p) => ({
    ...p,
    r: razaoContraste(resolverHex(CSS, p.frente), resolverHex(CSS, p.fundo)),
  }));
  const reprovados = pares.filter((p) => !p.proibido && passa(p.r, p.uso) === false);
  const proibidos = pares.filter((p) => p.proibido);

  return (
    <main className="container">
      <header className={`grade ${s.cabecalho}`}>
        <div className="col-7">
          <p className="rotulo">rotzx · Fases A, B e C do design system</p>
          <h1 className="titulo-display">Sistema de design</h1>
        </div>
        <div className={`col-3 ${s.meta}`}>
          <p>
            Cores, tipos, espaçamentos e grid lidos direto de <code>tokens.css</code>. Componentes usam só
            estas variáveis.
          </p>
        </div>
      </header>

      {/* ---------- Cores ---------- */}
      <section className={s.secao} aria-labelledby="cores">
        <h2 id="cores">Cores</h2>
        {GRUPOS.map((g) => (
          <div key={g.titulo} className={s.grupo}>
            <h3>{g.titulo}</h3>
            <p className="rotulo">{g.nota}</p>
            <ul className={s.amostras}>
              {g.nomes.map((n) => {
                const cor = CORES.get(n);
                return cor ? <Amostra key={n} cor={cor} /> : null;
              })}
            </ul>
          </div>
        ))}

        <div className={s.grupo}>
          <h3>Semânticos</h3>
          <dl className={s.semanticos}>
            {Object.entries(ALIASES)
              .filter(([n]) => !n.startsWith("fonte"))
              .map(([nome, alvo]) => (
                <div key={nome}>
                  <dt>
                    <code>--{nome}</code>
                  </dt>
                  <dd>
                    → <code>--{alvo}</code>
                  </dd>
                </div>
              ))}
          </dl>
        </div>

        <aside className={s.aviso} aria-labelledby="contraste-regras">
          <h3 id="contraste-regras">Regras de contraste</h3>
          <p>
            {reprovados.length === 0
              ? "Todos os pares permitidos passam na meta."
              : `${reprovados.length} par(es) permitido(s) reprovado(s): ver docs/contraste.md.`}
          </p>
          <p>Combinações proibidas na interface:</p>
          <ul>
            {proibidos.map((p) => (
              <li key={`${p.frente}-${p.fundo}`}>
                <code>--{p.frente}</code> sobre <code>--{p.fundo}</code>: {formatarRazao(p.r)} ({p.onde})
              </li>
            ))}
            <li>
              <code>--cor-ocre</code> como texto ou como série de dados (só detalhe gráfico)
            </li>
          </ul>
          <p className="rotulo">Relatório completo em docs/contraste.md.</p>
        </aside>
      </section>

      {/* ---------- Tipografia ---------- */}
      <section className={s.secao} aria-labelledby="tipografia">
        <h2 id="tipografia">Tipografia</h2>

        <div className={`grade ${s.familias}`}>
          <div className="col-4">
            <p className={s.familiaTitulo}>Aa</p>
            <p>
              <strong>Fraunces</strong> · títulos
            </p>
            <p className="rotulo">--fonte-titulo · peso médio, tracking negativo, text-wrap: balance</p>
          </div>
          <div className="col-4">
            <p className={s.familiaCorpo}>Aa</p>
            <p>
              <strong>IBM Plex Sans</strong> · corpo, UI, tabelas
            </p>
            <p className="rotulo">--fonte-corpo · 400, 500, 600 e itálico</p>
          </div>
          <div className="col-4">
            <p className={s.familiaDados}>0123</p>
            <p>
              <strong>IBM Plex Mono</strong> · dados (opcional)
            </p>
            <p className="rotulo">--fonte-dados · carrega sob demanda, sem preload</p>
          </div>
        </div>

        <ol className={s.escala}>
          {ESCALA.map((e) => (
            <li key={e.nome}>
              <code className={s.nomeToken}>--{e.nome}</code>
              <span
                className={e.fonte === "titulo" ? s.amostraTitulo : undefined}
                style={{ fontSize: `var(--${e.nome})` }}
              >
                {e.amostra}
              </span>
            </li>
          ))}
        </ol>

        <div className="grade">
          <article className={`col-7 ${s.corpo}`}>
            <p className="rotulo">Exemplo de corpo · texto fictício</p>
            <h3>Por que a defasagem dos dados importa</h3>
            <p>
              Muitas séries econômicas chegam com meses ou anos de atraso. Por isso cada número no rotzx
              mostra o período a que se refere e a data em que a fonte o atualizou. Dado ausente aparece como
              ausente, nunca como estimativa disfarçada.
            </p>
            <p>
              A medida desta coluna fica entre 65 e 72 caracteres, com entrelinha de 1,6, para leitura
              confortável em textos longos. <a href="#tipografia">Links usam a terracota de texto</a>, mais
              escura que a de marca.
            </p>
          </article>
          <aside className={`col-3 ${s.kpiExemplo}`}>
            <p className="rotulo">Indicador · dado fictício</p>
            <p className={s.kpiValor}>
              <span className="num">3,2</span>
              <span className={s.kpiUnidade}>%</span>
            </p>
            <p className={s.kpiVariacao}>
              <span aria-hidden="true">▲</span> <span className="num">+0,4</span> p.p. no ano
            </p>
            <p className="rotulo">Fonte: exemplo fictício, atualizado em 01/01/2026.</p>
          </aside>
        </div>

        <table className={s.tabela}>
          <caption className="rotulo">Números tabulares · valores fictícios</caption>
          <thead>
            <tr>
              <th scope="col">país</th>
              <th scope="col">valor a</th>
              <th scope="col">valor b</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>País A</td>
              <td className="num">1.111,11</td>
              <td className="num">−0,8</td>
            </tr>
            <tr>
              <td>País B</td>
              <td className="num">88.000,00</td>
              <td className="num">+12,5</td>
            </tr>
          </tbody>
        </table>
      </section>

      {/* ---------- Espaçamento ---------- */}
      <section className={s.secao} aria-labelledby="espacamento">
        <h2 id="espacamento">Espaçamento</h2>
        <p className="rotulo">Base 4px.</p>
        <ul className={s.espacos}>
          {ESPACOS.map((e) => (
            <li key={e}>
              <code className={s.nomeToken}>--{e}</code>
              <span className={s.barra} style={{ width: `var(--${e})` }} aria-hidden="true" />
            </li>
          ))}
        </ul>
      </section>

      {/* ---------- Grid ---------- */}
      <section className={s.secao} aria-labelledby="grid">
        <h2 id="grid">Grid</h2>
        <p className="rotulo">12 colunas no desktop, 6 no tablet, 4 no mobile. Calhas de 24px (--e-6).</p>
        <div className={`grade ${s.gradeDemo}`} aria-hidden="true">
          {Array.from({ length: 12 }, (_, i) => (
            <span key={i} className={s.coluna}>
              {i + 1}
            </span>
          ))}
        </div>
        <p className="rotulo">Composição assimétrica controlada: 7 + 3, com 2 de respiro.</p>
        <div className={`grade ${s.assimetrica}`}>
          <div className="col-7">
            <h3>Título em sete colunas</h3>
          </div>
          <div className="col-3">
            <p className="rotulo">Metadados em três colunas. Divisória de 1px, sem sombra.</p>
          </div>
        </div>
      </section>

      <Componentes />

      {/* ---------- Forma, foco e movimento ---------- */}
      <section className={s.secao} aria-labelledby="forma">
        <h2 id="forma">Forma, foco e movimento</h2>
        <div className="grade">
          <div className="col-4">
            <h3>Raio e linha</h3>
            <div className={s.caixaRaio}>--raio: 2px · --linha: 1px</div>
          </div>
          <div className="col-4">
            <h3>Foco</h3>
            <p className="rotulo">Navegue com Tab: anel de 2px em --foco, com offset.</p>
            <button type="button" className={s.botaoDemo}>
              Elemento focável
            </button>
          </div>
          <div className="col-4">
            <h3>Movimento</h3>
            <p className="rotulo">
              --mov-rapido 150ms, --mov-medio 300ms, deslocamento ≤ 8px. Zera com prefers-reduced-motion.
            </p>
            <div className={s.movimento} tabIndex={0}>
              Passe o mouse ou foque
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}
