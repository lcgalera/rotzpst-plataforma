import base64
import hashlib

import pytest

from sources.geo import conferir_integridade, ids_iso


def test_ids_iso_ignora_feicoes_sem_codigo():
    topo = {
        "objects": {"countries": {"geometries": [{"id": "076"}, {"id": None}, {}, {"id": "-99"}]}}
    }
    assert ids_iso(topo) == {"076"}


def test_integridade():
    dados = b"abc"
    ok = "sha512-" + base64.b64encode(hashlib.sha512(dados).digest()).decode()
    conferir_integridade(dados, ok)
    with pytest.raises(ValueError):
        conferir_integridade(b"outro", ok)
