# Registro de decisões

Formato: data · decisão · motivo · como reverter. Decisões marcadas [DECISÃO PADRÃO] nos planos estão aplicadas, mas são fáceis de trocar.

## 2026-11-09 · Fase 0

- **Next.js 16 (App Router) + TypeScript, com pasta `web/src/`.** O PLANO-ROTZX mostra `web/app` e `web/styles`; o PLANO-DESIGN pede `web/src/styles/tokens.css`. Como caminho de estilo é assunto de design, segui o PLANO-DESIGN e coloquei tudo sob `src/` (`src/app`, `src/components`, `src/styles`).
- **Gerenciadores:** pnpm no `web/`, uv no `ingest/` (Python ≥ 3.12).
- **Qualidade:** ESLint (config do Next) + Prettier; Ruff (lint e formatação) no Python. Testes com Vitest e pytest. CI no GitHub Actions roda tudo em todo push/PR.
- **Fontes auto-hospedadas** em `web/public/fonts/` (WOFF2, só subset latino, que cobre o português). Arquivos tirados dos pacotes @fontsource; licença SIL OFL 1.1 copiada ao lado. Fraunces é variável (eixos peso e tamanho óptico). Preload só de Fraunces e Plex Sans 400 (máximo 2 famílias iniciais); Plex Mono carrega quando usada. `@font-face` escrito à mão (sem `next/font`) para manter os nomes de família exatamente como em `tokens.css`.
- **`tokens.css` é a fonte única.** A página `/design` e o relatório de contraste leem o arquivo e não copiam valores. Um teste falha se aparecer cor solta (hex, rgb, hsl) fora dele. Exceções aceitas a "nada de tamanho solto": breakpoints (`40rem` tablet e `64rem` desktop, porque CSS não aceita `var()` em media query), valores adimensionais (entrelinha, peso, tracking) e larguras de layout da página de catálogo.
- **Prettier normaliza os hex de `tokens.css` para minúsculas.** Os valores são idênticos aos do plano (o teste compara sem diferenciar maiúsculas).
- **Grid:** `.grade` com 4/6/12 colunas, calha `--e-6` (24px), margem externa `clamp(--e-4, 5vw, --e-24)`, largura máxima 90rem.
- **Relatório de contraste** gerado por script (`pnpm contraste`). O CI falha se o relatório ficar desatualizado, mas **não** falha por par reprovado: os reprovados ficam como pendência de decisão, porque trocar cor exige OK (PLANO-DESIGN 13.3).
- **Fronteiras e nomes disputados:** a definir na Fase 1 junto com a fonte de geometrias.

## 2026-11-09 · Ajustes de contraste (aprovados pelo dono)

- **Ocre saiu da paleta categórica de dados.** Como série sobre papel dava 1,97:1 (meta 3:1). A categórica passa a ter **5 cores**: `--d-1` azul profundo, `--d-2` laranja queimado, `--d-3` verde-água fosco, `--d-4` ameixa, `--d-5` cinza quente (antes `--d-6`, renumerado). `--cor-ocre` continua existindo como detalhe gráfico de marca. Para mais de 5 séries, agrupar em "outros" ou usar destaque seletivo. Desvio do PLANO-DESIGN §6 ("até 6 séries"). Reverter: devolver `--d-5: #D7A64B` e `--d-6: #6B6B63` em `tokens.css`.
- **Link sobre areia é combinação proibida.** `--link` sobre `--cor-areia` dá 4,22:1 (meta 4,5:1). A paleta não muda: blocos em areia não levam link. Se um bloco areia precisar de ação, usar texto `--texto` com sublinhado ou levar o link para fora do bloco. O par fica marcado como `proibido` em `pares-contraste.ts`.
- **CI de contraste ficou mais rígido:** agora falha se qualquer par permitido reprovar.

## 2026-11-09 · Fase 1 (aprovadas pelo dono: "vai com suas recomendações")

