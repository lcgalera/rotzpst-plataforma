"""Banco Mundial, World Development Indicators (API v2, JSON).

Documentação/termos: ver docs/fontes.md. Um pedido por indicador, todos os países do piloto juntos.
"""

from __future__ import annotations

import datetime as dt

import psycopg

from comum import carga
from comum.carga import Ponto, Resumo
from comum.catalogo import PILOTO, Indicador, indicadores_da_fonte
from comum.http import baixar_json

FONTE_ID = "bm-wdi"
BASE = "https://api.worldbank.org/v2"


def url_indicador(codigo: str, paises: tuple[str, ...], pagina: int = 1) -> str:
    return (
        f"{BASE}/country/{';'.join(paises)}/indicator/{codigo}"
        f"?format=json&per_page=20000&page={pagina}"
    )


def interpretar(resposta: list, indicador: str) -> tuple[list[Ponto], dt.date | None, int]:
    """Converte uma página da API em pontos. Valores nulos são ausência, não zero: são descartados."""
    meta = resposta[0] if resposta else {}
    if "message" in meta or len(resposta) < 2:
        raise RuntimeError(f"Erro da API do Banco Mundial: {meta.get('message', resposta)}")
    linhas = resposta[1] or []
    pontos = [
        Ponto(r["countryiso3code"], indicador, int(r["date"]), float(r["value"]))
        for r in linhas
        if r["value"] is not None and r["countryiso3code"] and r["date"].isdigit()
    ]
    atualizado = dt.date.fromisoformat(meta["lastupdated"]) if meta.get("lastupdated") else None
    return pontos, atualizado, int(meta.get("pages", 1))


def coletar(ind: Indicador, paises: tuple[str, ...] = PILOTO) -> tuple[list[Ponto], dt.date | None]:
    pontos, atualizado, paginas = interpretar(
        baixar_json(url_indicador(ind.codigo_na_fonte, paises)), ind.codigo
    )
    for pag in range(2, paginas + 1):
        extra, _, _ = interpretar(
            baixar_json(url_indicador(ind.codigo_na_fonte, paises, pag)), ind.codigo
        )
        pontos.extend(extra)
    return pontos, atualizado


def carregar(conn: psycopg.Connection, paises: tuple[str, ...] = PILOTO) -> dict[str, Resumo]:
    coleta_id = carga.iniciar_coleta(conn, FONTE_ID)
    resumos: dict[str, Resumo] = {}
    try:
        for ind in indicadores_da_fonte(FONTE_ID):
            pontos, atualizado = coletar(ind, paises)
            resumos[ind.codigo] = carga.gravar_series(
                conn,
                coleta_id,
                FONTE_ID,
                pontos,
                edicao_fonte=f"WDI, atualizado em {atualizado.isoformat()}" if atualizado else None,
                atualizado_na_fonte_em=atualizado,
            )
    except Exception as e:
        carga.encerrar_coleta(conn, coleta_id, linhas=None, erro=repr(e))
        raise
    carga.encerrar_coleta(
        conn, coleta_id, linhas=sum(r.gravados for r in resumos.values()), erro=None
    )
    return resumos
