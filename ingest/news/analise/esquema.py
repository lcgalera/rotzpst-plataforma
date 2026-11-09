"""Formato obrigatório da resposta da IA (JSON Schema) e limites editoriais."""

from __future__ import annotations

TEMAS = ("economia", "politica", "geopolitica")

# Limites: resumo curto PRÓPRIO; citações curtas (direito de citação, nunca republicação).
MAX_PALAVRAS_RESUMO = 60
MAX_PALAVRAS_BLOCO = 90
MAX_PALAVRAS_CITACAO = 30
MAX_CITACOES_POR_BLOCO = 3
# Sequência máxima de palavras do texto original que pode aparecer nos textos próprios (fora das citações).
MAX_SEQUENCIA_COPIADA = 12

_CITACOES = {
    "type": "array",
    "minItems": 1,
    "maxItems": MAX_CITACOES_POR_BLOCO,
    "items": {
        "type": "object",
        "additionalProperties": False,
        "required": ["trecho"],
        "properties": {
            "trecho": {
                "type": "string",
                "description": "Cópia LITERAL de um trecho curto do texto da fonte.",
            }
        },
    },
}

_BLOCO = {
    "type": "object",
    "additionalProperties": False,
    "required": ["texto", "citacoes"],
    "properties": {"texto": {"type": "string"}, "citacoes": _CITACOES},
}

ESQUEMA_ANALISE = {
    "type": "object",
    "additionalProperties": False,
    "required": ["noticia_id", "resumo", "fato", "interpretacao", "impacto", "paises", "temas"],
    "properties": {
        "noticia_id": {"type": "integer"},
        "resumo": {"type": "string"},
        "fato": _BLOCO,
        "interpretacao": {"anyOf": [_BLOCO, {"type": "null"}]},
        "impacto": {"anyOf": [_BLOCO, {"type": "null"}]},
        "paises": {"type": "array", "items": {"type": "string", "pattern": "^[A-Z]{3}$"}},
        "temas": {"type": "array", "minItems": 1, "items": {"type": "string", "enum": list(TEMAS)}},
    },
}

ESQUEMA_RESULTADO = {
    "type": "object",
    "additionalProperties": False,
    "required": ["provedor", "modelo", "analises"],
    "properties": {
        "provedor": {"type": "string"},
        "modelo": {"type": "string"},
        "analises": {"type": "array", "items": ESQUEMA_ANALISE},
    },
}
