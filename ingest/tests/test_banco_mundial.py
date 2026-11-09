import datetime as dt
import json

import pytest

from sources.banco_mundial import interpretar, url_indicador


def test_interpreta_resposta_real(fixtures):
    resp = json.loads((fixtures / "bm_inflacao_bra_ven.json").read_text())
    pontos, atualizado, paginas = interpretar(resp, "inflacao")
    assert atualizado == dt.date(2026, 10, 8)
    assert paginas == 1
    ven = {p.periodo: p.valor for p in pontos if p.pais_iso3 == "VEN"}
    # Nulos da API são ausência: não viram zero nem estimativa.
    assert max(ven) == 2016
    assert 2017 not in ven
    assert all(p.indicador == "inflacao" for p in pontos)


def test_erro_da_api_vira_excecao():
    with pytest.raises(RuntimeError):
        interpretar([{"message": [{"id": "120", "value": "Invalid value"}]}], "pib")


def test_url_junta_paises():
    assert "/country/BRA;ARG/indicator/NY.GDP.MKTP.CD?" in url_indicador(
        "NY.GDP.MKTP.CD", ("BRA", "ARG")
    )
