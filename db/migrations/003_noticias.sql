-- 003_noticias: notícias, eventos, análises de IA e revisão humana (Fase 3).
-- Regra: o texto integral da fonte fica só para uso interno da análise e NUNCA é exibido no site.

INSERT INTO fontes_dados (id, nome, sigla, url, licenca, licenca_url, atribuicao, frequencia, observacoes)
VALUES (
    'agencia-brasil',
    'Agência Brasil (EBC)',
    'Agência Brasil',
    'https://agenciabrasil.ebc.com.br',
    'Reprodução autorizada para veículos de comunicação com fins jornalísticos, mediante indicação da fonte; uso comercial exige contato com o licenciamento da EBC',
    'https://agenciabrasil.ebc.com.br/sobre',
    'Agência Brasil',
    'Contínua (feeds RSS por editoria)',
    'Conteúdo de agências parceiras e itens marcados "proibida a reprodução" são excluídos na coleta.'
) ON CONFLICT (id) DO NOTHING;

-- Agrupa notícias sobre o mesmo acontecimento.
CREATE TABLE eventos (
    id          bigserial PRIMARY KEY,
    titulo_ref  text NOT NULL,
    criado_em   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE noticias (
    id             bigserial PRIMARY KEY,
    fonte_id       text NOT NULL REFERENCES fontes_dados (id),
    guid           text NOT NULL,
    url            text NOT NULL UNIQUE,
    titulo         text NOT NULL,
    veiculo        text NOT NULL,                -- nome exibido na atribuição
    autor          text,
    editoria       text,                         -- editoria do feed (economia, politica, internacional)
    tags           text[] NOT NULL DEFAULT '{}',
    publicado_em   timestamptz NOT NULL,
    texto          text NOT NULL,                -- USO INTERNO: base da análise; nunca exibido
    palavras       integer NOT NULL,
    excluida_motivo text,                        -- preenchido = não pode ser analisada/publicada
    evento_id      bigint REFERENCES eventos (id),
    coletado_em    timestamptz NOT NULL DEFAULT now(),
    UNIQUE (fonte_id, guid)
);

CREATE INDEX noticias_publicado ON noticias (publicado_em DESC);

-- Uma análise por notícia e versão. Só 'aprovada' aparece no site.
CREATE TABLE analises (
    id              bigserial PRIMARY KEY,
    noticia_id      bigint NOT NULL REFERENCES noticias (id) ON DELETE CASCADE,
    provedor        text NOT NULL,               -- 'agente-claude-code', 'anthropic-api', 'gemini-api'
    modelo          text NOT NULL,               -- id do modelo informado por quem gerou
    lote            text,                        -- arquivo de lote de origem
    gerado_em       timestamptz NOT NULL DEFAULT now(),
    resumo          text NOT NULL,               -- resumo curto próprio (não é cópia do texto)
    fato            jsonb NOT NULL,              -- {texto, citacoes:[{trecho}]}
    interpretacao   jsonb,                       -- null = sem base no texto
    impacto         jsonb,                       -- null = sem base no texto
    paises          char(3)[] NOT NULL DEFAULT '{}',
    temas           text[] NOT NULL DEFAULT '{}',
    validacao       jsonb NOT NULL,              -- resultado do validador automático
    status          text NOT NULL DEFAULT 'aguardando_revisao'
                    CHECK (status IN ('aguardando_revisao', 'aprovada', 'rejeitada')),
    erros           text[] NOT NULL DEFAULT '{}', -- categorias de erro marcadas na revisão
    revisao_nota    text,
    revisado_em     timestamptz,
    CHECK (temas <@ ARRAY['economia', 'politica', 'geopolitica']::text[])
);

CREATE UNIQUE INDEX analises_uma_pendente_por_noticia ON analises (noticia_id) WHERE status <> 'rejeitada';

-- Relações do plano (noticia_pais, noticia_tema): derivadas da análise APROVADA.
CREATE VIEW noticia_pais AS
SELECT a.noticia_id, unnest(a.paises) AS pais_iso3 FROM analises a WHERE a.status = 'aprovada';

CREATE VIEW noticia_tema AS
SELECT a.noticia_id, unnest(a.temas) AS tema FROM analises a WHERE a.status = 'aprovada';

-- Custo por chamada (provedores de API). O agente via assinatura registra custo 0 e o provedor.
CREATE TABLE custos_ia (
    id             bigserial PRIMARY KEY,
    provedor       text NOT NULL,
    modelo         text NOT NULL,
    noticia_id     bigint REFERENCES noticias (id) ON DELETE SET NULL,
    tokens_entrada integer,
    tokens_saida   integer,
    custo_usd      numeric(10, 5) NOT NULL DEFAULT 0,
    registrado_em  timestamptz NOT NULL DEFAULT now()
);
