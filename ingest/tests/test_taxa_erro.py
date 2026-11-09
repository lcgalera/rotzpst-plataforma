from jobs.taxa_erro import wilson


def test_wilson_limites():
    lo, hi = wilson(0, 20)
    assert lo == 0.0 and 0.10 < hi < 0.20  # 0 erros em 20 ainda é compatível com ~16%
    lo, hi = wilson(10, 20)
    assert lo < 0.5 < hi
    assert wilson(0, 0) == (0.0, 1.0)
