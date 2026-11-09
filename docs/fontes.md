# Fontes de dados

> Levantamento da **Fase 1** (2026-11-09). Para cada fonte: o que oferece, formato, frequência, licença/termos e onde isso foi confirmado. "Confirmado" = verificado nesta data na API ou na documentação oficial; "a confirmar" = ainda não verificado, **não integrar** até confirmar.
>
> Rede: o ambiente de desenvolvimento só alcança hosts liberados. Liberados e testados: `api.worldbank.org`, `www.imf.org`, `api.imf.org`, `data.imf.org`, `api.bcb.gov.br`, `olinda.bcb.gov.br`, `apisidra.ibge.gov.br`, `query.wikidata.org`, registros npm e PyPI. Bloqueados no teste: `sdmx.oecd.org`, `servicodados.ibge.gov.br`, `hdr.undp.org`, `naciscdn.org`, `comtradeapi.un.org`.

## Resumo

| Fonte | Uso no rotzx | Formato | Frequência | Licença/termos | Status |
|---|---|---|---|---|---|
| Banco Mundial, World Development Indicators (WDI) | Fonte principal dos indicadores-chave | API REST v2, JSON | Base atualizada periodicamente; `lastupdated` da API em 2026-10-08 | CC BY 4.0 com termos adicionais (atribuição conforme metadados; não sugerir endosso) | **Em uso** |
| FMI, World Economic Outlook (WEO), via IMF Data API (SDMX 2.1) | Dívida pública/PIB (lacuna do WDI) | SDMX 2.1, XML | 2 edições/ano (abr e out); edição atual publicada em 2026-10-13 | Termos de dados do FMI: uso e redistribuição com atribuição; reuso comercial exige permissão; download em massa automatizado proibido | **Em uso** (só anos observados) |
| Banco Central do Brasil, SGS | Brasil em detalhe (ex.: Selic) | API REST, JSON | Varia por série (diária/mensal) | ODbL segundo o catálogo de dados abertos do BCB | Candidata, fora do núcleo do piloto |
| IBGE, SIDRA | Brasil em detalhe | API REST, JSON | Varia por pesquisa | A confirmar | Candidata, fora do núcleo do piloto |
| Natural Earth (via pacote npm `world-atlas` 2.0.2) | Geometrias de países (globo e mapa) | TopoJSON | Estática (Natural Earth 4.1.0) | Natural Earth: domínio público; pacote: ISC | **Em uso** (`data/geo/`) |
| `pycountry` (PyPI, dados ISO 3166 do projeto iso-codes) | Lista ISO 3166-1, códigos alfa-2/alfa-3/numérico | Python | A cada release | LGPL 2.1 (usado só como dependência, sem modificar) | **Em uso**, com nomes pt-BR revisados |
| `flag-icons` (npm 7.6.0) | Bandeiras em SVG | SVG | A cada release | MIT | **Em uso** (`web/public/flags/`) |
| PNUD, IDH | IDH | — | Anual | A confirmar | Fora do MVP por ora (host bloqueado) |
| OCDE, UN Comtrade | — | — | — | — | Não necessárias para o piloto; bloqueadas pela rede |

## Banco Mundial, WDI