- **Banco Mundial (WDI) é a fonte principal** dos indicadores-chave. Uma fonte por indicador, para a série não misturar metodologias.
- **Dívida pública/PIB vem do FMI (WEO)**, porque o WDI tem cobertura fraca (França, China e Japão sem dado; Alemanha só até 1990). É dívida **bruta do governo geral**; o WDI mede o governo central, então são indicadores diferentes e não são misturados.
- **Projeções do FMI nunca entram.** Cada série é cortada no `LATEST_ACTUAL_ANNUAL_DATA` informado pelo próprio FMI por país e indicador. Sem esse marcador, o país fica sem dado.
- **Índia e África do Sul ficam sem dívida/PIB por enquanto.** O FMI marca o último ano observado como `FY2024/25` (ano fiscal), e o apêndice do WEO de out/2026 não diz a que ano da série anual isso corresponde. Até confirmar, aparecem como estado vazio. Reverter: tratar o formato fiscal em `ingest/sources/fmi_weo.py` com a regra confirmada.
- **Termos do FMI** (lidos em [imf.org/en/about/copyright-and-terms](https://www.imf.org/en/about/copyright-and-terms)): uso e redistribuição permitidos com atribuição; **reuso comercial exige permissão** (copyright@imf.org), o que precisa ser revisto antes de qualquer monetização (Fase 6); **download em massa automatizado é proibido sem permissão**, então a ingestão faz consulta dirigida (1 indicador × piloto, só na publicação do WEO, abril e outubro).
- **Acesso ao FMI:** a base completa do WEO saiu de `imf.org` e foi para o IMF Data Portal. A ingestão usa a API SDMX 2.1 em `https://api.imf.org/external/sdmx/2.1` (endereço tirado do registro de fontes da biblioteca `sdmx1` e verificado com consulta real). Os hosts `data.imf.org` e `api.imf.org` foram liberados na rede do ambiente.
- **Saem do MVP:** taxa de juros (o WDI só tem taxa de empréstimo e taxa real, com cobertura ruim; a taxa básica de verdade exigiria o BIS) e IDH (o host do PNUD está bloqueado na rede). Podem voltar depois.
- **Piloto:** 27 países, os 19 países do G20 mais 8 vizinhos do Brasil (a Argentina está nos dois). União Europeia e União Africana ficam fora (não são países). A Guiana Francesa não tem página própria: aparece como parte da França nas fontes. Lista em `ingest/comum/catalogo.py`.
- **Banco:** Postgres local em desenvolvimento e testes. A hospedagem (Supabase ou outra) será decidida no deploy. As migrações são SQL puro em `db/migrations/`, aplicadas por `comum/db.py` (sem ORM).
- **Stack de ingestão mais enxuta que a do plano:** só stdlib (`urllib`, `xml`) + `psycopg` + `pycountry`. pandas e DuckDB não foram necessários para este volume; entram se aparecer transformação pesada.
- **Validação em dois níveis:** `rejeitado` (impossível; não grava) e `alerta` (incomum, como hiperinflação; grava e registra). Faixas largas, para pegar erro de unidade e não para julgar a economia.
- **Falha segura:** cada indicador é gravado numa transação. Se a coleta cair, o banco mantém o último dado válido, e a tabela `coletas` registra o erro.

### Nomes de países e fronteiras
- **Base:** os 249 códigos ISO 3166-1 (via `pycountry`). Kosovo **não** está na base, porque não tem código ISO 3166-1.
- **Nomes em pt-BR:** parte da tradução oficial ISO (pt_BR), com substituições em `ingest/sources/nomes_pt.py` pelo nome curto de uso corrente no Brasil (ex.: "Coreia, República da" → "Coreia do Sul"; "Federação Russa" → "Rússia").
- **Taiwan:** exibido como "Taiwan". A forma ISO em pt_BR ("Taiwan, Província da China") toma partido numa disputa. Não ter região do Banco Mundial (o BM não lista Taiwan) é mostrado como ausência.
- **Palestina:** "Palestina" (ISO: "Palestina, Estado da").
- **Malvinas/Falkland:** mantida a forma ISO pt_BR "Ilhas Malvinas (Falkland)", que registra os dois nomes.
- **Geometrias:** Natural Earth 4.1.0 (fronteiras de facto), 1:50m e 1:110m em `data/geo/`. Kosovo, Chipre do Norte e Somalilândia têm feição no mapa, mas sem código ISO, então não se ligam a nenhuma página de país. Como exibir essas feições é decisão da Fase 2.

## 2026-11-09 · Fase 2: globo

**Decisão: MapLibre GL 6.17 (projeção globo), sem tiles externos.** As geometrias (Natural Earth 1:110m) vêm do próprio site (`/geo/`), então não há custo de licença nem dependência de servidor de mapas.

Teste em protótipos equivalentes: mesma geometria, mesmas cores, seleção por clique e rotação. Feito em Chromium headless com renderização WebGL por software (SwiftShader), 3 rodadas por motor, viewport 1280×900.

| Critério | MapLibre 6.17 | globe.gl 2.46 |
|---|---|---|
| Tempo até o 1º quadro com países | 429–446 ms | 511–582 ms |
| Quadros por segundo girando (5 s) | 16,4–16,9 | 8,2–8,8 |
| JS transferido na página (gzip, inclui o Next) | 416 KB | 681 KB |
| Teclado | setas giram, +/− aproximam (nativo) | nenhum |
| Visual | plano, sem brilho (`atmosphere-blend: 0`) | sombreamento 3D (gradiente), contra o "sem brilho" do design |

- **Ressalva:** o FPS absoluto não representa uma máquina real, porque não há GPU no teste. Vale a comparação relativa (≈2× a favor do MapLibre).
- **Acessibilidade:** nenhum dos dois permite escolher país pelo teclado dentro do canvas. A seleção acessível fica fora do globo: lista de países e mapa plano em SVG, em que cada país do piloto é um link.
- **Ajustes necessários:**
  - O worker do MapLibre 6 é servido como arquivo estático versionado (`public/vendor/`, `pnpm vendor`), porque o bundler não o resolve sozinho.
  - Polígonos que cruzam o antimeridiano (Fiji, Rússia) tiveram as longitudes desdobradas (`desdobrarAnel`), senão aparece uma faixa atravessando o globo.
- **Cores:** oceano `--cor-areia`, terra `--cor-papel`, países com dados completos `--d-seq-2`, selecionado `--cor-azul-profundo`. O WebGL não lê `var()`, então os tokens são lidos do CSS em tempo de execução.
- **Carga sob demanda:** o globo só baixa quando o usuário abre a exploração (`next/dynamic`, `ssr: false`).
- **Coordenada do carregamento:** é o centroide do polígono do Brasil, calculado (`d3.geoCentroid`, Natural Earth 1:110m): **10°39′S 53°10′W**. O valor do exemplo no PLANO-DESIGN (14°14′S 51°55′W) não foi usado porque não tem origem documentada.

## 2026-11-09 · Fase 2: site, componentes e mapas

- **O site lê o Postgres direto no servidor** (`web/src/lib/dados.ts`, biblioteca `postgres`, só leitura) com `'use cache'` + `cacheLife('days')` do Next 16. Toda série sai da view `series_com_fonte`, então nenhum número chega à tela sem fonte e data. As páginas do piloto são geradas no build; as dos demais países são renderizadas na primeira visita e ficam em cache.
- **CI:** o build do site precisa de banco. O CI sobe um Postgres e carrega `db/seeds/ci.sql`, um recorte **real** (catálogo, 249 países e as séries de Brasil, Índia e Venezuela, que cobrem os casos completo, com lacuna e defasado). O arquivo é gerado por `db/seeds/gerar_semente_ci.sh`.
- **Gráficos:** SVG próprio com d3-scale e d3-shape. Não uso Observable Plot, que precisa de DOM no servidor. O servidor já entrega o gráfico desenhado; no cliente ele só se ajusta à largura, sem pular layout.
  - Linha com rótulo direto no último ponto; barras divergentes para crescimento, inflação e balança, a partir de 2000; área para população.
  - Anos ausentes quebram a linha: o gráfico não "liga os pontos" sobre a lacuna.
  - Todo gráfico tem tabela alternativa.
- **Mapa plano:** SVG com projeção Equal Earth (equivalente em área, mais neutra que Mercator), Natural Earth 1:110m, gerado no servidor.
  - Coroplético em 5 quantis da paleta sequencial; "sem dado" é hachurado (nunca só cor).
  - Os 27 países do piloto são links navegáveis por teclado.
  - A Antártida fica de fora, porque ocupa espaço e não tem dados.
- **Defasagem:** o aviso "dado antigo" (mais de 3 anos) é medido contra a data de atualização da própria fonte, não contra o relógio do visitante. Isso também mantém a página determinística no build.
- **Variação nos KPIs:** sempre com seta **e** sinal. A cor é neutra, sem verde/vermelho de "bom/ruim", porque inflação e PIB subindo têm sentidos opostos. Se a variação arredonda para zero, aparece "▬ ±0,0", nunca "▼ −0,0".
- **Bandeiras:** `flag-icons` 7.6.0 (MIT), 250 SVGs copiados para `web/public/flags/`. Exibidas pequenas, ao lado do nome, com `alt` vazio quando o nome já está escrito.
- **Português sem artigo inventado:** os textos evitam "de {país}", porque o artigo varia (do Brasil, da Índia, dos EUA, de Portugal). Usamos construções como "para este país" e "Ver o panorama completo" até existir uma tabela de artigos revisada.
- **Política e Geopolítica:** abas com estado vazio honesto até a Fase 3 (notícias).
- **Acessibilidade:** axe-core (WCAG 2.1 AA + boas práticas) deu **0 violações** em `/`, `/explorar` (globo e mapa plano), `/paises`, `/pais/brasil`, `/pais/india` e `/design`. As abas seguem o padrão WAI-ARIA (setas, Home, End).
- **Rota 404 em streaming:** um slug inexistente devolve status 200 com a página "não encontrada" e `noindex`. É o comportamento do Next com streaming; para SEO, o `noindex` resolve.

## 2026-11-09 · Fase 3: notícias e IA (aprovadas pelo dono)

- **Fontes de notícia: Agência Brasil + GDELT.**
  - **Agência Brasil** é a base do texto. Política de reprodução lida em [agenciabrasil.ebc.com.br/sobre](https://agenciabrasil.ebc.com.br/sobre): reprodução autorizada para veículos de comunicação com fins jornalísticos, com indicação da fonte; **uso comercial exige contato** com licenciamento@ebc.com.br (rever antes de monetizar, Fase 6).
  - **Exclusões na coleta:** os feeds misturam material de parceiros, por exemplo um texto da Reuters marcado "É proibida a reprodução deste conteúdo". A coleta exclui, com motivo registrado, itens "proibida a reprodução", de autor de agência parceira, ou "com informações da/de" agência parceira (Reuters, Lusa, AFP, EFE…).
  - **GDELT** fica como complemento (outras coberturas, só título + link). Deste ambiente, todas as consultas foram recusadas por limite de requisições, provavelmente porque o IP de saída é compartilhado. Integração adiada até poder testar de um servidor próprio.
- **O texto integral fica só no banco, para uso interno da análise. Nunca é exibido.** Os lotes em `data/lotes/` estão no `.gitignore`. No site aparecem título, link, resumo próprio e citações curtas (até 30 palavras cada, no máximo 3 por bloco).
- **IA sem gasto extra:** o dono tem Claude Pro (sem créditos de API) e Google AI Pro (a assinatura não cobre a Gemini API; o Gemini 4 Argon não tem camada gratuita na API). Decisão:
  - **Provedor padrão `agente-claude-code`:** o agente do Claude Code processa os lotes dentro da assinatura. Hoje roda na sessão interativa; depois, como tarefa agendada, quando houver repositório e banco hospedados. Custo de API: zero. Consome o limite da assinatura: o dono atingiu o limite uma vez durante esta fase.
  - **`anthropic-api` e `gemini-api` desligados** (`news/analise/provedores.py`). Nenhum código de SDK do Gemini foi escrito, porque a documentação oficial (ai.google.dev) não pôde ser lida deste ambiente. A interface é a mesma (`lote.json` → `lote.resultado.json`), então ligar e comparar depende só de você decidir pagar, com um teto.
- **Sem agente autônomo por notícia:** a tarefa é fechada (texto → JSON com campos fixos). Usamos instruções fixas (`news/analise/instrucoes.md`) + esquema JSON + validador.
- **Anti-alucinação, em camadas:**
  1. Cada bloco (fato, interpretação, impacto) precisa de 1 a 3 citações **literais**. O validador confere cada trecho contra o texto da fonte (ignorando só aspas tipográficas, travessões e espaços).
  2. O texto próprio não pode copiar mais de 12 palavras seguidas da fonte, para não republicar.
  3. Interpretação e impacto ficam `null` quando o texto não dá base.
  4. Países só da base ISO; temas só `economia`, `politica`, `geopolitica`.
  5. O que reprova no validador entra como `rejeitada` e nunca chega à revisão.
- **Revisão humana obrigatória:** painel `/revisao` com Basic Auth (usuário `revisor`, senha em `REVISAO_SENHA`; sem senha o painel fica fechado). A credencial é conferida de novo dentro da server action, porque o `proxy` do Next é só uma checagem otimista. Só análises **aprovadas** aparecem no site, com o rótulo "Resumo gerado por IA e revisado por uma pessoa" e link para o original.
- **Taxa de erro:** medida na revisão humana, com categorias de erro marcáveis inclusive ao aprovar. O relatório `docs/taxa-erro-ia.md` usa intervalo de Wilson de 95% e avisa quando a amostra tem menos de 20 revisões. Publicação automática só depois de medir (PLANO §6).
- **Agrupamento por evento:** semelhança de títulos (Jaccard ≥ 0,5 em até 72 h). Simples de propósito; a revisão pega o que escapar.

## 2026-11-10 · Fase 3: resultado da primeira revisão humana

- **Amostra:** 20 análises (lote de 09/11/2026), geradas pelo agente do Claude Code (`claude-opus-5-5`). Todas passaram no validador automático. A revisão foi feita pelo dono numa página privada, e as decisões foram importadas com `jobs/importar_revisao.py`.
- **Resultado:** 17 aprovadas, 3 rejeitadas, 1 aprovada com erro marcado. **Taxa de erro: 20,0% (IC 95%: 8,1% a 41,6%)**. As 3 rejeições foram por fato distorcido no bloco de impacto (generalização, exceções omitidas, escopo exagerado). Isso está longe de permitir publicação automática: a revisão humana continua obrigatória.
- **Erros que o validador não pega:** todas as citações eram literais, e mesmo assim houve distorção na *síntese* (causalidade sugerida, condições omitidas, intenção tratada como regra, escopo ampliado). O validador garante a fidelidade das citações, não a da síntese. Por isso a revisão humana é a camada que mede o que importa.
- **Melhoria:** `news/analise/instrucoes.md` passou à versão 2, com 7 regras novas tiradas das notas da revisão. A próxima rodada mede se a taxa cai.
- **Inconsistência na fonte:** na matéria da balança comercial de outubro, US$ 31,51 bi − US$ 24,82 bi = US$ 6,69 bi, mas o texto informa superávit de US$ 9,32 bi. Ficou registrada a decisão do dono sobre publicar.
