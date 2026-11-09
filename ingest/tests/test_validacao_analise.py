import jsonschema
import pytest

from news.analise.esquema import ESQUEMA_ANALISE
from news.analise.validacao import maior_sequencia_copiada, validar

# Texto fictício, só para teste.
FONTE = (
    "O Comitê de Política Monetária (Copom) do Banco Central manteve a taxa básica de juros em 15% ao ano. "
    "Segundo o comunicado, a decisão foi unânime. Para economistas ouvidos pela reportagem, o corte deve "
    "começar no próximo ano, o que pode baratear o crédito para empresas."
)
PAISES = {"BRA", "USA"}


def analise(**mudancas):
    base = {
        "noticia_id": 1,
        "resumo": "O BC brasileiro deixou os juros inalterados, em decisão sem divergências.",
        "fato": {
            "texto": "O Copom manteve a Selic em 15% ao ano, por unanimidade, segundo o Banco Central.",
            "citacoes": [{"trecho": "manteve a taxa básica de juros em 15% ao ano"}],
        },
        "interpretacao": {
            "texto": "Para analistas, a política monetária segue apertada, com afrouxamento só adiante.",
            "citacoes": [{"trecho": "o corte deve começar no próximo ano"}],
        },
        "impacto": None,
        "paises": ["BRA"],
        "temas": ["economia"],
    }
    base.update(mudancas)
    return base


def test_analise_boa_passa_e_obedece_esquema():
    a = analise()
    jsonschema.validate(a, ESQUEMA_ANALISE)
    r = validar(a, FONTE, PAISES)
    assert r.ok, r.erros
    assert "sem impacto (sem base no texto)" in r.avisos


def test_citacao_inventada_reprova():
    a = analise(
        fato={
            "texto": "O Copom manteve a Selic.",
            "citacoes": [{"trecho": "elevou a taxa para 16%"}],
        }
    )
    r = validar(a, FONTE, PAISES)
    assert not r.ok and any("não encontrada" in e for e in r.erros)


def test_citacao_com_aspas_tipograficas_e_espacos_passa():
    fonte = "Ele disse: “vamos  avaliar” a proposta."
    a = analise(
        fato={"texto": "Ele prometeu avaliar.", "citacoes": [{"trecho": 'disse: "vamos avaliar"'}]},
        interpretacao=None,
    )
    assert validar(a, fonte, PAISES).ok


def test_fato_sem_citacao_reprova():
    assert not validar(analise(fato={"texto": "Algo.", "citacoes": []}), FONTE, PAISES).ok


def test_copia_longa_no_texto_proprio_reprova():
    copia = "Para economistas ouvidos pela reportagem, o corte deve começar no próximo ano, o que pode baratear o crédito"
    r = validar(analise(resumo=copia), FONTE, PAISES)
    assert not r.ok and any("copia" in e for e in r.erros)


def test_pais_e_tema_invalidos():
    r = validar(analise(paises=["XYZ"], temas=["esporte"]), FONTE, PAISES)
    assert any("país" in e for e in r.erros) and any("tema" in e for e in r.erros)


@pytest.mark.parametrize(
    ("proprio", "esperado"), [("zebra quântica", 0), ("taxa básica de juros", 4)]
)
def test_maior_sequencia(proprio, esperado):
    assert maior_sequencia_copiada(proprio, FONTE) == esperado
