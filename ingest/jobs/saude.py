"""Checagem de saúde da ingestão. Sai com código 1 se algo exige atenção (o GitHub avisa a falha por e-mail).

Uso (dentro de ingest/, com DATABASE_URL):  uv run python -m jobs.saude
Confere, por fonte, se a última coleta deu certo e não está velha demais, e quantas análises esperam revisão.
"""

from __future__ import annotations

import datetime as dt
import sys

import psycopg

from comum.db import conectar

# Idade máxima aceitável da última coleta bem-sucedida, por fonte (dias).
IDADE_MAXIMA = {"bm-wdi": 10, "fmi-weo": 40, "agencia-brasil": 3}


def checar(conn: psycopg.Connection, agora: dt.datetime) -> list[str]:
    problemas = []
    with conn.cursor() as cur:
        for fonte, dias in IDADE_MAXIMA.items():
            cur.execute(
                """
                SELECT status, iniciada_em, erro FROM coletas WHERE fonte_id = %s
                ORDER BY iniciada_em DESC LIMIT 1
                """,
                (fonte,),
            )
            ultima = cur.fetchone()
            cur.execute(
                "SELECT max(iniciada_em) FROM coletas WHERE fonte_id = %s AND status = 'ok'",
                (fonte,),
            )
            (ultima_ok,) = cur.fetchone()
            if ultima and ultima[0] == "erro":
                problemas.append(f"{fonte}: última coleta falhou ({(ultima[2] or '')[:160]})")
            if ultima_ok is None:
                problemas.append(f"{fonte}: nenhuma coleta bem-sucedida registrada")
            elif agora - ultima_ok > dt.timedelta(days=dias):
                problemas.append(
                    f"{fonte}: última coleta bem-sucedida há {(agora - ultima_ok).days} dias (limite {dias})"
                )
        cur.execute(
            "SELECT count(*), min(gerado_em) FROM analises WHERE status = 'aguardando_revisao'"
        )
        pendentes, mais_antiga = cur.fetchone()
    if pendentes and mais_antiga and agora - mais_antiga > dt.timedelta(days=7):
        problemas.append(f"{pendentes} análise(s) aguardando revisão há mais de 7 dias")
    return problemas


def main() -> int:
    with conectar() as conn:
        problemas = checar(conn, dt.datetime.now(dt.UTC))
    if problemas:
        print("Atenção:\n- " + "\n- ".join(problemas))
        return 1
    print("Ingestão saudável.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
