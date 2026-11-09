# PLANO-DESIGN.md: rotzx (Modernismo Editorial Brasileiro)

> Instruções para o Claude Code. Este arquivo refina o briefing de design original e o transforma em decisões fechadas, tokens e fases de implementação. Siga a ordem. Quando algo estiver marcado como **[DECISÃO PADRÃO]**, aplique sem perguntar, mas deixe fácil de trocar.

**Conceito:** "Uma inteligência global com alma brasileira."
**Síntese:** Menos Vale do Silício. Mais modernismo brasileiro. A mesma sofisticação, com outra alma.
**Regra de ouro:** brasileiro por construção, não por ornamentação.

---

## 1. Decisões fechadas (resolvem as tensões do briefing)

| Tema | Decisão |
|---|---|
| **Globo vs editorial** [DECISÃO PADRÃO] | A home é **editorial primeiro**: manchete e resumo do cenário global lideram a hierarquia. O globo ocupa um bloco grande e fixo ao lado/abaixo, como principal ferramenta de exploração, sem efeitos futuristas. Em mobile, o editorial vem antes e o globo abre em tela cheia sob demanda. |
| **Frase "Pátria amada, Brasil."** [DECISÃO PADRÃO] | Fica como **opção configurável** (`FEATURE_FRASE_CARREGAMENTO`), desligada por padrão. Padrão no carregamento: silhueta do Brasil + coordenadas em tipografia pequena (ex.: `14°14′S 51°55′W`). Dá o toque cartográfico sem leitura oficial. |
| **Cor em texto** | Terracota de marca (`#B96549`) só em elementos grandes e decorativos. Para **texto pequeno e links**, usar `--cor-terracota-texto`, mais escura, que passa em contraste AA. Amarelo-ocre **nunca** como cor de texto. |
| **Cores de gráfico** | Paleta própria de dados, separada da paleta de marca, segura para daltonismo (seção 6). Nunca depender só de cor: usar também rótulo, forma ou textura. |
| **Fontes** | Serifada: **Fraunces** (títulos). Sem serifa: **IBM Plex Sans** (corpo, UI, tabelas). Mono opcional para dados: **IBM Plex Mono**. Todas livres, auto-hospedadas via `@font-face` com `font-display: swap`. |

---

## 2. Design tokens (CSS)

Criar `web/src/styles/tokens.css` e usar **somente** variáveis nos componentes.

```css
:root {
  /* Neutros (≈75% da interface) */
  --cor-papel: #F5F1E8;
  --cor-areia: #DDD6C9;
  --cor-grafite: #252622;
  --cor-grafite-suave: #55564F;   /* textos secundários, validar contraste */
  --cor-linha: #D0C9BB;           /* divisórias finas */

  /* Estruturais (≈20%) */
  --cor-verde-mata: #355C4B;
  --cor-azul-profundo: #294D68;

  /* Destaque (≈5%) */
  --cor-terracota: #B96549;        /* grandes elementos e detalhes */
  --cor-terracota-texto: #9C4A33;  /* texto pequeno e links sobre papel */
  --cor-ocre: #D7A64B;             /* só detalhe gráfico, nunca texto */

  /* Semântico */
  --fundo: var(--cor-papel);
  --texto: var(--cor-grafite);
  --texto-suave: var(--cor-grafite-suave);
  --link: var(--cor-terracota-texto);
  --foco: var(--cor-azul-profundo);

  /* Tipografia */
  --fonte-titulo: "Fraunces", Georgia, serif;
  --fonte-corpo: "IBM Plex Sans", system-ui, sans-serif;
  --fonte-dados: "IBM Plex Mono", ui-monospace, monospace;

  /* Escala tipográfica (fluida) */
  --t-xs: clamp(0.75rem, 0.73rem + 0.1vw, 0.8125rem);
  --t-sm: 0.875rem;
  --t-base: 1rem;
  --t-lg: 1.25rem;
  --t-xl: clamp(1.5rem, 1.3rem + 1vw, 2rem);
  --t-2xl: clamp(2rem, 1.6rem + 2vw, 3rem);
  --t-display: clamp(3rem, 2rem + 5vw, 6.5rem);

  /* Espaçamento (base 4px) */
  --e-1: 0.25rem; --e-2: 0.5rem; --e-3: 0.75rem; --e-4: 1rem;
  --e-6: 1.5rem; --e-8: 2rem; --e-12: 3rem; --e-16: 4rem; --e-24: 6rem;

  /* Forma */
  --raio: 2px;                    /* quase reto, linguagem editorial */
  --linha: 1px solid var(--cor-linha);

  /* Movimento */
  --mov-rapido: 150ms;
  --mov-medio: 300ms;
  --curva: cubic-bezier(0.2, 0.6, 0.2, 1);
}

@media (prefers-reduced-motion: reduce) {
  :root { --mov-rapido: 0ms; --mov-medio: 0ms; }
}
```

