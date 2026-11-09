"""FMI, World Economic Outlook, via IMF Data API (SDMX 2.1, XML).

- Base: https://api.imf.org/external/sdmx/2.1 (dataflow IMF.RES,WEO).
- Só grava anos <= LATEST_ACTUAL_ANNUAL_DATA (atributo por país × indicador). O resto é projeção.
- Sem LATEST_ACTUAL_ANNUAL_DATA em ano-calendário, o país é descartado: não dá para separar fato de projeção.
  Ex.: Índia e África do Sul vêm como 'FY2024/25' (ano fiscal) e o apêndice do WEO não diz a que coluna anual
  isso corresponde. Até confirmar, ficam sem dado (estado vazio honesto).
- Termos: uso e redistribuição com atribuição; download em massa automatizado é proibido sem permissão.
  Por isso a consulta é dirigida (um indicador, países do piloto), duas vezes por ano.
"""

from __future__ import annotations

import datetime as dt
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field

import psycopg

from comum import carga
from comum.carga import Ponto, Resumo
from comum.catalogo import PILOTO, indicadores_da_fonte
from comum.http import baixar

FONTE_ID = "fmi-weo"
BASE = "https://api.imf.org/external/sdmx/2.1"


@dataclass
class Leitura:
    pontos: list[Ponto] = field(default_factory=list)
    publicado_em: dt.date | None = None
    projecoes_descartadas: int = 0
    descartados: dict[str, str] = field(default_factory=dict)  # iso3 -> motivo


def url_dados(codigo: str, paises: tuple[str, ...]) -> str:
    return f"{BASE}/data/IMF.RES,WEO/{'+'.join(paises)}.{codigo}.A?detail=full"


def _local(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def interpretar(xml: bytes, indicador: str) -> Leitura:
    raiz = ET.fromstring(xml)
    leitura = Leitura()
    ultimo_obs: dict[tuple[str, str], int | str] = {}
    series = []
    for el in raiz.iter():
        nome = _local(el.tag)
        if nome == "DataSet" and el.get("PUBLICATION_DATE"):
            leitura.publicado_em = dt.date.fromisoformat(el.get("PUBLICATION_DATE")[:10])
        elif nome == "Group" and el.get("LATEST_ACTUAL_ANNUAL_DATA"):
            valor = el.get("LATEST_ACTUAL_ANNUAL_DATA").strip()
            chave = (el.get("COUNTRY"), el.get("INDICATOR"))
            ultimo_obs[chave] = int(valor) if valor.isdigit() else valor
        elif nome == "Series":
            series.append(el)
    for s in series:
        chave = (s.get("COUNTRY"), s.get("INDICATOR"))
        limite = ultimo_obs.get(chave)
        if limite is None:
            leitura.descartados[chave[0]] = "sem LATEST_ACTUAL_ANNUAL_DATA"
            continue
        if isinstance(limite, str):
            leitura.descartados[chave[0]] = (
                f"último ano observado em formato não calendário ({limite})"
            )
            continue
        for obs in s:
            if _local(obs.tag) != "Obs" or obs.get("OBS_VALUE") in (None, "", "NaN"):
                continue
            ano = int(obs.get("TIME_PERIOD")[:4])
            if ano > limite:
                leitura.projecoes_descartadas += 1
                continue
            leitura.pontos.append(Ponto(chave[0], indicador, ano, float(obs.get("OBS_VALUE"))))
    return leitura


def carregar(
    conn: psycopg.Connection, paises: tuple[str, ...] = PILOTO
) -> dict[str, tuple[Resumo, Leitura]]:
    coleta_id = carga.iniciar_coleta(conn, FONTE_ID)
    resultado: dict[str, tuple[Resumo, Leitura]] = {}
    try:
        for ind in indicadores_da_fonte(FONTE_ID):
            leitura = interpretar(baixar(url_dados(ind.codigo_na_fonte, paises)), ind.codigo)
            edicao = (
                f"WEO publicado em {leitura.publicado_em.isoformat()}"
                if leitura.publicado_em
                else None
            )
            resumo = carga.gravar_series(
                conn,
                coleta_id,
                FONTE_ID,
                leitura.pontos,
                edicao_fonte=edicao,
                atualizado_na_fonte_em=leitura.publicado_em,
            )
            resultado[ind.codigo] = (resumo, leitura)
    except Exception as e:
        carga.encerrar_coleta(conn, coleta_id, linhas=None, erro=repr(e))
        raise
    carga.encerrar_coleta(
        conn, coleta_id, linhas=sum(r.gravados for r, _ in resultado.values()), erro=None
    )
    return resultado
