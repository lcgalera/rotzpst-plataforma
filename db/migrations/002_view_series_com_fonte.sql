-- Consulta padrão para a interface: todo valor sai com fonte, licença e datas. (Princípio 1 do plano.)
CREATE VIEW series_com_fonte AS
SELECT
    s.pais_iso3,
    p.nome_pt               AS pais_nome,
    s.indicador_codigo,
    i.nome_pt               AS indicador_nome,
    i.unidade,
    i.nota_metodologica,
    s.periodo,
    s.valor,
    f.id                    AS fonte_id,
    f.sigla                 AS fonte_sigla,
    f.nome                  AS fonte_nome,
    f.url                   AS fonte_url,
    f.atribuicao            AS fonte_atribuicao,
    f.licenca_url           AS fonte_licenca_url,
    s.edicao_fonte,
    s.atualizado_na_fonte_em,
    s.coletado_em
FROM series s
JOIN paises p      ON p.iso3 = s.pais_iso3
JOIN indicadores i ON i.codigo = s.indicador_codigo
JOIN fontes_dados f ON f.id = s.fonte_id;
