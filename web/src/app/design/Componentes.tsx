import { Grafico } from "@/components/graficos/Grafico";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { MarcadorSecao, Modulo, type CorModulo, type Forma } from "@/components/grafismo/Modulo";
import { Bandeira } from "@/components/ui/Bandeira";
import { Botao } from "@/components/ui/Botao";
import { Cartao } from "@/components/ui/Cartao";
import { EstadoVazio } from "@/components/ui/EstadoVazio";
import { Kpi } from "@/components/ui/Kpi";
import { Tabela } from "@/components/ui/Tabela";
import s from "./design.module.css";

// Todos os números desta seção são FICTÍCIOS, só para demonstrar os componentes.
const SERIE_FICTICIA = [
  { periodo: 2015, valor: 2.1 },
  { periodo: 2016, valor: -1.4 },
  { periodo: 2017, valor: 0.8 },
  { periodo: 2018, valor: 1.9 },
  { periodo: 2019, valor: 2.4 },
  { periodo: 2020, valor: -3.2 },
  { periodo: 2021, valor: 4.6 },
  { periodo: 2022, valor: 2.9 },
  { periodo: 2023, valor: 2.2 },
];
const FORMAS: Forma[] = ["circulo", "semicirculo", "quarto", "retangulo"];
const CORES: CorModulo[] = ["verde-mata", "azul-profundo", "terracota", "ocre"];

export function Componentes() {
  return (
    <section className={s.secao} aria-labelledby="componentes">
      <h2 id="componentes">Componentes</h2>
      <p className="rotulo">Fase B. Todos os números desta seção são fictícios.</p>

      <div className={s.grupo}>
        <h3>Botões</h3>
        <div className={s.linhaComps}>
          <Botao>Primário</Botao>
          <Botao variante="secundario">Secundário</Botao>
          <Botao variante="terciario">Terciário</Botao>
          <Botao disabled>Desabilitado</Botao>
        </div>
      </div>

      <div className={`grade ${s.grupo}`}>
        <div className="col-4">
          <h3>Cartão</h3>
          <Cartao titulo="Título do cartão em serifa" meta="Metadados em corpo pequeno · fictício">
            <p>Plano, sem sombra, só com a divisória superior.</p>
          </Cartao>
        </div>
        <div className="col-4">
          <h3>Indicador (KPI)</h3>
          <Kpi
            rotulo="Indicador fictício"
            valor={3.2}
            unidade="%"
            periodo={2025}
            anterior={{ periodo: 2024, valor: 2.8 }}
            fonte="Exemplo fictício"
            atualizadoEm="2026-01-01"
          />
        </div>
        <div className="col-4">
          <h3>Bandeira e estado vazio</h3>
          <p className={s.bandeiras}>
            <Bandeira iso2="br" nome="Brasil" /> Brasil · <Bandeira iso2="ar" nome="Argentina" /> Argentina
          </p>
          <EstadoVazio titulo="Ainda não temos dados desse indicador para este país." />
        </div>
      </div>

      <div className={s.grupo}>
        <h3>Tabela ordenável</h3>
        <p className="rotulo">Use Tab até o cabeçalho e Enter para ordenar.</p>
        <Tabela
          legenda="Valores fictícios"
          colunas={[
            { id: "pais", rotulo: "País", ordenavel: true },
            { id: "a", rotulo: "Valor A", numerica: true, ordenavel: true },
            { id: "b", rotulo: "Valor B", numerica: true, ordenavel: true },
          ]}
          linhas={[
            {
              id: "1",
              celulas: {
                pais: { texto: "País A", valor: "País A" },
                a: { texto: "1.111,1", valor: 1111.1 },
                b: { texto: "−0,8", valor: -0.8 },
              },
            },
            {
              id: "2",
              celulas: {
                pais: { texto: "País B", valor: "País B" },
                a: { texto: "88.000,0", valor: 88000 },
                b: { texto: "+12,5", valor: 12.5 },
              },
            },
            {
              id: "3",
              celulas: { pais: { texto: "País C", valor: "País C" }, a: { texto: "540,0", valor: 540 } },
            },
          ]}
        />
      </div>

      <div className={`grade ${s.grupo}`}>
        <div className="col-6">
          <h3>Gráfico de barras (divergente)</h3>
          <Grafico
            pontos={SERIE_FICTICIA}
            unidade="%"
            tipo="barras"
            titulo="Série fictícia, 2015 a 2023"
            descricao="Barras acima e abaixo de zero, dados fictícios."
          />
        </div>
        <div className="col-6">
          <h3>Gráfico de linha com anotação</h3>
          <Grafico
            pontos={SERIE_FICTICIA}
            unidade="%"
            titulo="Série fictícia em linha"
            descricao="Linha com anotação editorial, dados fictícios."
            anotacao={{ periodo: 2020, texto: "Queda fictícia" }}
          />
        </div>
      </div>

      <div className={`grade ${s.grupo}`}>
        <div className="col-6">
          <h3>Módulos geométricos</h3>
          <p className="rotulo">Marcadores de seção e separadores; no máximo 2 cores por vez.</p>
          <div className={s.modulos}>
            {CORES.map((cor) => (
              <div key={cor} className={s.linhaComps}>
                {FORMAS.map((f) => (
                  <Modulo key={f} forma={f} cor={cor} tamanho="var(--e-8)" />
                ))}
              </div>
            ))}
          </div>
          <p className={s.marcadorExemplo}>
            <MarcadorSecao
              modulos={[
                { forma: "semicirculo", cor: "verde-mata" },
                { forma: "quarto", cor: "terracota", rotacao: 90 },
              ]}
            />{" "}
            Marcador de seção
          </p>
        </div>
        <div className="col-6">
          <h3>Carregamento</h3>
          <p className="rotulo">Silhueta do Brasil + centroide calculado. Nunca bloqueia conteúdo.</p>
          <Carregamento rotulo="Exemplo de carregamento" />
        </div>
      </div>
    </section>
  );
}
