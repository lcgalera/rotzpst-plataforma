"""Fluxo por lote, igual para qualquer provedor de IA.

1. exportar(): grava data/lotes/<nome>.json com as notícias pendentes (texto incluído, só para uso interno).
2. Um provedor gera data/lotes/<nome>.resultado.json no formato ESQUEMA_RESULTADO
   (o provedor padrão é o agente do Claude Code, rodando na assinatura; ver provedores.py).
3. importar(): valida o JSON (esquema + validador anti-alucinação) e grava em `analises`
   como 'aguardando_revisao' ou, se reprovar no validador, como 'rejeitada' com o motivo.
"""

from __future__ import annotations

import datetime as dt
import json
from pathlib import Path

import jsonschema
import psycopg

from news.analise.esquema import ESQUEMA_RESULTADO
from news.analise.provedores import exigir_ligado
from news.analise.validacao import validar

RAIZ = Path(__file__).resolve().parents[3]
PASTA = RAIZ / "data" / "lotes"
INSTRUCOES = Path(__file__).with_name("instrucoes.md")


def exportar(
    conn: psycopg.Connection, limite: int = 20, agora: dt.datetime | None = None
) -> Path | None:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT n.id, n.titulo, n.editoria, n.publicado_em, n.url, n.texto
            FROM noticias n
            WHERE n.excluida_motivo IS NULL
              AND NOT EXISTS (SELECT 1 FROM analises a WHERE a.noticia_id = n.id AND a.status <> 'rejeitada')
              AND NOT EXISTS (SELECT 1 FROM analises a WHERE a.noticia_id = n.id AND 'reprovada_no_validador' = ANY(a.erros)
                              GROUP BY a.noticia_id HAVING count(*) >= 2)
            ORDER BY n.publicado_em DESC
            LIMIT %s
            """,
            (limite,),
        )
        noticias = cur.fetchall()
        cur.execute("SELECT iso3, nome_pt FROM paises ORDER BY iso3")
        paises = cur.fetchall()
    if not noticias:
        return None
    nome = f"lote-{(agora or dt.datetime.now(dt.UTC)):%Y%m%d-%H%M%S}"
    PASTA.mkdir(parents=True, exist_ok=True)
    caminho = PASTA / f"{nome}.json"
    caminho.write_text(
        json.dumps(
            {
                "lote": nome,
                "instrucoes": INSTRUCOES.read_text(encoding="utf-8"),
                "esquema_resultado": ESQUEMA_RESULTADO,
                "paises": {iso: nome_pt for iso, nome_pt in paises},
                "noticias": [
                    {
                        "noticia_id": i,
                        "titulo": t,
                        "editoria": e,
                        "publicado_em": p.isoformat(),
                        "url": u,
                        "texto": x,
                    }
                    for i, t, e, p, u, x in noticias
                ],
            },
            ensure_ascii=False,
            indent=1,
        ),
        encoding="utf-8",
    )
    return caminho


def importar(conn: psycopg.Connection, caminho_resultado: Path) -> dict[str, int]:
    resultado = json.loads(caminho_resultado.read_text(encoding="utf-8"))
    jsonschema.validate(resultado, ESQUEMA_RESULTADO)
    exigir_ligado(resultado["provedor"])
    lote = caminho_resultado.name.removesuffix(".resultado.json")
    contagem = {"aguardando_revisao": 0, "rejeitada": 0, "ignorada": 0}
    with conn.transaction(), conn.cursor() as cur:
        cur.execute("SELECT iso3 FROM paises")
        validos = {r[0] for r in cur.fetchall()}
        for a in resultado["analises"]:
            cur.execute(
                "SELECT texto, excluida_motivo FROM noticias WHERE id = %s", (a["noticia_id"],)
            )
            linha = cur.fetchone()
            if linha is None or linha[1] is not None:
                contagem["ignorada"] += 1
                continue
            v = validar(a, linha[0], validos)
            status = "aguardando_revisao" if v.ok else "rejeitada"
            cur.execute(
                """
                INSERT INTO analises (noticia_id, provedor, modelo, lote, resumo, fato, interpretacao, impacto,
                                      paises, temas, validacao, status, erros)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT DO NOTHING
                """,
                (
                    a["noticia_id"],
                    resultado["provedor"],
                    resultado["modelo"],
                    lote,
                    a["resumo"],
                    json.dumps(a["fato"], ensure_ascii=False),
                    json.dumps(a["interpretacao"], ensure_ascii=False)
                    if a["interpretacao"]
                    else None,
                    json.dumps(a["impacto"], ensure_ascii=False) if a["impacto"] else None,
                    sorted(set(a["paises"])),
                    sorted(set(a["temas"])),
                    json.dumps(v.como_dict(), ensure_ascii=False),
                    status,
                    [] if v.ok else ["reprovada_no_validador"],
                ),
            )
            contagem[status if cur.rowcount else "ignorada"] += 1
            cur.execute(
                "INSERT INTO custos_ia (provedor, modelo, noticia_id, custo_usd) VALUES (%s, %s, %s, 0)",
                (resultado["provedor"], resultado["modelo"], a["noticia_id"]),
            )
    return contagem
