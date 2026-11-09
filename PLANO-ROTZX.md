# PLANO-ROTZX.md: plano mestre do produto

> Instruções para o Claude Code. Este é o **plano mestre**. O visual, os tokens e os componentes estão em `PLANO-DESIGN.md` e valem como especificação de design. Quando os dois conflitarem em algo de **produto, dados ou arquitetura**, vale este arquivo; em algo de **visual**, vale o `PLANO-DESIGN.md`. Siga as fases na ordem e não implemente nada de fase futura sem eu pedir.

## 1. Visão do produto

**rotzx** é uma plataforma de economia, geopolítica e inteligência global, apresentada como uma publicação editorial com ferramentas de exploração. O usuário navega por um **globo interativo**, abre o **panorama de qualquer país** (economia, política, geopolítica), compara indicadores e lê notícias organizadas em **fato, interpretação e impacto**.

**Promessa:** entender o cenário global com clareza, sem ruído de terminal financeiro nem de portal de notícias.

**Princípios**
1. **Todo dado tem fonte e data de atualização visíveis.**
2. **Nunca inventar dados.** Dado ausente aparece como ausente, nunca como estimativa disfarçada.
3. **Separar fato de interpretação**, sempre.
4. **Conteúdo gerado por IA é rotulado** e sempre aponta para as fontes originais.
5. **Português brasileiro primeiro**, preparado para outros idiomas depois.
6. Neutralidade e precisão acima de estética.

## 2. Escopo do MVP

**Entra**
- Home editorial com resumo do cenário global.
- Globo interativo (com alternativa em mapa plano).
- Página de país com indicadores e notícias recentes.
- Comparador de 2 a 4 países.
- Notícias com classificação por país e tema, e estrutura fato/interpretação/impacto.
- Página de metodologia e fontes.

**Não entra (pós-MVP)**
- Contas de usuário, alertas, favoritos.
- Newsletter automatizada e API pública.
- Monetização.
- Mais de um idioma.
- App nativo.

**Escopo de países [DECISÃO PADRÃO]:** a base cobre todos os países com código ISO, mas o **conteúdo completo** (indicadores + notícias) é garantido primeiro para um conjunto piloto: G20 + vizinhos do Brasil. Os demais mostram o que houver, com estado vazio honesto.

## 3. Arquitetura e stack

| Camada | Escolha [DECISÃO PADRÃO] | Motivo |
|---|---|---|
| Frontend | **Next.js (App Router) + TypeScript** | SEO nas páginas de país e notícia, renderização estática/incremental |
| Estilo | CSS com os tokens do `PLANO-DESIGN.md` | Fidelidade ao design system |
| Mapa/globo | **MapLibre GL** (projeção globo) ou **globe.gl**; decidir na Fase 2 após teste de desempenho | Sem custo de licença de mapas proprietários |
| Gráficos | D3 ou Observable Plot, com tema próprio | Controle editorial total |
| Banco | **PostgreSQL** (Supabase ou similar) | Séries temporais e relações simples |
| Ingestão de dados | **Python** (pandas/DuckDB) em jobs agendados | Tratamento de dados econômicos |
| Agendamento | GitHub Actions cron ou cron do provedor | Barato no começo |
| IA (classificação e resumo) | **API da Anthropic**, saída estruturada em JSON | Ver seção 6; confirmar modelos e preços na documentação oficial |
| Deploy | Vercel (web) + provedor simples para jobs | Custo baixo |

> Se houver problema sério em qualquer escolha, proponha alternativa **antes** de codar e espere minha resposta.

### Estrutura de pastas
```
/
├── PLANO-ROTZX.md
├── PLANO-DESIGN.md
├── CLAUDE.md
├── web/                  # Next.js
│   ├── app/
│   ├── components/
│   └── styles/tokens.css
├── ingest/               # jobs Python
│   ├── sources/          # um módulo por fonte de dados
│   ├── news/
│   ├── jobs/
│   └── tests/
├── db/
│   └── migrations/
├── data/
│   ├── raw/              # nunca editar à mão
│   └── geo/              # geometrias de países
└── docs/
    ├── decisoes.md
    ├── fontes.md
    ├── contraste.md
    └── qualidade-dados.md
```

## 4. Fontes de dados

