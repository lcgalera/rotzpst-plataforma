"""Catálogo do rotzx: fontes, indicadores do MVP e conjunto piloto.

Tudo aqui foi verificado na documentação/API oficial em 2026-11-09 (ver docs/fontes.md).
Mudanças neste arquivo são decisões de produto: registrar em docs/decisoes.md.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Fonte:
    id: str
    nome: str
    sigla: str
    url: str
    licenca: str
    licenca_url: str
    atribuicao: str
    frequencia: str
    observacoes: str | None = None


@dataclass(frozen=True)
class Indicador:
    codigo: str
    nome_pt: str
    unidade: str
    categoria: str
    descricao: str
    fonte_id: str
    codigo_na_fonte: str
    nota_metodologica: str | None = None


FONTES: tuple[Fonte, ...] = (
    Fonte(
        id="bm-wdi",
        nome="Banco Mundial, World Development Indicators",
        sigla="Banco Mundial",
        url="https://datacatalog.worldbank.org/search/dataset/0037712/world-development-indicators",
        licenca="CC BY 4.0, com termos adicionais do Banco Mundial",
        licenca_url="https://www.worldbank.org/ext/en/legal/terms-conditions/datasets",
        atribuicao="The World Bank: World Development Indicators",
        frequencia="Atualizações periódicas; data informada pela API (lastupdated)",
        observacoes="Não sugerir endosso do Banco Mundial. Citar também a organização de origem do indicador.",
    ),
    Fonte(
        id="fmi-weo",
        nome="FMI, World Economic Outlook",
        sigla="FMI",
        url="https://data.imf.org/en/datasets/IMF.RES:WEO",
        licenca="Termos de uso de dados do FMI: uso e redistribuição com atribuição; reuso comercial exige permissão",
        licenca_url="https://www.imf.org/en/about/copyright-and-terms",
        atribuicao="International Monetary Fund. World Economic Outlook (WEO), https://data.imf.org/en/datasets/IMF.RES:WEO",
        frequencia="Semestral (abril e outubro)",
        observacoes=(
            "Só anos observados (até LATEST_ACTUAL_ANNUAL_DATA); projeções não são gravadas. "
            "Consulta dirigida via API oficial, sem download em massa."
        ),
    ),
    Fonte(
        id="agencia-brasil",
        nome="Agência Brasil (EBC)",
        sigla="Agência Brasil",
        url="https://agenciabrasil.ebc.com.br",
        licenca=(
            "Reprodução autorizada para veículos de comunicação com fins jornalísticos, mediante indicação "
            "da fonte; uso comercial exige contato com o licenciamento da EBC"
        ),
        licenca_url="https://agenciabrasil.ebc.com.br/sobre",
        atribuicao="Agência Brasil",
        frequencia="Contínua (feeds RSS por editoria)",
        observacoes='Conteúdo de agências parceiras e itens marcados "proibida a reprodução" são excluídos na coleta.',
    ),
    Fonte(
        id="natural-earth",
        nome="Natural Earth (via pacote world-atlas 2.0.2)",
        sigla="Natural Earth",
        url="https://www.naturalearthdata.com/",
        licenca="Domínio público (pacote world-atlas: ISC)",
        licenca_url="https://www.naturalearthdata.com/about/terms-of-use/",
        atribuicao="Made with Natural Earth",
        frequencia="Estática (Natural Earth 4.1.0)",
        observacoes="Fronteiras de facto.",
    ),
    Fonte(
        id="iso-3166",
        nome="ISO 3166-1 (via pycountry / iso-codes)",
        sigla="ISO 3166",
        url="https://pypi.org/project/pycountry/",
        licenca="LGPL 2.1 (pycountry)",
        licenca_url="https://pypi.org/project/pycountry/",
        atribuicao="ISO 3166-1, via pycountry",
        frequencia="A cada versão do pacote",
        observacoes="Nomes em português revisados pelo rotzx (ver ingest/sources/nomes_pt.py).",
    ),
)

INDICADORES: tuple[Indicador, ...] = (
    Indicador(
        "pib",
        "PIB",
        "USD",
        "economia",
        "Produto interno bruto em dólares correntes.",
        "bm-wdi",
        "NY.GDP.MKTP.CD",
    ),
    Indicador(
        "pib_crescimento",
        "Crescimento do PIB",
        "%",
        "economia",
        "Variação anual do PIB real, a preços constantes.",
        "bm-wdi",
        "NY.GDP.MKTP.KD.ZG",
    ),
    Indicador(
        "pib_per_capita",
        "PIB per capita",
        "USD",
        "economia",
        "PIB em dólares correntes dividido pela população.",
        "bm-wdi",
        "NY.GDP.PCAP.CD",
    ),
    Indicador(
        "inflacao",
        "Inflação",
        "%",
        "economia",
        "Variação anual dos preços ao consumidor.",
        "bm-wdi",
        "FP.CPI.TOTL.ZG",
    ),
    Indicador(
        "desemprego",
        "Desemprego",
        "%",
        "social",
        "Desempregados como percentual da força de trabalho.",
        "bm-wdi",
        "SL.UEM.TOTL.ZS",
        "Estimativa modelada da OIT, não o número oficial divulgado pelo país.",
    ),
    Indicador(
        "divida_publica_pib",
        "Dívida pública",
        "% do PIB",
        "economia",
        "Dívida bruta do governo geral como percentual do PIB.",
        "fmi-weo",
        "GGXWDG_NGDP",
        "Governo geral (inclui governos subnacionais). Só anos observados, sem projeções do FMI.",
    ),
    Indicador(
        "balanca_bens_servicos",
        "Balança de bens e serviços",
        "USD",
        "comercio",
        "Exportações menos importações de bens e serviços, em dólares correntes.",
        "bm-wdi",
        "NE.RSB.GNFS.CD",
        "Inclui serviços; não é só a balança comercial de mercadorias.",
    ),
    Indicador(
        "populacao",
        "População",
        "pessoas",
        "social",
        "População total residente.",
        "bm-wdi",
        "SP.POP.TOTL",
    ),
)

# Conjunto piloto: G20 (países-membros) + vizinhos do Brasil.
# União Europeia e União Africana ficam fora (não são países). Guiana Francesa aparece como parte da França.
G20 = [
    "ARG",
    "AUS",
    "BRA",
    "CAN",
    "CHN",
    "FRA",
    "DEU",
    "IND",
    "IDN",
    "ITA",
    "JPN",
    "MEX",
    "RUS",
    "SAU",
    "ZAF",
    "KOR",
    "TUR",
    "GBR",
    "USA",
]
VIZINHOS_BRASIL = ["ARG", "BOL", "COL", "GUY", "PRY", "PER", "SUR", "URY", "VEN"]
PILOTO: tuple[str, ...] = tuple(dict.fromkeys(G20 + VIZINHOS_BRASIL))


def fonte(id_: str) -> Fonte:
    return next(f for f in FONTES if f.id == id_)


def indicadores_da_fonte(fonte_id: str) -> list[Indicador]:
    return [i for i in INDICADORES if i.fonte_id == fonte_id]
