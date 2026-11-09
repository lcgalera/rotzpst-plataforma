"""Base de países: ISO 3166-1 (pycountry) + nomes pt-BR revisados + região do Banco Mundial."""

from __future__ import annotations

import gettext
from dataclasses import dataclass

import psycopg
import pycountry

from comum.catalogo import PILOTO
from comum.http import baixar_json
from sources.nomes_pt import NOMES_PT

URL_PAISES_BM = "https://api.worldbank.org/v2/country?format=json&per_page=400"

# Regiões do Banco Mundial (ids da API v2) em português.
REGIOES_PT: dict[str, str] = {
    "EAS": "Leste Asiático e Pacífico",
    "ECS": "Europa e Ásia Central",
    "LCN": "América Latina e Caribe",
    "MEA": "Oriente Médio, Norte da África, Afeganistão e Paquistão",
    "NAC": "América do Norte",
    "SAS": "Sul da Ásia",
    "SSF": "África Subsaariana",
}


@dataclass(frozen=True)
class Pais:
    iso3: str
    iso2: str
    iso_num: str
    nome_pt: str
    nome_en: str
    regiao: str | None
    piloto: bool


def regioes_banco_mundial(resposta: list) -> dict[str, str]:
    """iso3 -> nome da região em pt. Ignora agregados e regiões desconhecidas."""
    _, linhas = resposta
    regioes = {}
    for r in linhas or []:
        rid = r["region"]["id"]
        if rid in REGIOES_PT:
            regioes[r["id"]] = REGIOES_PT[rid]
    return regioes


def montar_paises(regioes: dict[str, str]) -> list[Pais]:
    trad = gettext.translation("iso3166-1", pycountry.LOCALES_DIR, languages=["pt_BR"])
    paises = []
    for c in pycountry.countries:
        nome_en = getattr(c, "common_name", None) or c.name
        paises.append(
            Pais(
                iso3=c.alpha_3,
                iso2=c.alpha_2,
                iso_num=c.numeric,
                nome_pt=NOMES_PT.get(c.alpha_3, trad.gettext(c.name)),
                nome_en=nome_en,
                regiao=regioes.get(c.alpha_3),
                piloto=c.alpha_3 in PILOTO,
            )
        )
    return paises


def gravar_paises(conn: psycopg.Connection, paises: list[Pais], geometrias: set[str]) -> int:
    with conn.transaction(), conn.cursor() as cur:
        for p in paises:
            cur.execute(
                """
                INSERT INTO paises (iso3, iso2, iso_num, nome_pt, nome_en, regiao, piloto, geometria_ref, atualizado_em)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, now())
                ON CONFLICT (iso3) DO UPDATE SET
                    iso2 = EXCLUDED.iso2, iso_num = EXCLUDED.iso_num, nome_pt = EXCLUDED.nome_pt,
                    nome_en = EXCLUDED.nome_en, regiao = EXCLUDED.regiao, piloto = EXCLUDED.piloto,
                    geometria_ref = EXCLUDED.geometria_ref, atualizado_em = now()
                """,
                (
                    p.iso3,
                    p.iso2,
                    p.iso_num,
                    p.nome_pt,
                    p.nome_en,
                    p.regiao,
                    p.piloto,
                    p.iso_num if p.iso_num in geometrias else None,
                ),
            )
    return len(paises)


def carregar(conn: psycopg.Connection, geometrias: set[str]) -> int:
    regioes = regioes_banco_mundial(baixar_json(URL_PAISES_BM))
    return gravar_paises(conn, montar_paises(regioes), geometrias)
