"""Integração com Postgres real (pula sem DATABASE_URL_TEST)."""

import datetime as dt

import psycopg
import pytest

from comum import carga
from comum.carga import Ponto
from comum.db import migrar
from comum.sincronia import sincronizar_catalogo
from sources.paises import gravar_paises, montar_paises

HOJE = dt.date(2026, 11, 9)


@pytest.fixture
def base(conn):
    sincronizar_catalogo(conn)
    gravar_paises(conn, montar_paises({}), geometrias={"076"})
    return conn


def contar(conn, sql):
    with conn.cursor() as cur:
        cur.execute(sql)
        return cur.fetchone()[0]


def test_migrar_e_idempotente(conn):
    assert migrar(conn) == []


def test_carga_idempotente_e_validada(base):
    pontos = [
        Ponto("BRA", "inflacao", 2024, 4.8),
        Ponto("BRA", "inflacao", 2025, 5.0),
        Ponto("VEN", "inflacao", 2016, 254.9),  # alerta: grava e registra
        Ponto("BRA", "desemprego", 2024, 150.0),  # rejeitado
        Ponto("BRA", "inflacao", 2027, 3.0),  # futuro: rejeitado
        Ponto("XXX", "inflacao", 2024, 1.0),  # fora da base
    ]
    for _ in range(2):
        cid = carga.iniciar_coleta(base, "bm-wdi")
        r = carga.gravar_series(
            base,
            cid,
            "bm-wdi",
            pontos,
            edicao_fonte="teste",
            atualizado_na_fonte_em=HOJE,
            hoje=HOJE,
        )
        carga.encerrar_coleta(base, cid, linhas=r.gravados, erro=None)
    assert (r.gravados, r.alertas, r.rejeitados, r.ignorados_fora_da_base) == (3, 1, 2, 1)
    assert contar(base, "SELECT count(*) FROM series") == 3
    assert contar(base, "SELECT count(*) FROM series WHERE periodo > 2026") == 0


def test_consulta_traz_fonte_e_data(base):
    cid = carga.iniciar_coleta(base, "bm-wdi")
    carga.gravar_series(
        base,
        cid,
        "bm-wdi",
        [Ponto("BRA", "pib", 2025, 2.1e12)],
        edicao_fonte="x",
        atualizado_na_fonte_em=HOJE,
    )
    with base.cursor() as cur:
        cur.execute(
            "SELECT fonte_sigla, atualizado_na_fonte_em, fonte_licenca_url FROM series_com_fonte"
        )
        sigla, data, lic = cur.fetchone()
    assert sigla == "Banco Mundial" and data == HOJE and lic.startswith("https://")


def test_indicador_desconhecido_e_rejeitado_sem_quebrar(base):
    cid = carga.iniciar_coleta(base, "bm-wdi")
    r = carga.gravar_series(
        base,
        cid,
        "bm-wdi",
        [Ponto("BRA", "nao_existe", 2024, 1.0)],
        edicao_fonte=None,
        atualizado_na_fonte_em=None,
        hoje=HOJE,
    )
    assert r.rejeitados == 1 and contar(base, "SELECT count(*) FROM series") == 0


def test_falha_no_meio_nao_deixa_carga_pela_metade(base):
    cid = carga.iniciar_coleta(base, "bm-wdi")
    with pytest.raises(psycopg.errors.CheckViolation):
        carga.gravar_series(
            base,
            cid,
            "bm-wdi",
            [
                Ponto("BRA", "pib", 2024, 2e12),
                Ponto("BRA", "pib", 1800, 2e12),
            ],  # 1800 viola o CHECK do banco
            edicao_fonte=None,
            atualizado_na_fonte_em=None,
            hoje=HOJE,
        )
    base.rollback()
    assert contar(base, "SELECT count(*) FROM series") == 0


def test_importar_revisao_respeita_regras(base):
    from jobs.importar_revisao import aplicar

    with base.cursor() as cur:
        cur.execute(
            "INSERT INTO noticias (fonte_id, guid, url, titulo, veiculo, publicado_em, texto, palavras)"
            " VALUES ('agencia-brasil', 'g1', 'https://exemplo.invalido/1', 'T', 'Agência Brasil', now(), 'x', 1)"
            " RETURNING id"
        )
        nid = cur.fetchone()[0]
        ids = []
        for _ in range(3):
            cur.execute(
                "INSERT INTO analises (noticia_id, provedor, modelo, resumo, fato, validacao, status)"
                " VALUES (%s, 'agente-claude-code', 'teste', 'r', '{}', '{}', 'rejeitada') RETURNING id",
                (nid,),
            )
            ids.append(cur.fetchone()[0])
        cur.execute("UPDATE analises SET status = 'aguardando_revisao' WHERE id = %s", (ids[0],))
    base.commit()
    r = aplicar(
        base,
        [
            {
                "analise_id": ids[0],
                "decisao": "aprovada",
                "erros": ["fato_incorreto", "inventada"],
                "nota": None,
            },
            {
                "analise_id": ids[1],
                "decisao": "aprovada",
                "erros": [],
            },  # não estava pendente: ignora
            {
                "analise_id": ids[0],
                "decisao": "rejeitada",
                "erros": [],
                "nota": "",
            },  # rejeitar sem motivo: ignora
        ],
    )
    assert r == {"aprovada": 1, "rejeitada": 0, "ignorada": 2}
    assert (
        contar(
            base,
            f"SELECT count(*) FROM analises WHERE id = {ids[0]} AND erros = '{{fato_incorreto}}'",
        )
        == 1
    )


def test_saude_aponta_coleta_velha_e_falha(base):
    from jobs.saude import checar

    agora = dt.datetime(2026, 11, 10, tzinfo=dt.UTC)
    with base.cursor() as cur:
        cur.execute(
            "INSERT INTO coletas (fonte_id, iniciada_em, terminada_em, status) VALUES "
            "('bm-wdi', %s, %s, 'ok'), ('fmi-weo', %s, %s, 'ok'), ('agencia-brasil', %s, %s, 'erro')",
            (agora - dt.timedelta(days=30),) * 2
            + (agora - dt.timedelta(days=1),) * 2
            + (agora,) * 2,
        )
    base.commit()
    problemas = checar(base, agora)
    assert any("bm-wdi" in p and "30 dias" in p for p in problemas)
    assert not any(p.startswith("fmi-weo") for p in problemas)
    assert any("agencia-brasil: última coleta falhou" in p for p in problemas)
