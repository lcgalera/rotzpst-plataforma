"""Leva o conteúdo publicado de um banco para outro (ex.: do desenvolvimento para o Neon), via arquivo versionado.

Uso (dentro de ingest/, com DATABASE_URL):
  uv run python -m jobs.publicacao exportar   # banco -> db/seeds/noticias_publicadas.json
  uv run python -m jobs.publicacao importar   # db/seeds/noticias_publicadas.json -> banco (idempotente)

O arquivo vai para um repositório PÚBLICO, então leva só o que já é público ou estatístico:
- análises aprovadas: completas (já aparecem no site), sem a nota do revisor;
- análises pendentes ou rejeitadas: só status e categorias de erro (mantém a taxa de erro), sem texto;
- notícias: metadados e link. O texto integral da fonte NUNCA vai para o arquivo.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import psycopg

from comum.db import conectar, migrar

ARQUIVO = Path(__file__).resolve().parents[2] / "db" / "seeds" / "noticias_publicadas.json"
SEM_TEXTO = "[texto da fonte não versionado: usar o link original]"
OCULTO = "[não publicado]"


def exportar(conn: psycopg.Connection) -> dict:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT n.url, n.fonte_id, n.guid, n.titulo, n.veiculo, n.autor, n.editoria, n.tags,
                   n.publicado_em, n.palavras, n.excluida_motivo,
                   a.provedor, a.modelo, a.lote, a.gerado_em, a.resumo, a.fato, a.interpretacao, a.impacto,
                   a.paises, a.temas, a.validacao, a.status, a.erros, a.revisado_em
            FROM analises a JOIN noticias n ON n.id = a.noticia_id
            ORDER BY n.publicado_em, a.id
            """
        )
        cols = [c.name for c in cur.description]
        linhas = [dict(zip(cols, r, strict=True)) for r in cur.fetchall()]
    noticias: dict[str, dict] = {}
    analises = []
    for r in linhas:
        noticias.setdefault(
            r["url"],
            {
                k: (v.isoformat() if hasattr(v, "isoformat") else v)
                for k, v in r.items()
                if k
                in (
                    "url",
                    "fonte_id",
                    "guid",
                    "titulo",
                    "veiculo",
                    "autor",
                    "editoria",
                    "tags",
                    "publicado_em",
                    "palavras",
                    "excluida_motivo",
                )
            },
        )
        aprovada = r["status"] == "aprovada"
        analises.append(
            {
                "noticia_url": r["url"],
                "provedor": r["provedor"],
                "modelo": r["modelo"],
                "lote": r["lote"],
                "gerado_em": r["gerado_em"].isoformat(),
                "status": r["status"],
                "erros": r["erros"],
                "revisado_em": r["revisado_em"].isoformat() if r["revisado_em"] else None,
                "paises": [p.strip() for p in r["paises"]],
                "temas": r["temas"],
                "resumo": r["resumo"] if aprovada else OCULTO,
                "fato": r["fato"] if aprovada else {"texto": OCULTO, "citacoes": []},
                "interpretacao": r["interpretacao"] if aprovada else None,
                "impacto": r["impacto"] if aprovada else None,
                "validacao": r["validacao"],
            }
        )
    return {"versao": 1, "noticias": list(noticias.values()), "analises": analises}


def importar(conn: psycopg.Connection, dados: dict) -> dict[str, int]:
    cont = {"noticias": 0, "analises": 0}
    with conn.transaction(), conn.cursor() as cur:
        for n in dados["noticias"]:
            cur.execute(
                """
                INSERT INTO noticias (fonte_id, guid, url, titulo, veiculo, autor, editoria, tags, publicado_em,
                                      texto, palavras, excluida_motivo)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (url) DO NOTHING
                """,
                (
                    n["fonte_id"],
                    n["guid"],
                    n["url"],
                    n["titulo"],
                    n["veiculo"],
                    n["autor"],
                    n["editoria"],
                    n["tags"],
                    n["publicado_em"],
                    SEM_TEXTO,
                    n["palavras"],
                    n["excluida_motivo"],
                ),
            )
            cont["noticias"] += cur.rowcount
        for a in dados["analises"]:
            cur.execute("SELECT id FROM noticias WHERE url = %s", (a["noticia_url"],))
            (nid,) = cur.fetchone()
            cur.execute(
                "SELECT 1 FROM analises WHERE noticia_id = %s AND provedor = %s AND lote IS NOT DISTINCT FROM %s AND gerado_em = %s",
                (nid, a["provedor"], a["lote"], a["gerado_em"]),
            )
            if cur.fetchone():
                continue
            cur.execute(
                """
                INSERT INTO analises (noticia_id, provedor, modelo, lote, gerado_em, resumo, fato, interpretacao,
                                      impacto, paises, temas, validacao, status, erros, revisado_em)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (
                    nid,
                    a["provedor"],
                    a["modelo"],
                    a["lote"],
                    a["gerado_em"],
                    a["resumo"],
                    json.dumps(a["fato"], ensure_ascii=False),
                    json.dumps(a["interpretacao"], ensure_ascii=False)
                    if a["interpretacao"]
                    else None,
                    json.dumps(a["impacto"], ensure_ascii=False) if a["impacto"] else None,
                    a["paises"],
                    a["temas"],
                    json.dumps(a["validacao"], ensure_ascii=False),
                    a["status"],
                    a["erros"],
                    a["revisado_em"],
                ),
            )
            cont["analises"] += 1
    return cont


def main(argv: list[str]) -> int:
    if argv[:1] not in (["exportar"], ["importar"]):
        print(__doc__)
        return 2
    with conectar() as conn:
        if argv[0] == "exportar":
            ARQUIVO.write_text(
                json.dumps(exportar(conn), ensure_ascii=False, indent=1) + "\n", encoding="utf-8"
            )
            print(f"Exportado para {ARQUIVO}")
        else:
            migrar(conn)
            print(importar(conn, json.loads(ARQUIVO.read_text(encoding="utf-8"))))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
