"""Geometrias de países: Natural Earth 4.1.0 via pacote npm world-atlas 2.0.2 (TopoJSON).

Baixa o tarball fixado do registro npm, confere a integridade (sha512 publicada pelo registro)
e grava os TopoJSON em data/geo/. Feições sem código ISO (Kosovo, Chipre do Norte, Somalilândia)
ficam no arquivo mas não se ligam a nenhum país da base.
"""

from __future__ import annotations

import base64
import hashlib
import io
import json
import tarfile
from pathlib import Path

from comum.http import baixar, baixar_json

PACOTE = "world-atlas"
VERSAO = "2.0.2"
ARQUIVOS = ("countries-110m.json", "countries-50m.json")
RAIZ = Path(__file__).resolve().parents[2]
DESTINO = RAIZ / "data" / "geo"


def conferir_integridade(conteudo: bytes, integrity: str) -> None:
    algo, _, esperado = integrity.partition("-")
    if algo != "sha512":
        raise ValueError(f"Algoritmo de integridade inesperado: {algo}")
    obtido = base64.b64encode(hashlib.sha512(conteudo).digest()).decode()
    if obtido != esperado:
        raise ValueError("Integridade do pacote world-atlas não confere.")


def ids_iso(topojson: dict) -> set[str]:
    """Ids ISO numéricos (3 dígitos) presentes na coleção 'countries'."""
    geoms = topojson["objects"]["countries"]["geometries"]
    return {g["id"] for g in geoms if isinstance(g.get("id"), str) and g["id"].isdigit()}


def baixar_geometrias(destino: Path = DESTINO) -> set[str]:
    meta = baixar_json(f"https://registry.npmjs.org/{PACOTE}/{VERSAO}")
    tarball = baixar(meta["dist"]["tarball"])
    conferir_integridade(tarball, meta["dist"]["integrity"])
    destino.mkdir(parents=True, exist_ok=True)
    ids: set[str] = set()
    with tarfile.open(fileobj=io.BytesIO(tarball), mode="r:gz") as tar:
        for nome in ARQUIVOS:
            dados = tar.extractfile(f"package/{nome}").read()
            (destino / nome).write_bytes(dados)
            ids |= ids_iso(json.loads(dados))
        (destino / "LICENSE-world-atlas.txt").write_bytes(tar.extractfile("package/LICENSE").read())
    return ids


def ids_locais(destino: Path = DESTINO) -> set[str]:
    """Lê os ids do arquivo já gravado (sem rede)."""
    return ids_iso(json.loads((destino / "countries-50m.json").read_text(encoding="utf-8")))
