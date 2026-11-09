import datetime as dt

from sources.fmi_weo import interpretar, url_dados


def test_corta_projecoes_e_descarta_ano_fiscal(fixtures):
    leitura = interpretar((fixtures / "fmi_divida_deu_ind.xml").read_bytes(), "divida_publica_pib")
    assert leitura.publicado_em == dt.date(2026, 10, 13)
    anos_deu = sorted(p.periodo for p in leitura.pontos if p.pais_iso3 == "DEU")
    assert anos_deu, "Alemanha deveria ter dados observados"
    # Nada além do último ano observado informado pelo FMI
    assert max(anos_deu) <= 2025
    assert leitura.projecoes_descartadas > 0
    # Índia vem em ano fiscal (FY2024/25): sem correspondência confirmada, fica de fora
    assert "IND" in leitura.descartados
    assert "FY" in leitura.descartados["IND"]
    assert all(p.pais_iso3 != "IND" for p in leitura.pontos)


def test_url_dirigida():
    assert url_dados("GGXWDG_NGDP", ("BRA", "ARG")).endswith(
        "/data/IMF.RES,WEO/BRA+ARG.GGXWDG_NGDP.A?detail=full"
    )
