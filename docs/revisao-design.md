# Revisão de design (Fase E)

Revisão do site em 2026-11-10 contra o checklist "O que evitar" do PLANO-DESIGN §12, mais as medições da Fase 5.

## Medições

| Item | Resultado | Como foi medido |
|---|---|---|
| Acessibilidade | 0 violações em 14 páginas × 2 larguras (1280 e 390 px) | axe-core 4, regras WCAG 2.0/2.1/2.2 AA + boas práticas |
| Rolagem lateral no celular | Nenhuma página | largura 390 px |
| LCP | 0,69 s a 0,81 s (meta < 2,5 s) | Chromium com 4G lento simulado (150 ms, 1,6 Mbps) e CPU 4× mais lenta, mediana de 3 rodadas, servidor local |
| CLS | ≤ 0,034 em todas (meta < 0,1); `/explorar` caiu de 0,095 para 0,001 ao reservar o espaço do globo | mesma medição |
| Contraste | todos os pares permitidos passam | `docs/contraste.md` |
| Daltonismo | 1 alerta sem efeito prático hoje (ver abaixo) | `docs/daltonismo.md` |

Ressalva: o LCP foi medido num servidor local. Em produção entram a distância até a Vercel e o tempo de acordar do banco Neon, que dorme após 5 min sem uso (a primeira visita depois de uma pausa pode ser mais lenta). Para medir de novo depois do deploy: o Speed Insights da própria Vercel ou o Lighthouse.

## Checklist "O que evitar"

| Pergunta | Resposta | Evidência / o que fazer |
|---|---|---|
| Parece cópia da Anthropic ou startup de IA genérica? | **Risco moderado.** | O par papel creme (`#F5F1E8`) + terracota (`#B96549`) + títulos serifados lembra a identidade visual da Anthropic e um visual "editorial de IA" que ficou comum. O que diferencia hoje: verde-mata e azul-profundo como cores estruturais, os módulos geométricos inspirados em Athos Bulcão, a paleta própria de dados e o grid assimétrico. **Sugestão (precisa do OK do dono, PLANO-DESIGN §13.3):** dar mais peso ao verde-mata e ao azul-profundo (ex.: faixas de seção, cabeçalho de país) e reduzir a terracota a estados ativos. |
| Virou dashboard sem personalidade ou portal poluído? | Não. | Home editorial primeiro (manchete + cenário), hierarquia por tipografia e espaço, sem caixas e sombras; até 5 itens no menu. |
| Tem clichê (tucano, palmeira, futebol, Carnaval) ou símbolo oficial em excesso? | Não. | Nenhum ícone temático; bandeiras só pequenas, ao lado do nome. A frase "Pátria amada, Brasil." está desligada por padrão. |
| Minimalismo extremo prejudicando usabilidade? | Pontualmente. | Notas de fonte e ressalvas metodológicas usam o menor corpo (`--t-xs`), que passa em contraste mas cansa em leitura longa; ok para metadados. Os botões "Ver os dados em tabela" são discretos de propósito. |
| Elementos modernistas sem função? | Não. | Os módulos geométricos só aparecem como marcadores de seção (no máximo 2 cores, regra testada no componente). Não há grafismo solto. |
| Cor sozinha carregando significado? | Não. | Variação com seta **e** sinal; barras negativas abaixo do zero; "sem dado" hachurado no mapa; séries do comparador com forma de marcador própria e rótulo direto. |

## Daltonismo: o alerta

`--d-3` (verde-água) × `--d-5` (cinza quente) fica com ΔE 8,9 na deuteranopia (limiar 10). Hoje nenhum gráfico usa os dois juntos: o comparador vai até 4 séries (`--d-1` a `--d-4`), e cada série tem forma de marcador. Se um dia houver 5 séries, rever a cor de `--d-5` (troca de paleta precisa do OK do dono).