> **Regra:** para cada fonte, **confirmar na documentação oficial** o que está disponível, o formato, a frequência de atualização e a **licença/termos de uso** antes de escrever o código. Não inventar endpoints nem campos. Registrar tudo em `docs/fontes.md`.

**Candidatas a avaliar (não são garantia de disponibilidade):**
- **Indicadores econômicos e sociais:** Banco Mundial (dados abertos), FMI, OCDE, ONU/UN Data.
- **Comércio:** UN Comtrade.
- **Brasil em detalhe:** Banco Central do Brasil (séries) e IBGE.
- **Geometrias e metadados de países:** Natural Earth (geometrias), códigos ISO 3166, dados abertos de bandeiras.
- **Notícias:** feeds RSS e APIs de agregação de eventos (ex.: GDELT). **Avaliar licenciamento antes de usar.**

**Indicadores-chave do MVP (lista inicial, ajustável):** PIB, crescimento do PIB, PIB per capita, inflação, desemprego, dívida pública/PIB, balança comercial, população, taxa de juros (quando disponível), IDH ou equivalente.

### Modelo de dados (rascunho)
- `paises` (iso2, iso3, nome_pt, nome_en, regiao, geometria_ref)
- `indicadores` (codigo, nome_pt, unidade, categoria, fonte)
- `series` (pais_iso3, indicador_codigo, periodo, valor, fonte, coletado_em, atualizado_na_fonte_em)
- `fontes_dados` (id, nome, url, licenca, frequencia)
- `noticias` (id, titulo, url_original, veiculo, publicado_em, resumo_ia, rotulo_ia, status_revisao)
- `noticia_pais`, `noticia_tema`
- `analises` (noticia_id, fato, interpretacao, impacto, fontes_citadas)

## 5. Pipeline de dados e qualidade

- Cada fonte tem um módulo em `ingest/sources/` com: download, validação, normalização e carga.
- **Idempotente:** rodar duas vezes não duplica dados.
- **Validação:** checar faixas plausíveis, unidades e períodos; registrar anomalias em `docs/qualidade-dados.md`.
- **Defasagem visível:** o último período disponível por país/indicador aparece na interface (muitas séries têm atraso de meses ou anos).
- **Falha segura:** se uma fonte cair, o site continua servindo o último dado válido, com a data real.

## 6. Notícias e IA (parte de maior risco)

**Fluxo**
1. Coletar manchetes e metadados via feeds/APIs permitidos.
2. Deduplicar e agrupar por evento.
3. Classificar por país e tema (economia, política, geopolítica).
4. Gerar estrutura **fato / interpretação / impacto** com IA, **citando as fontes**.
5. Publicar com rótulo "Resumo gerado por IA" e link para o original.

**Regras**
- **Direitos autorais:** exibir título, resumo curto próprio e link com atribuição. **Não republicar texto integral** de terceiros.
- **Anti-alucinação:** o modelo só pode usar o conteúdo fornecido. Saída estruturada com campo de fontes obrigatório; se faltar base, o campo fica vazio, nunca preenchido por suposição.
- **Revisão:** no MVP, painel simples de revisão (aprovar/rejeitar) antes de publicar. Automatizar só depois de medir a taxa de erro.
- **Interpretação** deve ser claramente distinta de fato e marcada como análise, não como informação apurada.
- Registrar custo por chamada e limite mensal de gasto com IA.

## 7. Fases de desenvolvimento

Cada fase termina com um resumo e **espera o meu OK**. As letras A a E referem-se às fases do `PLANO-DESIGN.md`.

### Fase 0: Fundação
- [ ] Criar repositório, Next.js + TypeScript, lint, formatação, testes e CI básico.
- [ ] Criar `CLAUDE.md` com um resumo das regras deste plano.
- [ ] **Design Fase A:** tokens, fontes, grid e página `/design`.
- [ ] `docs/decisoes.md` iniciado.

**Pronto quando:** projeto roda localmente e `/design` mostra tokens e tipografia corretos.

### Fase 1: Dados de países
- [ ] Levantar e documentar as fontes em `docs/fontes.md` (formato, frequência, licença).
- [ ] Banco e migrações; carga de países, geometrias e metadados.
- [ ] Ingestão dos indicadores-chave para o conjunto piloto.
- [ ] Relatório de qualidade e cobertura em `docs/qualidade-dados.md`.