- **Documentação/termos:** [Summary Terms of Use](https://data.worldbank.org/summary-terms-of-use), [Termos para datasets](https://www.worldbank.org/ext/en/legal/terms-conditions/datasets), [WDI no Data Catalog](https://datacatalog.worldbank.org/search/dataset/0037712/world-development-indicators).
- **Licença:** CC BY 4.0, salvo indicação em contrário, com termos adicionais: atribuir conforme os metadados ("The World Bank: nome do dataset: fonte original"), não sugerir endosso do Banco Mundial; uso de API permitido.
- **Endpoint usado no teste:** `https://api.worldbank.org/v2/country/{iso3;...}/indicator/{codigo}?format=json&mrnev=1&per_page=500` (`mrnev=1` = valor não vazio mais recente).
- **Metadados do indicador:** `https://api.worldbank.org/v2/indicator/{codigo}?format=json` traz nome, dataset e organização de origem, usados para a atribuição.

Indicadores verificados (nome oficial e organização de origem, conforme a API em 2026-11-09):

| Indicador rotzx | Código WDI | Nome oficial | Origem informada pela API |
|---|---|---|---|
| PIB | `NY.GDP.MKTP.CD` | GDP (current US$) | Estatísticas oficiais nacionais |
| Crescimento do PIB | `NY.GDP.MKTP.KD.ZG` | GDP growth (annual %) | Estatísticas oficiais nacionais |
| PIB per capita | `NY.GDP.PCAP.CD` | GDP per capita (current US$) | Estatísticas oficiais nacionais |
| Inflação | `FP.CPI.TOTL.ZG` | Inflation, consumer prices (annual %) | FMI, International Financial Statistics |
| Desemprego | `SL.UEM.TOTL.ZS` | Unemployment, total (% of total labor force) (**modeled ILO estimate**) | OIT, ILO Modelled Estimates |
| Dívida pública/PIB | `GC.DOD.TOTL.GD.ZS` | Central government debt, total (% of GDP) | FMI, Government Finance Statistics |
| Balança comercial | `NE.RSB.GNFS.CD` | External balance on goods and services (current US$) | Estatísticas oficiais nacionais |
| População | `SP.POP.TOTL` | Population, total | ONU, World Population Prospects |
| Juros (empréstimo) | `FR.INR.LEND` | Lending interest rate (%) | FMI, IFS |
| Juros reais | `FR.INR.RINR` | Real interest rate (%) | FMI, IFS; WDI |

Observações:
- O desemprego do WDI é **estimativa modelada da OIT**: a interface precisa dizer isso.
- "Juros" no WDI são taxa de empréstimo bancário e taxa real, **não** a taxa básica do banco central.
- Balança comercial no WDI inclui bens **e serviços**.

### Cobertura no conjunto piloto (último ano com valor, WDI, consultado em 2026-11-09)

Piloto testado: 19 países do G20 + 8 vizinhos do Brasil fora do G20 (Argentina já está no G20). União Europeia e União Africana (membros do G20) e a Guiana Francesa (território francês) ficaram de fora do teste; ver perguntas abertas.

| País | PIB | Cresc. | PIB pc | Inflação | Desemp. | Dívida/PIB | Balança | Pop. | Juros emp. | Juros reais |
|---|---|---|---|---|---|---|---|---|---|---|
| ARG | 2025 | 2025 | 2025 | 2024 | 2025 | — | 2025 | 2025 | 2025 | 2025 |
| AUS | 2025 | 2025 | 2025 | 2025 | 2025 | 2022 | 2025 | 2025 | 2019 | 2019 |
| BRA | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| CAN | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2017 | 2017 |
| CHN | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2025 | 2025 | 2024 | 2024 |
| FRA | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2025 | 2025 | — | — |
| DEU | 2025 | 2025 | 2025 | 2025 | 2025 | 1990 | 2025 | 2025 | — | — |
| IND | 2025 | 2025 | 2025 | 2025 | 2025 | 2018 | 2025 | 2025 | 2022 | 2022 |
| IDN | 2025 | 2025 | 2025 | 2025 | 2025 | 2009 | 2025 | 2025 | 2025 | 2025 |
| ITA | 2025 | 2025 | 2025 | 2025 | 2025 | 1992 | 2025 | 2025 | 2023 | 2023 |
| JPN | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2024 | 2025 | 2017 | 2017 |
| MEX | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| RUS | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2024 | 2024 |
| SAU | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2025 | 2025 | — | — |
| ZAF | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| KOR | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| TUR | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | — | — |
| GBR | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2014 | 2014 |
| USA | 2025 | 2025 | 2025 | 2024 | 2025 | 2024 | 2024 | 2025 | 2021 | 2021 |
| BOL | 2025 | 2025 | 2025 | 2025 | 2025 | 2001 | 2024 | 2025 | 2025 | 2025 |
| COL | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| GUY | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2005 | 2025 | 2025 | 2025 |
| PRY | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2025 | 2025 | 2021 | 2021 |
| PER | 2025 | 2025 | 2025 | 2025 | 2025 | 2021 | 2025 | 2025 | 2022 | 2022 |
| SUR | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2010 | 2025 | 2025 | 2025 |
| URY | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| VEN | 2025 | 2025 | 2025 | 2016 | 2025 | — | 2025 | 2025 | 2017 | 2017 |

**Leitura:** PIB, crescimento, PIB per capita, desemprego e população têm cobertura completa e recente. Inflação e balança, quase completa (exceções: VEN inflação 2016; GUY e SUR balança antiga). **Dívida/PIB e juros têm cobertura fraca** no WDI.

## FMI, WEO (IMF Data API)

- **Endpoint em uso:** `https://api.imf.org/external/sdmx/2.1/data/IMF.RES,WEO/{ISO3+ISO3...}.{INDICADOR}.A?detail=full` (SDMX 2.1, XML). Base tirada do registro de fontes da biblioteca `sdmx1` (id `IMF_DATA`) e verificada com consulta real. Dataflow `IMF.RES:WEO` versão 9.0.0.
- **Por que não a DataMapper API** (`www.imf.org/external/datamapper/api/v1`): ela devolve até 2031 misturando observado e projeção, sem marcar a diferença.
- **Separação fato × projeção:** o atributo `LATEST_ACTUAL_ANNUAL_DATA` vem no elemento `Group` (país × indicador). Ele substitui a antiga coluna "Estimates Start After", segundo o [guia de transição do WEO](https://data.imf.org/-/media/iData/External-Storage/Documents/DDAF479A0D474D01AA7E1B8435396BFD/en/WEO_Database_Transition_Guide.pdf) (out/2026). Índia e África do Sul vêm em formato fiscal (`FY2024/25`); ver `docs/decisoes.md`.
- **Indicador em uso:** `GGXWDG_NGDP`, dívida bruta do governo geral, % do PIB.
- **Atribuição sugerida pela própria API:** "International Monetary Fund. World Economic Outlook (WEO), https://data.imf.org/en/datasets/IMF.RES:WEO."
- **Termos** ([IMF Copyright and Usage](https://www.imf.org/en/about/copyright-and-terms), seção "Special Terms for Statistical Data", que inclui explicitamente o WEO):
  - Permite baixar, copiar, criar obras derivadas, publicar e distribuir, desde que com atribuição ("Source: International Monetary Fund, Database Name, link").
  - Proíbe alterar o dado de forma que afete sua natureza ou precisão.
  - **Reuso comercial: pedir permissão** a copyright@imf.org.
  - **Proíbe download em massa por tecnologia automatizada** sem permissão explícita.
  - O antigo `imf.org/external/terms.htm` hoje redireciona para uma página 404.

## Banco Central do Brasil, SGS

- **Endpoint testado:** `https://api.bcb.gov.br/dados/serie/bcdata.sgs.{codigo}/dados/ultimos/{n}?formato=json` respondeu 200.
- **Licença:** os registros SGS no portal de dados abertos do BCB indicam ODbL ([exemplo de catálogo](https://dadosabertos.bcb.gov.br/zh_Hant_TW/dataset/29004-sgs/resource/a2fd19ab-75d7-4900-91f0-66fb4c58ab46)). O portal `dadosabertos.bcb.gov.br` não é acessível deste ambiente.
- Códigos de séries específicas (ex.: Selic) **a confirmar** no catálogo antes de usar.

## Geometrias, códigos e nomes

- **Natural Earth:** [termos de uso](https://www.naturalearthdata.com/about/terms-of-use/), domínio público, crédito opcional ("Made with Natural Earth"). Fronteiras **de facto**.
- **`world-atlas` 2.0.2** (npm, ISC): redistribui Natural Earth 4.1.0 em TopoJSON (110m, 50m, 10m). Cada país traz `id` = código ISO 3166-1 **numérico** e `name` em inglês. Em `countries-110m.json` (177 feições), três **não têm código ISO**: Chipre do Norte, Somalilândia e Kosovo.
- **`pycountry`** 26.2.16 (PyPI, LGPL 2.1): 249 países/territórios ISO 3166-1, com traduções pt_BR. As traduções seguem a forma oficial ISO e **não servem direto para exibição**: por exemplo, "Coreia, República da" e "Taiwan, Província da China" (este último é politicamente carregado). Proposta: tabela própria de `nome_pt` revisada, com decisões registradas em `docs/decisoes.md`.
- **`flag-icons`** 7.6.0 (npm, MIT): bandeiras SVG por código alfa-2, em `web/public/flags/` (licença copiada ao lado).

## Fontes de outros recursos
- **Tipografia:** Fraunces, IBM Plex Sans e IBM Plex Mono, via pacotes @fontsource. Licença SIL Open Font License 1.1 (cópias em `web/public/fonts/LICENSE-*.txt`).
