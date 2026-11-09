# Qualidade e cobertura de dados

> Gerado por `ingest/jobs/relatorio_qualidade.py` a partir do banco em 2026-11-09. **Não editar à mão.**
> Conjunto piloto: 27 países (G20 + vizinhos do Brasil). Defasagem marcada com ⚠️ quando o último ano tem mais de 3 anos.

## Resumo por indicador

| Indicador | Fonte | Edição | Países com dado recente | Sem nenhum dado | Só dado antigo |
|---|---|---|---|---|---|
| PIB | bm-wdi | WDI, atualizado em 2026-10-08 | 27/27 | — | — |
| Crescimento do PIB | bm-wdi | WDI, atualizado em 2026-10-08 | 27/27 | — | — |
| PIB per capita | bm-wdi | WDI, atualizado em 2026-10-08 | 27/27 | — | — |
| Inflação | bm-wdi | WDI, atualizado em 2026-10-08 | 26/27 | — | VEN |
| Desemprego | bm-wdi | WDI, atualizado em 2026-10-08 | 27/27 | — | — |
| Dívida pública | fmi-weo | WEO publicado em 2026-10-13 | 24/27 | IND, ZAF, VEN | — |
| Balança de bens e serviços | bm-wdi | WDI, atualizado em 2026-10-08 | 25/27 | — | GUY, SUR |
| População | bm-wdi | WDI, atualizado em 2026-10-08 | 27/27 | — | — |

## Último ano disponível por país

| País | PIB | Crescimento do PIB | PIB per capita | Inflação | Desemprego | Dívida pública | Balança de bens e serviços | População |
|---|---|---|---|---|---|---|---|---|
| Argentina (ARG) | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2025 | 2025 |
| Austrália (AUS) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Brasil (BRA) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Canadá (CAN) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| China (CHN) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| França (FRA) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Alemanha (DEU) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Índia (IND) | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2025 | 2025 |
| Indonésia (IDN) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Itália (ITA) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Japão (JPN) | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2024 | 2025 |
| México (MEX) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Rússia (RUS) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Arábia Saudita (SAU) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| África do Sul (ZAF) | 2025 | 2025 | 2025 | 2025 | 2025 | — | 2025 | 2025 |
| Coreia do Sul (KOR) | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 |
| Turquia (TUR) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Reino Unido (GBR) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Estados Unidos (USA) | 2025 | 2025 | 2025 | 2024 | 2025 | 2025 | 2024 | 2025 |
| Bolívia (BOL) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2024 | 2025 |
| Colômbia (COL) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Guiana (GUY) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | **2005** ⚠️ | 2025 |
| Paraguai (PRY) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Peru (PER) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Suriname (SUR) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | **2010** ⚠️ | 2025 |
| Uruguai (URY) | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 | 2025 |
| Venezuela (VEN) | 2025 | 2025 | 2025 | **2016** ⚠️ | 2025 | — | 2025 | 2025 |

## Base de países

- Países e territórios ISO 3166-1 na base: 249
- Com geometria (Natural Earth 1:50m): 235. Sem geometria (pequenos demais para a escala ou sem feição própria): 14
- Com região do Banco Mundial: 215. Sem região: 34 (territórios e casos que o Banco Mundial não classifica, como Taiwan)

<details><summary>Sem geometria (14)</summary>

Bonaire, Saba e Santo Eustáquio (BES), Gibraltar (GIB), Guadalupe (GLP), Guiana Francesa (GUF), Ilha Bouvet (BVT), Ilha Christmas (CXR), Ilhas Cocos (CCK), Ilhas Menores Distantes dos Estados Unidos (UMI), Maiote (MYT), Martinica (MTQ), Reunião (REU), Svalbard e a Ilha de Jan Mayen (SJM), Toquelau (TKL), Tuvalu (TUV)

</details>

## Última coleta por fonte

| Fonte | Início | Status | Linhas gravadas | Erro |
|---|---|---|---|---|
| bm-wdi | 2026-11-09 15:18 UTC | ok | 11090 | — |
| fmi-weo | 2026-11-09 15:18 UTC | ok | 778 | — |

## Anomalias da última coleta

Rejeitados (não gravados): 0. Alertas (gravados, para revisão): 58.
Faixas em `ingest/comum/validacao.py`. Alerta não é erro: hiperinflação e choques de PIB são reais, mas merecem conferência.

