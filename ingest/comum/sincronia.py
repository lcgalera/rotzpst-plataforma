"""Grava o catálogo (fontes e indicadores) no banco. Idempotente."""

from __future__ import annotations

from dataclasses import asdict

import psycopg

from comum.catalogo import FONTES, INDICADORES


def sincronizar_catalogo(conn: psycopg.Connection) -> None:
    with conn.transaction(), conn.cursor() as cur:
        for f in FONTES:
            d = asdict(f)
            cols = ", ".join(d)
            sets = ", ".join(f"{c} = EXCLUDED.{c}" for c in d if c != "id")
            cur.execute(
                f"INSERT INTO fontes_dados ({cols}) VALUES ({', '.join(['%s'] * len(d))})"
                f" ON CONFLICT (id) DO UPDATE SET {sets}",
                tuple(d.values()),
            )
        for i in INDICADORES:
            d = asdict(i)
            cols = ", ".join(d)
            sets = ", ".join(f"{c} = EXCLUDED.{c}" for c in d if c != "codigo")
            cur.execute(
                f"INSERT INTO indicadores ({cols}) VALUES ({', '.join(['%s'] * len(d))})"
                f" ON CONFLICT (codigo) DO UPDATE SET {sets}",
                tuple(d.values()),
            )
