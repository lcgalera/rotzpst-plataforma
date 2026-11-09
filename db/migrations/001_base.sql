-- 001_base: países, fontes, indicadores e séries (Fase 1).
-- Notícias e análises entram na Fase 3, em migração própria.

CREATE TABLE fontes_dados (
    id            text PRIMARY KEY,               -- ex.: 'bm-wdi', 'fmi-weo'
    nome          text NOT NULL,                  -- nome exibido ("Banco Mundial, World Development Indicators")
    sigla         text NOT NULL,                  -- curto, para "Fonte: FMI, atualizado em ..."
    url           text NOT NULL,                  -- página oficial do dataset
    licenca       text NOT NULL,
    licenca_url   text NOT NULL,
    atribuicao    text NOT NULL,                  -- texto de citação exigido pela fonte
    frequencia    text NOT NULL,
    observacoes   text
);

CREATE TABLE paises (
    iso3            char(3) PRIMARY KEY,
    iso2            char(2) NOT NULL UNIQUE,
    iso_num         char(3) NOT NULL UNIQUE,
    nome_pt         text NOT NULL,
    nome_en         text NOT NULL,
    regiao          text,                         -- região do Banco Mundial; NULL quando a fonte não classifica
    piloto          boolean NOT NULL DEFAULT false,
    geometria_ref   char(3),                      -- id da feição em data/geo (ISO numérico); NULL se não houver geometria
    atualizado_em   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE indicadores (
    codigo           text PRIMARY KEY,            -- código do rotzx, ex.: 'pib'
    nome_pt          text NOT NULL,
    unidade          text NOT NULL,               -- 'USD', '%', '% do PIB', 'pessoas'
    categoria        text NOT NULL CHECK (categoria IN ('economia', 'social', 'comercio')),
    descricao        text NOT NULL,               -- o que o número mede, em linguagem clara
    fonte_id         text NOT NULL REFERENCES fontes_dados (id),
    codigo_na_fonte  text NOT NULL,               -- ex.: 'NY.GDP.MKTP.CD'
    nota_metodologica text                        -- ressalvas obrigatórias (ex.: "estimativa modelada da OIT")
);

-- Uma linha por país × indicador × ano. Só valores observados: projeções não entram.
CREATE TABLE series (
    pais_iso3               char(3) NOT NULL REFERENCES paises (iso3),
    indicador_codigo        text NOT NULL REFERENCES indicadores (codigo),
    periodo                 smallint NOT NULL CHECK (periodo BETWEEN 1900 AND 2100),
    valor                   double precision NOT NULL,
    fonte_id                text NOT NULL REFERENCES fontes_dados (id),
    edicao_fonte            text,                 -- ex.: 'WEO outubro 2026'
    atualizado_na_fonte_em  date,                 -- data de atualização informada pela fonte
    coletado_em             timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (pais_iso3, indicador_codigo, periodo)
);

CREATE INDEX series_indicador_periodo ON series (indicador_codigo, periodo);

-- Registro de cada execução de ingestão (falha segura e monitoramento).
CREATE TABLE coletas (
    id             bigserial PRIMARY KEY,
    fonte_id       text NOT NULL REFERENCES fontes_dados (id),
    iniciada_em    timestamptz NOT NULL DEFAULT now(),
    terminada_em   timestamptz,
    status         text NOT NULL DEFAULT 'rodando' CHECK (status IN ('rodando', 'ok', 'erro')),
    linhas_gravadas integer,
    erro           text
);

-- Valores que falharam na validação. 'rejeitado' não vai para series; 'alerta' vai, mas fica registrado.
CREATE TABLE anomalias (
    id                bigserial PRIMARY KEY,
    coleta_id         bigint NOT NULL REFERENCES coletas (id) ON DELETE CASCADE,
    pais_iso3         char(3) NOT NULL,
    indicador_codigo  text NOT NULL,
    periodo           smallint NOT NULL,
    valor             double precision,
    nivel             text NOT NULL CHECK (nivel IN ('rejeitado', 'alerta')),
    regra             text NOT NULL,
    registrada_em     timestamptz NOT NULL DEFAULT now()
);
