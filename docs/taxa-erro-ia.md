# Taxa de erro das análises de IA

> Gerado por `ingest/jobs/taxa_erro.py` em 2026-11-10 a partir do banco. **Não editar à mão.**
> Rode `uv run python -m jobs.noticias taxa-erro` depois de cada rodada de revisão.

**Como ler:** uma análise "com erro" foi rejeitada na revisão humana ou aprovada com alguma categoria de erro
marcada. O intervalo de confiança (Wilson, 95%) mostra a incerteza: com poucas revisões ele é largo, e o número
sozinho não deve ser usado para decidir automatizar a publicação (PLANO-ROTZX §6).

## Por provedor e modelo

| Provedor | Modelo | Geradas | Barradas pelo validador | Aguardando revisão | Revisadas | Rejeitadas | Aprovadas com erro | Taxa de erro |
|---|---|---:|---:|---:|---:|---:|---:|---|
| agente-claude-code | `claude-opus-5-5` | 20 | 0 | 0 | 20 | 3 | 1 | 20,0% (IC 95%: 8,1% a 41,6%) |

## Erros por categoria (revisão humana)

| Categoria | Ocorrências |
|---|---:|
| Fato incorreto ou distorcido | 3 |

## Campos deixados vazios por falta de base no texto

- Interpretação vazia: 3 de 20
- Impacto vazio: 4 de 20

Campo vazio não é erro: é a regra anti-alucinação funcionando (o modelo não preenche por suposição).