> Tarefa: rodar verificação de contraste automática para todos os pares texto/fundo usados e registrar em `docs/contraste.md`. Meta: **4,5:1** para texto normal, **3:1** para texto grande e elementos de interface.

---

## 3. Tipografia e composição

- **Títulos:** Fraunces, peso médio, tracking levemente negativo em tamanhos grandes, quebras de linha intencionais (`text-wrap: balance`).
- **Corpo:** IBM Plex Sans, 16–18px, entrelinha 1,55–1,65, medida máxima de **65–72 caracteres**.
- **Dados:** números tabulares (`font-variant-numeric: tabular-nums`), unidades em tamanho menor e cor suave, fonte e data sempre abaixo do valor.
- **Display:** palavras de forte presença gráfica permitidas em chamadas de seção (herança da poesia concreta), mas sempre com função informativa.
- **Proibido:** fontes decorativas "brasileiras", geométricas frias e ornamentos.

## 4. Layout e grid

- Grid de **12 colunas** no desktop, 6 no tablet, 4 no mobile; calhas de 24px; margens externas generosas.
- Composição **assimétrica controlada**: por exemplo, título em 7 colunas e metadados em 3, com 2 de respiro.
- Divisórias de 1px (`--linha`), sem sombras. Hierarquia por **espaço e tipografia**, não por caixas.
- **Módulos geométricos** (inspiração Athos Bulcão): pequeno conjunto de formas (círculo, semicírculo, quarto de círculo, retângulo) usado como marcador de seção e separador, em 1 a 2 cores por vez. Criar como componentes SVG reutilizáveis em `web/src/components/grafismo/`.
- Texturas: apenas ruído de papel muito sutil no fundo (opacidade ≤ 4%), desligável, nunca sob dados.

## 5. Componentes

Criar em `web/src/components/` com Storybook ou página de catálogo em `/design`:

- **Botão:** primário (grafite sobre papel, invertido no hover), secundário (contorno 1px), terciário (texto com sublinhado). Terracota só no foco/estado ativo específico.
- **Cartão:** plano, sem sombra, borda fina ou apenas divisória superior; título serifado, metadados em corpo pequeno.
- **Menu:** concisa, tipografia clara, estado ativo por sublinhado de 2px.
- **Ícones:** linha fina de 1,5px, geométricos, biblioteca única e consistente.
- **Tabela:** cabeçalho em caixa-baixa pequena, linhas finas, números alinhados à direita, ordenação acessível por teclado.
- **Indicador (KPI):** valor grande, variação com seta **e** sinal (+/−), fonte e data discretas.
- **Bandeira:** tamanho pequeno e informativo, ao lado do nome do país, nunca como decoração dominante.
- **Foco visível:** anel de 2px em `--foco` com offset, em todos os elementos interativos.

## 6. Visualização de dados

**Princípios:** eixos discretos, linhas finas, fundo neutro, rótulos diretos (preferir rotular a linha em vez de legenda), destaque seletivo e tipografia do sistema.

**Paleta de dados (separada da marca)** [DECISÃO PADRÃO, validar com simulador de daltonismo]:

```css
:root {
  /* Categórica (até 6 séries) */
  --d-1: #294D68; /* azul profundo */
  --d-2: #C8742A; /* laranja queimado */
  --d-3: #5E8C7B; /* verde-água fosco */
  --d-4: #8A5A8C; /* ameixa */
  --d-5: #D7A64B; /* ocre */
  --d-6: #6B6B63; /* cinza quente */

  /* Divergente (variação positiva/negativa) */
  --d-pos: #2F6F8F;
  --d-neg: #B4492E;
  --d-neutro: #DDD6C9;

  /* Sequencial (mapas coropléticos): areia → azul profundo */
  --d-seq-1: #EDE7DA; --d-seq-2: #C9D3D8; --d-seq-3: #8FAAB9;
  --d-seq-4: #55809A; --d-seq-5: #294D68;
}
```

- **Evitar** verde × vermelho como único contraste.
- **Mapas:** base em tons neutros, destaque cromático só para os países/regiões em foco, legenda clara, fonte e data dos dados.
- **Globo:** projeção limpa, sem brilho, atmosfera ou estrelas; rotação opcional e pausável; alternativa em mapa plano acessível.
- **Anotações:** destaques editoriais (uma frase curta apontando para o ponto importante do gráfico).

