"""Pipeline de notícias (Fase 3).

Uso (dentro de ingest/, com DATABASE_URL):
  uv run python -m jobs.noticias coletar              # feeds -> noticias (+ agrupamento por evento)
  uv run python -m jobs.noticias exportar [N]         # gera data/lotes/lote-*.json com até N pendentes (padrão 20)
  uv run python -m jobs.noticias importar ARQUIVO     # valida e grava data/lotes/lote-*.resultado.json
  uv run python -m jobs.noticias taxa-erro            # regenera docs/taxa-erro-ia.md
"""

from __future__ import annotations

import sys
from pathlib import Path

from comum.db import conectar, migrar
from comum.sincronia import sincronizar_catalogo
from news import agencia_brasil, agrupamento
from news.analise import lote


def main(argv: list[str]) -> int:
    if not argv:
        print(__doc__)
        return 2
    cmd, *resto = argv
    with conectar() as conn:
        migrar(conn)
        if cmd == "coletar":
            sincronizar_catalogo(conn)
            for ed, (novas, excl) in agencia_brasil.coletar(conn).items():
                print(f"[Agência Brasil] {ed}: {novas} novas ({excl} excluídas por licença)")
            print(f"Agrupadas em eventos: {agrupamento.agrupar(conn)}")
        elif cmd == "exportar":
            caminho = lote.exportar(conn, int(resto[0]) if resto else 20)
            print(caminho or "Nada pendente.")
        elif cmd == "importar":
            print(lote.importar(conn, Path(resto[0])))
        elif cmd == "taxa-erro":
            from jobs.taxa_erro import gerar

            print(gerar(conn))
        else:
            print(__doc__)
            return 2
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
