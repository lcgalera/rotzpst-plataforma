"""Gera docs/qualidade-dados.md a partir do banco: cobertura, defasagem e anomalias do piloto.

Uso (dentro de ingest/):  DATABASE_URL=... uv run python -m jobs.relatorio_qualidade
"""

from __future__ import annotations

import datetime as dt
import sys
from pathlib import Path

import psycopg

from comum.catalogo import INDICADORES, PILOTO
from comum.db import conectar

DESTINO = Path(__file__).resolve().parents[2] / "docs" / "qualidade-dados.md"
# Defasagem a partir da qual o último dado é considerado velho (anos).
LIMITE_DEFASAGEM = 3


def gerar(conn: psycopg.Connection, hoje: dt.date) -> str:
    ano = hoje.year
    with conn.cursor() as cur:
        cur.execute(
            "SELECT pais_iso3, indicador_codigo, max(periodo), count(*) FROM series"
            " WHERE pais_iso3 = ANY(%s) GROUP BY 1, 2",
            (list(PILOTO),),
        )
        cob = {(p, i): (ultimo, n) for p, i, ultimo, n in cur.fetchall()}
        cur.execute(
            "SELECT iso3, nome_pt, geometria_ref, regiao FROM paises WHERE iso3 = ANY(%s)",
            (list(PILOTO),),
        )
        info = {r[0]: r[1:] for r in cur.fetchall()}
        cur.execute("SELECT count(*), count(geometria_ref), count(regiao) FROM paises")
        total, com_geo, com_regiao = cur.fetchone()
        cur.execute("SELECT iso3, nome_pt FROM paises WHERE geometria_ref IS NULL ORDER BY nome_pt")
        sem_geo = cur.fetchall()
        cur.execute(
            """
            SELECT DISTINCT ON (fonte_id) fonte_id, id, iniciada_em, status, linhas_gravadas, erro
            FROM coletas ORDER BY fonte_id, iniciada_em DESC
            """
        )
        coletas = cur.fetchall()
        ultimas = [c[1] for c in coletas]
        cur.execute(
            """
            SELECT a.nivel, a.pais_iso3, a.indicador_codigo, a.periodo, a.valor, a.regra
            FROM anomalias a WHERE a.coleta_id = ANY(%s)
            ORDER BY a.nivel DESC, a.indicador_codigo, a.pais_iso3, a.periodo
            """,
            (ultimas,),
        )
        anomalias = cur.fetchall()
        cur.execute(
            "SELECT indicador_codigo, fonte_id, max(atualizado_na_fonte_em), max(edicao_fonte) FROM series GROUP BY 1, 2"
        )
        atualizacoes = {r[0]: r[1:] for r in cur.fetchall()}

    def celula(p: str, i: str) -> str:
        if (p, i) not in cob:
            return "—"
        ultimo, _ = cob[(p, i)]
        return f"**{ultimo}** ⚠️" if ano - ultimo > LIMITE_DEFASAGEM else str(ultimo)

    ind_cods = [i.codigo for i in INDICADORES]
    cabeca = "| País | " + " | ".join(i.nome_pt for i in INDICADORES) + " |"
    sep = "|---|" + "---|" * len(INDICADORES)
    linhas = [
        f"| {info[p][0]} ({p}) | " + " | ".join(celula(p, c) for c in ind_cods) + " |"
        for p in PILOTO
    ]

    resumo_ind = []
    for i in INDICADORES:
        com = [p for p in PILOTO if (p, i.codigo) in cob]
        recentes = [p for p in com if ano - cob[(p, i.codigo)][0] <= LIMITE_DEFASAGEM]
        faltam = [p for p in PILOTO if p not in com]
        velhos = [p for p in com if p not in recentes]
        fonte_id, atualizado, edicao = atualizacoes.get(i.codigo) or (i.fonte_id, None, None)
        resumo_ind.append(
            f"| {i.nome_pt} | {fonte_id} | {edicao or '—'} | {len(recentes)}/{len(PILOTO)} | "
            f"{', '.join(faltam) or '—'} | {', '.join(velhos) or '—'} |"
        )

    alertas = [a for a in anomalias if a[0] == "alerta"]
    rejeitados = [a for a in anomalias if a[0] == "rejeitado"]

    def fmt_anom(a: tuple) -> str:
        nivel, p, i, per, v, regra = a
        return (
            f"| {nivel} | {p} | {i} | {per} | {v:,.2f} | {regra} |".replace(",", "X")
            .replace(".", ",")
            .replace("X", ".")
        )

    coletas_md = "\n".join(
        f"| {c[0]} | {c[2]:%Y-%m-%d %H:%M} UTC | {c[3]} | {c[4] if c[4] is not None else '—'} | {c[5] or '—'} |"
        for c in coletas
    )

    return f"""# Qualidade e cobertura de dados

> Gerado por `ingest/jobs/relatorio_qualidade.py` a partir do banco em {hoje.isoformat()}. **Não editar à mão.**
> Conjunto piloto: {len(PILOTO)} países (G20 + vizinhos do Brasil). Defasagem marcada com ⚠️ quando o último ano tem mais de {LIMITE_DEFASAGEM} anos.

## Resumo por indicador

| Indicador | Fonte | Edição | Países com dado recente | Sem nenhum dado | Só dado antigo |
|---|---|---|---|---|---|
{chr(10).join(resumo_ind)}

## Último ano disponível por país

{cabeca}
{sep}
{chr(10).join(linhas)}

## Base de países

- Países e territórios ISO 3166-1 na base: {total}
- Com geometria (Natural Earth 1:50m): {com_geo}. Sem geometria (pequenos demais para a escala ou sem feição própria): {total - com_geo}
- Com região do Banco Mundial: {com_regiao}. Sem região: {total - com_regiao} (territórios e casos que o Banco Mundial não classifica, como Taiwan)

<details><summary>Sem geometria ({len(sem_geo)})</summary>

{", ".join(f"{n} ({i})" for i, n in sem_geo)}

</details>

## Última coleta por fonte

| Fonte | Início | Status | Linhas gravadas | Erro |
|---|---|---|---|---|
{coletas_md}

## Anomalias da última coleta

Rejeitados (não gravados): {len(rejeitados)}. Alertas (gravados, para revisão): {len(alertas)}.
Faixas em `ingest/comum/validacao.py`. Alerta não é erro: hiperinflação e choques de PIB são reais, mas merecem conferência.

| Nível | País | Indicador | Ano | Valor | Regra |
|---|---|---|---|---:|---|
{chr(10).join(fmt_anom(a) for a in rejeitados + alertas) or "| — | | | | | |"}
"""


def main() -> int:
    with conectar() as conn:
        DESTINO.write_text(gerar(conn, dt.date.today()), encoding="utf-8")
    print(f"Relatório gravado em {DESTINO}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
