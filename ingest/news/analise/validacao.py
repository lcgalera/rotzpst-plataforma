"""Validador automático: barra alucinação de citação, cópia longa e campos inválidos.

Não substitui a revisão humana: garante só o que dá para verificar mecanicamente.
"""

from __future__ import annotations

import re
import unicodedata
from dataclasses import dataclass, field

from news.analise.esquema import (
    MAX_CITACOES_POR_BLOCO,
    MAX_PALAVRAS_BLOCO,
    MAX_PALAVRAS_CITACAO,
    MAX_PALAVRAS_RESUMO,
    MAX_SEQUENCIA_COPIADA,
    TEMAS,
)


def normalizar(s: str) -> str:
    """Compara textos ignorando aspas tipográficas, travessões e espaços."""
    s = unicodedata.normalize("NFC", s)
    s = s.replace("“", '"').replace("”", '"').replace("‘", "'").replace("’", "'")
    s = s.replace("–", "-").replace("—", "-").replace(" ", " ")
    return re.sub(r"\s+", " ", s).strip().lower()


def _palavras(s: str) -> list[str]:
    return re.findall(r"\w+", normalizar(s))


def maior_sequencia_copiada(proprio: str, fonte: str) -> int:
    """Maior número de palavras seguidas de `proprio` que aparecem iguais em `fonte`."""
    p, f = _palavras(proprio), _palavras(fonte)
    if not p or not f:
        return 0
    ngramas: dict[int, set[tuple[str, ...]]] = {}
    melhor = 0
    for n in range(1, len(p) + 1):
        conj = ngramas.setdefault(n, {tuple(f[i : i + n]) for i in range(len(f) - n + 1)})
        if any(tuple(p[i : i + n]) in conj for i in range(len(p) - n + 1)):
            melhor = n
        else:
            break
    return melhor


@dataclass
class Resultado:
    erros: list[str] = field(default_factory=list)
    avisos: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.erros

    def como_dict(self) -> dict:
        return {"ok": self.ok, "erros": self.erros, "avisos": self.avisos}


def _bloco(nome: str, bloco: dict | None, fonte: str, r: Resultado, obrigatorio: bool) -> None:
    if bloco is None:
        if obrigatorio:
            r.erros.append(f"{nome}: obrigatório")
        return
    texto = (bloco.get("texto") or "").strip()
    cits = bloco.get("citacoes") or []
    if not texto:
        r.erros.append(f"{nome}: texto vazio")
    if len(texto.split()) > MAX_PALAVRAS_BLOCO:
        r.erros.append(f"{nome}: texto com mais de {MAX_PALAVRAS_BLOCO} palavras")
    if not cits:
        r.erros.append(f"{nome}: sem citação da fonte")
    if len(cits) > MAX_CITACOES_POR_BLOCO:
        r.erros.append(f"{nome}: mais de {MAX_CITACOES_POR_BLOCO} citações")
    fonte_n = normalizar(fonte)
    for c in cits:
        trecho = (c.get("trecho") or "").strip()
        if not trecho:
            r.erros.append(f"{nome}: citação vazia")
        elif len(trecho.split()) > MAX_PALAVRAS_CITACAO:
            r.erros.append(f"{nome}: citação com mais de {MAX_PALAVRAS_CITACAO} palavras")
        elif normalizar(trecho) not in fonte_n:
            r.erros.append(
                f"{nome}: citação não encontrada literalmente no texto da fonte: “{trecho[:80]}”"
            )
    seq = maior_sequencia_copiada(texto, fonte)
    if seq > MAX_SEQUENCIA_COPIADA:
        r.erros.append(
            f"{nome}: texto próprio copia {seq} palavras seguidas da fonte (máx. {MAX_SEQUENCIA_COPIADA})"
        )


def validar(analise: dict, texto_fonte: str, paises_validos: set[str]) -> Resultado:
    r = Resultado()
    resumo = (analise.get("resumo") or "").strip()
    if not resumo:
        r.erros.append("resumo vazio")
    elif len(resumo.split()) > MAX_PALAVRAS_RESUMO:
        r.erros.append(f"resumo com mais de {MAX_PALAVRAS_RESUMO} palavras")
    elif (seq := maior_sequencia_copiada(resumo, texto_fonte)) > MAX_SEQUENCIA_COPIADA:
        r.erros.append(
            f"resumo copia {seq} palavras seguidas da fonte (máx. {MAX_SEQUENCIA_COPIADA})"
        )

    _bloco("fato", analise.get("fato"), texto_fonte, r, obrigatorio=True)
    _bloco("interpretacao", analise.get("interpretacao"), texto_fonte, r, obrigatorio=False)
    _bloco("impacto", analise.get("impacto"), texto_fonte, r, obrigatorio=False)

    temas = analise.get("temas") or []
    if not temas:
        r.erros.append("sem tema")
    for t in temas:
        if t not in TEMAS:
            r.erros.append(f"tema inválido: {t}")
    paises = analise.get("paises") or []
    for p in paises:
        if p not in paises_validos:
            r.erros.append(f"país fora da base ISO: {p}")
    if not paises:
        r.avisos.append("nenhum país associado")
    if analise.get("interpretacao") is None:
        r.avisos.append("sem interpretação (sem base no texto)")
    if analise.get("impacto") is None:
        r.avisos.append("sem impacto (sem base no texto)")
    return r