## 7. Movimento

- Transições de opacidade e pequenos deslocamentos (≤ 8px), 150–300ms, curva `--curva`.
- Carregamento: silhueta do Brasil desenhada em traço fino + coordenadas. Duração máxima ~1,2s e **nunca bloqueia o conteúdo**.
- Respeitar `prefers-reduced-motion` em tudo, inclusive rotação do globo.

## 8. Tom de voz (microcopy)

Clara, inteligente, curiosa, acessível, precisa. Português brasileiro direto, sem jargão corporativo. Exemplos:
- Estado vazio: "Ainda não temos dados desse indicador para este país."
- Erro: "Não conseguimos carregar agora. Tente de novo em instantes."
- Fonte: "Fonte: FMI, atualizado em 03/11/2026."

Notícias sempre separadas em **Fato**, **Interpretação** e **Impacto**.

## 9. Páginas do rotzx

1. **Home:** manchete editorial + resumo do cenário global + bloco do globo + 3 a 5 indicadores-chave.
2. **Globo/explorar:** globo em destaque com painel lateral discreto do país selecionado.
3. **País:** cabeçalho (nome + bandeira pequena), abas Economia / Política / Geopolítica, indicadores com séries históricas, notícias recentes, tendências.
4. **Notícia:** título expressivo, metadados discretos, blocos Fato/Interpretação/Impacto.
5. **Comparador:** 2 a 4 países lado a lado, mesma paleta e escalas.
6. **Metodologia e fontes:** transparência sobre origem e atualização dos dados.

## 10. Acessibilidade e desempenho (requisitos, não extras)

- Contraste WCAG AA, navegação completa por teclado, `aria-label` em controles do globo/mapa e alternativa textual/tabular para cada gráfico.
- Textos alternativos úteis; nada de informação só por cor.
- Fontes auto-hospedadas em WOFF2, subset latino, no máximo 2 famílias carregadas inicialmente.
- Meta: LCP < 2,5s em 4G, CLS < 0,1. Globo carregado sob demanda (lazy).

## 11. Fases de implementação

**Fase A: Fundação (design system)**
- [ ] Configurar projeto, fontes e `tokens.css`.
- [ ] Reset, tipografia base e grid.
- [ ] Página `/design` com catálogo de cores, tipos e espaçamentos.
- [ ] Relatório de contraste em `docs/contraste.md`.

**Fase B: Componentes e grafismo**
- [ ] Botão, cartão, menu, tabela, KPI, bandeira, foco.
- [ ] Biblioteca de módulos geométricos em SVG.
- [ ] Silhueta do Brasil e animação de carregamento (com `prefers-reduced-motion`).

**Fase C: Dados e mapas**
- [ ] Tema de gráficos (linha, barra, área) com a paleta de dados.
- [ ] Mapa coroplético e estilo de mapa neutro.
- [ ] Globo interativo com alternativa acessível.

**Fase D: Páginas**
- [ ] Home, País, Notícia, Comparador, Metodologia.
- [ ] Revisão de microcopy e estados vazios/erro.

**Fase E: Polimento**
- [ ] Auditoria de acessibilidade e desempenho.
- [ ] Teste de daltonismo nos gráficos.
- [ ] Revisão final contra a seção "o que evitar".

## 12. O que evitar (checklist de revisão)

- [ ] Parece cópia da Anthropic ou startup de IA genérica?
- [ ] Virou dashboard sem personalidade ou portal poluído?
- [ ] Tem clichê (tucano, palmeira, futebol, Carnaval) ou símbolo oficial em excesso?
- [ ] Minimalismo extremo prejudicando usabilidade?
- [ ] Elementos modernistas sem função?
- [ ] Cor sozinha carregando significado?

## 13. Regras de trabalho para o Claude Code

1. **Uma fase por vez.** Ao concluir, resumir e esperar meu OK.
2. **Só variáveis dos tokens** nos componentes; nada de cores ou tamanhos soltos.
3. **Perguntar antes** de trocar fonte, paleta ou decisões da seção 1.
4. **Não inventar dados** nem fontes; usar dados de exemplo claramente marcados como fictícios.
5. **Commits pequenos** em português e registro das decisões em `docs/decisoes.md`.
6. **Primeira instrução:** leia este arquivo, comece pela Fase A e me mostre a página `/design` antes de seguir para a Fase B.
