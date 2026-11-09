"""Gera docs/taxa-erro-ia.md: qualidade das análises de IA medida na revisão humana.

Definições:
- Revisada = aprovada ou rejeitada por uma pessoa no painel /revisao.
- Com erro = rejeitada OU aprovada com alguma categoria de erro marcada.
- Taxa de erro = com erro / revisadas, com intervalo de Wilson de 95% (amostras pequenas enganam).
- Reprovações do validador automático são contadas à parte (nunca chegam ao revisor).
"""

from __future__ import annotations

import datetime as dt
import math
from pathlib import Path

import psycopg

DESTINO = Path(__file__).resolve().parents[2] / "docs" / "taxa-erro-ia.md"
AMOSTRA_MINIMA = 20
CATEGORIAS = {
    "fato_incorreto": "Fato incorreto ou distorcido",
    "citacao_fora_de_contexto": "Citação fora de contexto",
    "interpretacao_sem_base": "Interpretação sem base no texto",
    "impacto_sem_base": "Impacto sem base no texto",
    "pais_errado": "País errado ou faltando",
    "tema_errado": "Tema errado",
    "nao_neutro": "Linguagem não neutra",
    "outro": "Outro",
}


def wilson(k: int, n: int, z: float = 1.96) -> tuple[float, float]:
    if n == 0:
        return (0.0, 1.0)
    p = k / n
    den = 1 + z * z / n
    centro = (p + z * z / (2 * n)) / den
    margem = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / den
    return (max(0.0, centro - margem), min(1.0, centro + margem))


def pct(x: float) -> str:
    return f"{x * 100:.1f}%".replace(".", ",")


def gerar(conn: psycopg.Connection, hoje: dt.date | None = None) -> str:
    hoje = hoje or dt.date.today()
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT provedor, modelo,
                   count(*) FILTER (WHERE 'reprovada_no_validador' = ANY(erros)) AS validador,
                   count(*) FILTER (WHERE status = 'aguardando_revisao') AS pendentes,
                   count(*) FILTER (WHERE status IN ('aprovada', 'rejeitada') AND NOT 'reprovada_no_validador' = ANY(erros)) AS revisadas,
                   count(*) FILTER (WHERE status = 'rejeitada' AND NOT 'reprovada_no_validador' = ANY(erros)) AS rejeitadas,
                   count(*) FILTER (WHERE status = 'aprovada' AND cardinality(erros) > 0) AS aprovadas_com_erro,
                   count(*) AS total
            FROM analises GROUP BY 1, 2 ORDER BY 1, 2
            """
        )
        por_modelo = cur.fetchall()
        cur.execute(
            """
            SELECT e, count(*) FROM analises, unnest(erros) e
            WHERE status IN ('aprovada', 'rejeitada') AND e <> 'reprovada_no_validador'
            GROUP BY 1 ORDER BY 2 DESC
            """
        )
        por_categoria = cur.fetchall()
        cur.execute(
            """
            SELECT count(*) FILTER (WHERE interpretacao IS NULL), count(*) FILTER (WHERE impacto IS NULL), count(*)
            FROM analises WHERE NOT 'reprovada_no_validador' = ANY(erros)
            """
        )
        sem_interp, sem_imp, total_validas = cur.fetchone()

    linhas = []
    for prov, modelo, valid, pend, rev, rej, apr_err, total in por_modelo:
        com_erro = rej + apr_err
        if rev:
            lo, hi = wilson(com_erro, rev)
            taxa = f"{pct(com_erro / rev)} (IC 95%: {pct(lo)} a {pct(hi)})"
        else:
            taxa = "—"
        aviso = "" if rev >= AMOSTRA_MINIMA else f" ⚠️ amostra < {AMOSTRA_MINIMA}"
        linhas.append(
            f"| {prov} | `{modelo}` | {total} | {valid} | {pend} | {rev} | {rej} | {apr_err} | {taxa}{aviso} |"
        )

    cats = "\n".join(f"| {CATEGORIAS.get(c, c)} | {n} |" for c, n in por_categoria) or "| — | 0 |"
    md = f"""# Taxa de erro das análises de IA

> Gerado por `ingest/jobs/taxa_erro.py` em {hoje.isoformat()} a partir do banco. **Não editar à mão.**
> Rode `uv run python -m jobs.noticias taxa-erro` depois de cada rodada de revisão.

**Como ler:** uma análise "com erro" foi rejeitada na revisão humana ou aprovada com alguma categoria de erro
marcada. O intervalo de confiança (Wilson, 95%) mostra a incerteza: com poucas revisões ele é largo, e o número
sozinho não deve ser usado para decidir automatizar a publicação (PLANO-ROTZX §6).

## Por provedor e modelo

| Provedor | Modelo | Geradas | Barradas pelo validador | Aguardando revisão | Revisadas | Rejeitadas | Aprovadas com erro | Taxa de erro |
|---|---|---:|---:|---:|---:|---:|---:|---|
{chr(10).join(linhas) or "| — | — | 0 | 0 | 0 | 0 | 0 | 0 | — |"}

## Erros por categoria (revisão humana)

| Categoria | Ocorrências |
|---|---:|
{cats}

## Campos deixados vazios por falta de base no texto

- Interpretação vazia: {sem_interp} de {total_validas}
- Impacto vazio: {sem_imp} de {total_validas}

Campo vazio não é erro: é a regra anti-alucinação funcionando (o modelo não preenche por suposição).
"""
    DESTINO.write_text(md, encoding="utf-8")
    return str(DESTINO)
