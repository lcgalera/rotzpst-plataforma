"""Coleta da Agência Brasil (EBC) pelos feeds RSS oficiais (lista em https://rss.ebc.com.br).

Política de reprodução (https://agenciabrasil.ebc.com.br/sobre, lida em 2026-11-09): reprodução autorizada
para veículos de comunicação com fins jornalísticos, com indicação da fonte; conteúdo de agências parceiras
fica fora dessa regra. Por isso a coleta EXCLUI (mantém registrado, com motivo) qualquer item que:
  - diga "proibida a reprodução";
  - tenha autor de agência parceira;
  - traga "com informações da/de" agência parceira.
O texto coletado serve só de base para a análise e nunca é exibido no site.
"""

from __future__ import annotations

import datetime as dt
import email.utils
import html
import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field

import psycopg

from comum.http import baixar

FONTE_ID = "agencia-brasil"
VEICULO = "Agência Brasil"
FEEDS = {
    "economia": "https://agenciabrasil.ebc.com.br/rss/economia/feed.xml",
    "politica": "https://agenciabrasil.ebc.com.br/rss/politica/feed.xml",
    "internacional": "https://agenciabrasil.ebc.com.br/rss/internacional/feed.xml",
}
DC = "{http://purl.org/dc/elements/1.1/}creator"

# Agências parceiras/estrangeiras cujo conteúdo não entra na licença da Agência Brasil.
PARCEIRAS = (
    "reuters",
    "lusa",
    "afp",
    "france presse",
    "france-presse",
    "efe",
    "ansa",
    "xinhua",
    "associated press",
    "rtp",
    "prensa latina",
    "sputnik",
    "dw",
    "deutsche welle",
    "onu news",
    "bloomberg",
    "télam",
    "telam",
)
RE_PROIBIDA = re.compile(r"proibida a reprodu", re.IGNORECASE)
RE_COM_INFO = re.compile(r"com informa[çc][õo]es d[aoe]s?\s+([^.*\n]{2,60})", re.IGNORECASE)


@dataclass
class Item:
    guid: str
    url: str
    titulo: str
    autor: str | None
    editoria: str
    tags: list[str]
    publicado_em: dt.datetime
    texto: str
    excluida_motivo: str | None = None
    palavras: int = field(init=False)

    def __post_init__(self) -> None:
        self.palavras = len(self.texto.split())


def limpar_html(fragmento: str) -> str:
    sem_tags = re.sub(r"(?s)<(script|style).*?</\1>", " ", fragmento)
    sem_tags = re.sub(r"<br\s*/?>|</p>", "\n", sem_tags, flags=re.IGNORECASE)
    sem_tags = re.sub(r"<[^>]+>", " ", sem_tags)
    texto = html.unescape(sem_tags)
    linhas = [re.sub(r"[ \t ]+", " ", ln).strip() for ln in texto.splitlines()]
    return "\n".join(ln for ln in linhas if ln)


def motivo_exclusao(autor: str | None, texto: str) -> str | None:
    if RE_PROIBIDA.search(texto):
        return "texto marcado como 'proibida a reprodução'"
    a = (autor or "").lower()
    for p in PARCEIRAS:
        if re.search(rf"\b{re.escape(p)}\b", a):
            return f"autor de agência parceira ({p})"
    for m in RE_COM_INFO.finditer(texto):
        trecho = m.group(1).lower()
        for p in PARCEIRAS:
            if re.search(rf"\b{re.escape(p)}\b", trecho):
                return f"usa informações de agência parceira ({p})"
    return None


def interpretar_feed(xml: bytes, editoria: str) -> list[Item]:
    canal = ET.fromstring(xml).find("channel")
    itens = []
    for it in canal.findall("item") if canal is not None else []:
        url = (it.findtext("link") or "").strip()
        guid = (it.findtext("guid") or url).strip()
        titulo = html.unescape((it.findtext("title") or "").strip())
        data = it.findtext("pubDate")
        if not (url and titulo and data):
            continue
        autor = (it.findtext(DC) or "").strip() or None
        texto = limpar_html(it.findtext("description") or "")
        tags = [c.text.strip() for c in it.findall("category") if c.text]
        item = Item(
            guid=guid,
            url=url.replace("http://", "https://", 1),
            titulo=titulo,
            autor=autor,
            editoria=editoria,
            tags=tags,
            publicado_em=email.utils.parsedate_to_datetime(data),
            texto=texto,
        )
        item.excluida_motivo = motivo_exclusao(autor, texto)
        itens.append(item)
    return itens


def gravar(conn: psycopg.Connection, itens: list[Item]) -> tuple[int, int]:
    """Upsert idempotente por URL. Devolve (novas, excluidas_entre_as_novas)."""
    novas = excl = 0
    with conn.transaction(), conn.cursor() as cur:
        for i in itens:
            cur.execute(
                """
                INSERT INTO noticias (fonte_id, guid, url, titulo, veiculo, autor, editoria, tags,
                                      publicado_em, texto, palavras, excluida_motivo)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (url) DO NOTHING
                RETURNING id
                """,
                (
                    FONTE_ID,
                    i.guid,
                    i.url,
                    i.titulo,
                    VEICULO,
                    i.autor,
                    i.editoria,
                    i.tags,
                    i.publicado_em,
                    i.texto,
                    i.palavras,
                    i.excluida_motivo,
                ),
            )
            if cur.fetchone():
                novas += 1
                excl += i.excluida_motivo is not None
    return novas, excl


def coletar(conn: psycopg.Connection) -> dict[str, tuple[int, int]]:
    resultado = {}
    vistos: set[str] = set()
    for editoria, url in FEEDS.items():
        itens = [i for i in interpretar_feed(baixar(url), editoria) if i.url not in vistos]
        vistos.update(i.url for i in itens)
        resultado[editoria] = gravar(conn, itens)
    return resultado
