"""Conexão com o Postgres e aplicação de migrações SQL (db/migrations/*.sql, em ordem)."""

from __future__ import annotations

import os
from pathlib import Path

import psycopg

RAIZ = Path(__file__).resolve().parents[2]
MIGRACOES = RAIZ / "db" / "migrations"


def url_banco() -> str:
    url = os.environ.get("DATABASE_URL")
    if not url:
        raise RuntimeError("Defina DATABASE_URL (ver .env.example).")
    return url


def conectar(url: str | None = None) -> psycopg.Connection:
    return psycopg.connect(url or url_banco())


def migrar(conn: psycopg.Connection) -> list[str]:
    """Aplica migrações pendentes. Idempotente: registra cada arquivo em schema_migrations."""
    with conn.cursor() as cur:
        cur.execute(
            "CREATE TABLE IF NOT EXISTS schema_migrations ("
            " arquivo text PRIMARY KEY, aplicada_em timestamptz NOT NULL DEFAULT now())"
        )
        cur.execute("SELECT arquivo FROM schema_migrations")
        feitas = {r[0] for r in cur.fetchall()}
    aplicadas = []
    for arq in sorted(MIGRACOES.glob("*.sql")):
        if arq.name in feitas:
            continue
        with conn.transaction(), conn.cursor() as cur:
            cur.execute(arq.read_text(encoding="utf-8"))
            cur.execute("INSERT INTO schema_migrations (arquivo) VALUES (%s)", (arq.name,))
        aplicadas.append(arq.name)
    return aplicadas
