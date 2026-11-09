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
