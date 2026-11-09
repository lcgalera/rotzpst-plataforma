import math

from comum.catalogo import INDICADORES
from comum.validacao import FAIXAS, validar


def test_todo_indicador_tem_faixa():
    assert {i.codigo for i in INDICADORES} <= set(FAIXAS)


def test_valor_normal_passa():
    assert validar("inflacao", 2024, 4.5, 2026).nivel is None


def test_periodo_futuro_e_rejeitado_como_possivel_projecao():
    r = validar("pib_crescimento", 2027, 2.0, 2026)
    assert r.nivel == "rejeitado" and "projeção" in r.regra


def test_fora_da_faixa_e_rejeitado():
    assert validar("desemprego", 2024, 140, 2026).nivel == "rejeitado"
    assert validar("populacao", 2024, -1, 2026).nivel == "rejeitado"


def test_nan_e_rejeitado():
    assert validar("pib", 2024, math.nan, 2026).nivel == "rejeitado"


def test_hiperinflacao_e_alerta_nao_rejeicao():
    assert validar("inflacao", 2016, 254.9, 2026).nivel == "alerta"
