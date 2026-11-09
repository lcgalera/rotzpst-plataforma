from news.agencia_brasil import interpretar_feed, limpar_html, motivo_exclusao
from news.agrupamento import similaridade


def test_exclui_reuters_e_proibida(fixtures):
    itens = interpretar_feed((fixtures / "ab_internacional.xml").read_bytes(), "internacional")
    assert len(itens) == 10
    reuters = [i for i in itens if i.autor and "Reuters" in i.autor]
    assert reuters and all(i.excluida_motivo for i in reuters)
    assert any(i.excluida_motivo is None for i in itens)
    assert all(i.url.startswith("https://") for i in itens)


def test_exclui_com_informacoes_da_reuters(fixtures):
    itens = interpretar_feed((fixtures / "ab_economia.xml").read_bytes(), "economia")
    com_info = [i for i in itens if "informações da Reuters" in i.texto]
    assert com_info and all("reuters" in (i.excluida_motivo or "") for i in com_info)


def test_regras_de_exclusao():
    assert (
        motivo_exclusao(
            "Fulano - Repórter da Agência Brasil", "Texto. *Com informações da TV Brasil"
        )
        is None
    )
    assert motivo_exclusao("Agência Lusa", "texto") is not None
    assert motivo_exclusao("Fulano", "Algo. *É proibida a reprodução deste conteúdo.") is not None
    assert motivo_exclusao("Fulano", "texto *com informações da AFP") is not None


def test_limpar_html():
    assert limpar_html("<p>Olá&nbsp;<b>mundo</b></p><p>Linha 2</p>") == "Olá mundo\nLinha 2"


def test_similaridade_de_titulos():
    assert (
        similaridade(
            "Copom mantém Selic em 15% ao ano", "Copom mantém a Selic em 15% ao ano pela 3ª vez"
        )
        >= 0.5
    )
    assert similaridade("Copom mantém Selic", "Senado aprova reforma") == 0.0
