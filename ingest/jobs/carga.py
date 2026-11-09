"""Carga completa da Fase 1: migrações, catálogo, geometrias, países e séries.

Uso (dentro de ingest/):  DATABASE_URL=... uv run python -m jobs.carga [--sem-geo]
Idempotente: pode rodar quantas vezes quiser.
"""

from __future__ import annotations

import sys

from comum.db import conectar, migrar
from comum.sincronia import sincronizar_catalogo
from sources import banco_mundial, fmi_weo, geo, paises


def main(argv: list[str]) -> int:
    with conectar() as conn:
        aplicadas = migrar(conn)
        print(f"Migrações aplicadas: {aplicadas or 'nenhuma pendente'}")
        sincronizar_catalogo(conn)

        ids_geo = geo.ids_locais() if "--sem-geo" in argv else geo.baixar_geometrias()
        print(f"Geometrias com código ISO: {len(ids_geo)}")

        n = paises.carregar(conn, ids_geo)
        print(f"Países ISO na base: {n}")

        for cod, r in banco_mundial.carregar(conn).items():
            print(
                f"[Banco Mundial] {cod}: {r.gravados} gravados, {r.alertas} alertas, {r.rejeitados} rejeitados"
            )

        for cod, (r, leitura) in fmi_weo.carregar(conn).items():
            print(
                f"[FMI WEO] {cod}: {r.gravados} gravados, {leitura.projecoes_descartadas} projeções descartadas, "
                f"{r.alertas} alertas, {r.rejeitados} rejeitados, países descartados: "
                f"{leitura.descartados or 'nenhum'}"
            )
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
