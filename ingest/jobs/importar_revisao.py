"""Importa decisões de revisão feitas fora do site (página privada de revisão) para `analises`.

Uso (dentro de ingest/, com DATABASE_URL):
  uv run python -m jobs.importar_revisao ARQUIVO.json
ARQUIVO: lista de {analise_id, decisao: 'aprovada'|'rejeitada', erros: [categoria...], nota, em}.
Mesmas regras do painel /revisao: só altera análises ainda 'aguardando_revisao'; rejeitar exige erro ou nota.
"""

from __future__ import annotations

import datetime as dt
import json
import sys
from pathlib import Path

import psycopg

from comum.db import conectar

CATEGORIAS = {
    "fato_incorreto",
    "citacao_fora_de_contexto",
    "interpretacao_sem_base",
    "impacto_sem_base",
    "pais_errado",
    "tema_errado",
    "nao_neutro",
    "outro",
}


def aplicar(conn: psycopg.Connection, decisoes: list[dict]) -> dict[str, int]:
    cont = {"aprovada": 0, "rejeitada": 0, "ignorada": 0}
    with conn.transaction(), conn.cursor() as cur:
        for d in decisoes:
            decisao = d.get("decisao")
            erros = [e for e in d.get("erros") or [] if e in CATEGORIAS]
            nota = (d.get("nota") or "").strip() or None
            if decisao not in ("aprovada", "rejeitada") or (
                decisao == "rejeitada" and not erros and not nota
            ):
                cont["ignorada"] += 1
                continue
            em = dt.datetime.fromisoformat(d["em"].replace("Z", "+00:00")) if d.get("em") else None
            cur.execute(
                """
                UPDATE analises SET status = %s, erros = %s, revisao_nota = %s, revisado_em = coalesce(%s, now())
                WHERE id = %s AND status = 'aguardando_revisao'
                """,
                (decisao, erros, nota, em, int(d["analise_id"])),
            )
            cont[decisao if cur.rowcount == 1 else "ignorada"] += 1
    return cont


def main(argv: list[str]) -> int:
    if len(argv) != 1:
        print(__doc__)
        return 2
    decisoes = json.loads(Path(argv[0]).read_text(encoding="utf-8"))
    with conectar() as conn:
        print(aplicar(conn, decisoes))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