**Pronto quando:** consulta retorna séries com fonte e data para todos os países do piloto. Se a cobertura for fraca, **parar e me avisar**.

### Fase 2: Globo e página de país
- [ ] **Design Fases B e C** (componentes, grafismo, tema de gráficos, mapa).
- [ ] Testar globo (MapLibre vs globe.gl) em desempenho e acessibilidade e registrar a decisão.
- [ ] Globo com seleção de país e alternativa em mapa plano.
- [ ] Página de país: cabeçalho, abas Economia / Política / Geopolítica, indicadores com séries históricas, fonte e data.

**Pronto quando:** abrir qualquer país do piloto mostra dados reais, legíveis e com fonte.

### Fase 3: Notícias
- [ ] Levantar fontes de notícia e licenciamento (documentar).
- [ ] Ingestão, deduplicação e classificação por país/tema.
- [ ] Geração fato/interpretação/impacto com saída estruturada e fontes obrigatórias.
- [ ] Painel de revisão e rótulo de IA.
- [ ] Medir e registrar taxa de erro numa amostra revisada manualmente.

**Pronto quando:** notícias aparecem nas páginas de país com link original, rótulo e estrutura clara, e a taxa de erro da amostra está documentada.

### Fase 4: Home, comparador e metodologia
- [ ] **Design Fase D:** home editorial, notícia, comparador, metodologia.
- [ ] Comparador de 2 a 4 países com escalas consistentes.
- [ ] Busca de países e notícias.
- [ ] Página de metodologia e fontes alimentada por `fontes_dados`.

### Fase 5: Qualidade e lançamento
- [ ] **Design Fase E:** acessibilidade, daltonismo, revisão contra "o que evitar".
- [ ] SEO (metadados, sitemap, dados estruturados), desempenho (LCP < 2,5s, CLS < 0,1).
- [ ] Monitoramento de jobs, alertas de falha e analytics com respeito à LGPD.
- [ ] Deploy e domínio.

### Fase 6: Pós-MVP (só quando eu pedir)
Contas e alertas, newsletter, mais idiomas, expansão de países, API, monetização.

## 8. Riscos e como tratar

| Risco | Tratamento |
|---|---|
| **Defasagem e lacunas nos dados** | Mostrar período real, estado vazio honesto, relatório de cobertura |
| **Licenciamento de notícias** | Só título + resumo próprio + link; documentar termos de cada fonte |
| **Alucinação da IA** | Saída estruturada, fontes obrigatórias, revisão humana, medir erro |
| **Custo de IA** | Limite mensal, cache, processar só o necessário |
| **Desempenho do globo** | Teste na Fase 2, alternativa em mapa plano, carga sob demanda |
| **Escopo crescendo** | MVP fechado na seção 2; extras só na Fase 6 |
| **Neutralidade geopolítica** | Linguagem descritiva, fontes variadas, separação fato/interpretação; fronteiras e nomes disputados documentados em `docs/decisoes.md` |

## 9. Regras de trabalho para o Claude Code

1. **Uma fase por vez.** Resumir ao final e esperar meu OK.
2. **Perguntar antes** de decisões grandes (stack, fontes, modelo de IA, escopo).
3. **Nunca inventar dados, endpoints, números ou fontes.** Dados de exemplo só se marcados como fictícios.
4. **Pesquisar a documentação oficial** de cada fonte e API antes de integrar.
5. **Testes** para validação de dados, ingestão e regras de negócio.
6. **Commits pequenos** em português; decisões relevantes em `docs/decisoes.md`.
7. **Segredos** só em variáveis de ambiente; incluir `.env.example`.
8. **Simplicidade primeiro:** sem microserviços ou infraestrutura complexa antes de haver usuários.
9. Usar **somente os tokens** do `PLANO-DESIGN.md` no visual.

## 10. Primeira instrução para o Claude Code

> Leia o `PLANO-ROTZX.md` e o `PLANO-DESIGN.md`. Comece pela **Fase 0**. Antes de escrever código, me mostre um resumo do que entendeu do produto e liste qualquer dúvida ou decisão que precise de mim. Depois configure o projeto e a Fase A do design, e me mostre a página `/design` antes de seguir para a Fase 1.
