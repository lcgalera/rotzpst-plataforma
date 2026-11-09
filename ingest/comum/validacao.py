"""Validação de valores antes da carga.

- 'rejeitado': impossível ou fora de qualquer faixa razoável. Não entra em `series`.
- 'alerta': plausível, mas incomum (ex.: hiperinflação). Entra, e fica registrado para revisão.
As faixas são deliberadamente largas: o objetivo é pegar erro de unidade/escala, não julgar a economia.
"""

from __future__ import annotations

import math
from dataclasses import dataclass


@dataclass(frozen=True)
class Faixa:
    minimo: float
    maximo: float
    alerta_min: float | None = None
    alerta_max: float | None = None


FAIXAS: dict[str, Faixa] = {
    "pib": Faixa(1e6, 1e14),
    "pib_crescimento": Faixa(-80, 150, alerta_min=-20, alerta_max=30),
    "pib_per_capita": Faixa(10, 1e6),
    "inflacao": Faixa(-50, 1e7, alerta_max=100),
    "desemprego": Faixa(0, 100, alerta_max=40),
    "divida_publica_pib": Faixa(0, 1000, alerta_max=250),
    "balanca_bens_servicos": Faixa(-5e12, 5e12),
    "populacao": Faixa(1_000, 2e9),
}


@dataclass(frozen=True)
class Resultado:
    nivel: str | None  # None = ok
    regra: str | None = None


OK = Resultado(None)


def validar(indicador: str, periodo: int, valor: float, ano_atual: int) -> Resultado:
    if valor is None or not math.isfinite(valor):
        return Resultado("rejeitado", "valor não numérico")
    if periodo > ano_atual:
        return Resultado("rejeitado", f"período {periodo} no futuro (possível projeção)")
    faixa = FAIXAS.get(indicador)
    if faixa is None:
        return Resultado("rejeitado", f"indicador sem faixa de validação: {indicador}")
    if not faixa.minimo <= valor <= faixa.maximo:
        return Resultado("rejeitado", f"fora da faixa [{faixa.minimo:g}, {faixa.maximo:g}]")
    if faixa.alerta_min is not None and valor < faixa.alerta_min:
        return Resultado("alerta", f"abaixo de {faixa.alerta_min:g}")
    if faixa.alerta_max is not None and valor > faixa.alerta_max:
        return Resultado("alerta", f"acima de {faixa.alerta_max:g}")
    return OK
