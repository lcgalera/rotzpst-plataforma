from comum.catalogo import PILOTO
from sources.paises import montar_paises, regioes_banco_mundial


def test_base_iso_completa_e_nomes_revisados():
    paises = montar_paises({"BRA": "América Latina e Caribe"})
    por_iso = {p.iso3: p for p in paises}
    assert len(paises) == 249
    assert len({p.iso2 for p in paises}) == 249
    assert por_iso["BRA"].nome_pt == "Brasil"
    assert por_iso["BRA"].regiao == "América Latina e Caribe"
    assert por_iso["KOR"].nome_pt == "Coreia do Sul"
    assert por_iso["TWN"].nome_pt == "Taiwan"
    assert por_iso["RUS"].nome_pt == "Rússia"
    assert por_iso["TWN"].regiao is None


def test_piloto():
    paises = montar_paises({})
    assert sum(p.piloto for p in paises) == len(PILOTO) == 27
    assert "ARG" in PILOTO and PILOTO.count("ARG") == 1


def test_regioes_ignoram_agregados():
    resp = [
        {},
        [
            {"id": "BRA", "region": {"id": "LCN", "value": "Latin America & Caribbean "}},
            {"id": "WLD", "region": {"id": "NA", "value": "Aggregates"}},
        ],
    ]
    assert regioes_banco_mundial(resp) == {"BRA": "América Latina e Caribe"}
