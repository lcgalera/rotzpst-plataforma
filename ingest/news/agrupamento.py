"""Deduplicação e agrupamento por evento.

- Duplicata exata: mesma URL (garantido pelo banco).
- Mesmo evento: títulos parecidos (Jaccard de palavras significativas >= LIMIAR) publicados a até 72 h.
Simples de propósito; a revisão humana pega o que escapar.
"""

from __future__ import annotations

import re
import unicodedata

import psycopg

LIMIAR = 0.5
JANELA_HORAS = 72
VAZIAS = set(
    [
        "a",
        "o",
        "as",
        "os",
        "de",
        "da",
        "do",
        "das",
        "dos",
        "e",
        "em",
        "no",
        "na",
        "nos",
        "nas",
        "para",
        "por",
        "com",
        "sem",
        "que",
        "se",
        "um",
        "uma",
        "uns",
        "umas",
        "ao",
        "à",
        "às",
        "é",
        "foi",
        "são",
        "ser",
        "diz",
        "após",
        "sobre",
        "entre",
        "mais",
    ]
)


def palavras(titulo: str) -> set[str]:
    t = unicodedata.normalize("NFD", titulo.lower())
    t = "".join(c for c in t if unicodedata.category(c) != "Mn")
    return {w for w in re.findall(r"[a-z0-9]+", t) if w not in VAZIAS and len(w) > 2}


def similaridade(a: str, b: str) -> float:
    pa, pb = palavras(a), palavras(b)
    if not pa or not pb:
        return 0.0
    return len(pa & pb) / len(pa | pb)


def agrupar(conn: psycopg.Connection) -> int:
    """Atribui evento às notícias sem evento. Devolve quantas foram agrupadas."""
    with conn.transaction(), conn.cursor() as cur:
        cur.execute(
            "SELECT id, titulo, publicado_em FROM noticias WHERE evento_id IS NULL ORDER BY publicado_em"
        )
        pendentes = cur.fetchall()
        n = 0
        for nid, titulo, quando in pendentes:
            cur.execute(
                """
                SELECT n.evento_id, n.titulo FROM noticias n
                WHERE n.evento_id IS NOT NULL
                  AND n.publicado_em BETWEEN %s - make_interval(hours => %s) AND %s + make_interval(hours => %s)
                """,
                (quando, JANELA_HORAS, quando, JANELA_HORAS),
            )
            melhor = max(cur.fetchall(), key=lambda r: similaridade(titulo, r[1]), default=None)
            if melhor and similaridade(titulo, melhor[1]) >= LIMIAR:
                evento = melhor[0]
            else:
                cur.execute("INSERT INTO eventos (titulo_ref) VALUES (%s) RETURNING id", (titulo,))
                evento = cur.fetchone()[0]
            cur.execute("UPDATE noticias SET evento_id = %s WHERE id = %s", (evento, nid))
            n += 1
    return n
