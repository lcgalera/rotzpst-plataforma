"""Carga idempotente de séries, com registro de coleta e anomalias."""

from __future__ import annotations

import datetime as dt
from collections.abc import Iterable
from dataclasses import dataclass

import psycopg

from comum.validacao import validar


@dataclass(frozen=True)
class Ponto:
    pais_iso3: str
    indicador: str
    periodo: int
    valor: float


@dataclass
class Resumo:
    gravados: int = 0
    rejeitados: int = 0
    alertas: int = 0
    ignorados_fora_da_base: int = 0


def iniciar_coleta(conn: psycopg.Connection, fonte_id: str) -> int:
    with conn.cursor() as cur:
        cur.execute("INSERT INTO coletas (fonte_id) VALUES (%s) RETURNING id", (fonte_id,))
        (id_,) = cur.fetchone()
    conn.commit()
    return id_


def encerrar_coleta(
    conn: psycopg.Connection, coleta_id: int, *, linhas: int | None, erro: str | None
) -> None:
    with conn.cursor() as cur:
        cur.execute(
            "UPDATE coletas SET terminada_em = now(), status = %s, linhas_gravadas = %s, erro = %s WHERE id = %s",
            ("erro" if erro else "ok", linhas, erro, coleta_id),
        )
    conn.commit()


def gravar_series(
    conn: psycopg.Connection,
    coleta_id: int,
    fonte_id: str,
    pontos: Iterable[Ponto],
    *,
    edicao_fonte: str | None,
    atualizado_na_fonte_em: dt.date | None,
    hoje: dt.date | None = None,
) -> Resumo:
    """Valida e faz upsert. Rodar duas vezes com os mesmos dados não duplica nada.

    Tudo numa transação: se algo falhar, o banco continua com o último dado válido (falha segura).
    """
    ano_atual = (hoje or dt.date.today()).year
    resumo = Resumo()
    with conn.transaction(), conn.cursor() as cur:
        cur.execute("SELECT iso3 FROM paises")
        base = {r[0] for r in cur.fetchall()}
        for p in pontos:
            if p.pais_iso3 not in base:
                resumo.ignorados_fora_da_base += 1
                continue
            r = validar(p.indicador, p.periodo, p.valor, ano_atual)
            if r.nivel:
                cur.execute(
                    "INSERT INTO anomalias (coleta_id, pais_iso3, indicador_codigo, periodo, valor, nivel, regra)"
                    " VALUES (%s, %s, %s, %s, %s, %s, %s)",
                    (coleta_id, p.pais_iso3, p.indicador, p.periodo, p.valor, r.nivel, r.regra),
                )
            if r.nivel == "rejeitado":
                resumo.rejeitados += 1
                continue
            if r.nivel == "alerta":
                resumo.alertas += 1
            cur.execute(
                """
                INSERT INTO series (pais_iso3, indicador_codigo, periodo, valor, fonte_id,
                                    edicao_fonte, atualizado_na_fonte_em, coletado_em)
                VALUES (%s, %s, %s, %s, %s, %s, %s, now())
                ON CONFLICT (pais_iso3, indicador_codigo, periodo) DO UPDATE SET
                    valor = EXCLUDED.valor,
                    fonte_id = EXCLUDED.fonte_id,
                    edicao_fonte = EXCLUDED.edicao_fonte,
                    atualizado_na_fonte_em = EXCLUDED.atualizado_na_fonte_em,
                    coletado_em = EXCLUDED.coletado_em
                """,
                (
                    p.pais_iso3,
                    p.indicador,
                    p.periodo,
                    p.valor,
                    fonte_id,
                    edicao_fonte,
                    atualizado_na_fonte_em,
                ),
            )
            resumo.gravados += 1
    return resumo
