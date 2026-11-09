"""HTTP simples com timeout e novas tentativas. Identifica o cliente sem dados pessoais."""

from __future__ import annotations

import json
import time
import urllib.error
import urllib.request
from typing import Any

USER_AGENT = "rotzx-ingest/0.1"


def baixar(
    url: str, *, aceitar: str | None = None, tentativas: int = 4, timeout: int = 90
) -> bytes:
    cabecalhos = {"User-Agent": USER_AGENT}
    if aceitar:
        cabecalhos["Accept"] = aceitar
    espera = 2.0
    for n in range(1, tentativas + 1):
        try:
            req = urllib.request.Request(url, headers=cabecalhos)
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                return resp.read()
        except urllib.error.HTTPError as e:
            # 4xx (exceto 429) não melhora tentando de novo
            if 400 <= e.code < 500 and e.code != 429:
                raise
            if n == tentativas:
                raise
        except (urllib.error.URLError, TimeoutError):
            if n == tentativas:
                raise
        time.sleep(espera)
        espera *= 2
    raise RuntimeError("inalcançável")


def baixar_json(url: str, **kw: Any) -> Any:
    return json.loads(baixar(url, **kw))
