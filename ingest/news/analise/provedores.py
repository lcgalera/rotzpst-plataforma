"""Provedores de IA trocáveis. Todos seguem o mesmo contrato: lote.json -> lote.resultado.json.

- agente-claude-code (PADRÃO, ligado): o agente do Claude Code lê o lote e as `instrucoes.md` e grava o resultado.
  Roda na assinatura Claude Pro do dono (sessão interativa ou tarefa agendada): sem cobrança de API.
- anthropic-api (DESLIGADO): exigiria chave e créditos de API, que o plano Pro não inclui. Só ligar com teto.
- gemini-api (DESLIGADO): o Gemini 4 Argon não tem camada gratuita na API; a assinatura Google AI Pro não cobre a API.
  A documentação oficial (ai.google.dev) não pôde ser lida deste ambiente, então nenhum código de SDK foi escrito
  para não inventar endpoints. Ver docs/decisoes.md.
"""

from __future__ import annotations

PROVEDORES = {
    "agente-claude-code": {"ligado": True, "custo": "assinatura (sem cobrança de API)"},
    "anthropic-api": {
        "ligado": False,
        "motivo": "plano Pro sem créditos de API; evitar gasto excedente",
    },
    "gemini-api": {
        "ligado": False,
        "motivo": "Argon sem camada gratuita; documentação oficial ainda não lida",
    },
}


def exigir_ligado(nome: str) -> None:
    p = PROVEDORES.get(nome)
    if p is None:
        raise ValueError(f"Provedor desconhecido: {nome}")
    if not p["ligado"]:
        raise RuntimeError(f"Provedor '{nome}' está desligado: {p['motivo']}")
