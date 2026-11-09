"""Smoke test da Fase 0: os pacotes de ingestão existem e importam."""

import importlib

import pytest


@pytest.mark.parametrize("pacote", ["sources", "news", "jobs"])
def test_pacotes_importam(pacote: str) -> None:
    assert importlib.import_module(pacote) is not None