| Nível | País | Indicador | Ano | Valor | Regra |
|---|---|---|---|---:|---|
| alerta | ARG | inflacao | 2023 | 133,49 | acima de 100 |
| alerta | ARG | inflacao | 2024 | 219,88 | acima de 100 |
| alerta | BOL | inflacao | 1982 | 123,54 | acima de 100 |
| alerta | BOL | inflacao | 1983 | 275,59 | acima de 100 |
| alerta | BOL | inflacao | 1984 | 1.281,35 | acima de 100 |
| alerta | BOL | inflacao | 1985 | 11.749,64 | acima de 100 |
| alerta | BOL | inflacao | 1986 | 276,34 | acima de 100 |
| alerta | BRA | inflacao | 1981 | 101,73 | acima de 100 |
| alerta | BRA | inflacao | 1982 | 100,54 | acima de 100 |
| alerta | BRA | inflacao | 1983 | 135,03 | acima de 100 |
| alerta | BRA | inflacao | 1984 | 192,12 | acima de 100 |
| alerta | BRA | inflacao | 1985 | 225,99 | acima de 100 |
| alerta | BRA | inflacao | 1986 | 147,14 | acima de 100 |
| alerta | BRA | inflacao | 1987 | 228,34 | acima de 100 |
| alerta | BRA | inflacao | 1988 | 629,11 | acima de 100 |
| alerta | BRA | inflacao | 1989 | 1.430,72 | acima de 100 |
| alerta | BRA | inflacao | 1990 | 2.947,73 | acima de 100 |
| alerta | BRA | inflacao | 1991 | 432,79 | acima de 100 |
| alerta | BRA | inflacao | 1992 | 951,96 | acima de 100 |
| alerta | BRA | inflacao | 1993 | 1.927,38 | acima de 100 |
| alerta | BRA | inflacao | 1994 | 2.075,89 | acima de 100 |
| alerta | IDN | inflacao | 1962 | 131,40 | acima de 100 |
| alerta | IDN | inflacao | 1963 | 145,91 | acima de 100 |
| alerta | IDN | inflacao | 1964 | 108,99 | acima de 100 |
| alerta | IDN | inflacao | 1965 | 306,76 | acima de 100 |
| alerta | IDN | inflacao | 1966 | 1.136,25 | acima de 100 |
| alerta | IDN | inflacao | 1967 | 106,00 | acima de 100 |
| alerta | IDN | inflacao | 1968 | 128,84 | acima de 100 |
| alerta | ME. | inflacao | 1983 | 101,87 | acima de 100 |
| alerta | ME. | inflacao | 1987 | 131,83 | acima de 100 |
| alerta | ME. | inflacao | 1988 | 114,16 | acima de 100 |
| alerta | PER | inflacao | 1983 | 111,15 | acima de 100 |
| alerta | PER | inflacao | 1984 | 110,21 | acima de 100 |
| alerta | PER | inflacao | 1985 | 163,40 | acima de 100 |
| alerta | PER | inflacao | 1988 | 667,02 | acima de 100 |
| alerta | PER | inflacao | 1989 | 3.398,68 | acima de 100 |
| alerta | PER | inflacao | 1990 | 7.481,66 | acima de 100 |
| alerta | PER | inflacao | 1991 | 409,53 | acima de 100 |
| alerta | RUS | inflacao | 1993 | 874,25 | acima de 100 |
| alerta | RUS | inflacao | 1994 | 307,72 | acima de 100 |
| alerta | RUS | inflacao | 1995 | 197,41 | acima de 100 |
| alerta | SUR | inflacao | 1993 | 143,51 | acima de 100 |
| alerta | SUR | inflacao | 1994 | 368,48 | acima de 100 |
| alerta | SUR | inflacao | 1995 | 235,56 | acima de 100 |
| alerta | TUR | inflacao | 1994 | 105,22 | acima de 100 |
| alerta | URY | inflacao | 1968 | 125,34 | acima de 100 |
| alerta | URY | inflacao | 1990 | 112,53 | acima de 100 |
| alerta | URY | inflacao | 1991 | 101,97 | acima de 100 |
| alerta | VEN | inflacao | 2015 | 121,74 | acima de 100 |
| alerta | VEN | inflacao | 2016 | 254,95 | acima de 100 |
| alerta | CHN | pib_crescimento | 1961 | -27,27 | abaixo de -20 |
| alerta | GUY | pib_crescimento | 2020 | 43,48 | acima de 30 |
| alerta | GUY | pib_crescimento | 2022 | 63,33 | acima de 30 |
| alerta | GUY | pib_crescimento | 2023 | 33,80 | acima de 30 |
| alerta | GUY | pib_crescimento | 2024 | 43,82 | acima de 30 |
| alerta | SAU | pib_crescimento | 1970 | 52,59 | acima de 30 |
| alerta | VEN | pib_crescimento | 2019 | -27,62 | abaixo de -20 |
| alerta | VEN | pib_crescimento | 2020 | -29,82 | abaixo de -20 |
