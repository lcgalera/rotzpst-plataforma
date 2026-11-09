# Registro de decisões

Formato: data · decisão · motivo · como reverter. Decisões marcadas [DECISÃO PADRÃO] nos planos estão aplicadas, mas são fáceis de trocar.

## 2026-11-09 · Fase 0

- **Next.js 16 (App Router) + TypeScript, com pasta `web/src/`.** O PLANO-ROTZX mostra `web/app` e `web/styles`; o PLANO-DESIGN pede `web/src/styles/tokens.css`. Como caminho de estilo é assunto de design, segui o PLANO-DESIGN e coloquei tudo sob `src/` (`src/app`, `src/components`, `src/styles`).
- **Gerenciadores:** pnpm no `web/`, uv no `ingest/` (Python ≥ 3.12).
- **Qualidade:** ESLint (config do Next) + Prettier; Ruff (lint e formatação) no Python. Testes com Vitest e pytest. CI no GitHub Actions roda tudo em todo push/PR.
- **Fontes auto-hospedadas** em `web/public/fonts/` (WOFF2, só subset latino, que cobre o português). Arquivos tirados dos pacotes @fontsource; licença SIL OFL 1.1 copiada ao lado. Fraunces é variável (eixos peso e tamanho óptico). Preload só de Fraunces e Plex Sans 400 (máximo 2 famílias iniciais); Plex Mono carrega quando usada. `@font-face` escrito à mão (sem `next/font`) para manter os nomes de família exatamente como em `tokens.css`.
- **`tokens.css` é a fonte única.** A página `/design` e o relatório de contraste leem o arquivo e não copiam valores. Um teste falha se aparecer cor solta (hex, rgb, hsl) fora dele. Exceções aceitas a "nada de tamanho solto": breakpoints (`40rem` tablet e `64rem` desktop, porque CSS não aceita `var()` em media query), valores adimensionais (entrelinha, peso, tracking) e larguras de layout da página de catálogo.
- **Prettier normaliza os hex de `tokens.css` para minúsculas.** Os valores são idênticos aos do plano (o teste compara sem diferenciar maiúsculas).
- **Grid:** `.grade` com 4/6/12 colunas, calha `--e-6` (24px), margem externa `clamp(--e-4, 5vw, --e-24)`, largura máxima 90rem.
- **Relatório de contraste** gerado por script (`pnpm contraste`). O CI falha se o relatório ficar desatualizado, mas **não** falha por par reprovado: os reprovados ficam como pendência de decisão, porque trocar cor exige OK (PLANO-DESIGN 13.3).
- **Fronteiras e nomes disputados:** a definir na Fase 1 junto com a fonte de geometrias.

## 2026-11-09 · Ajustes de contraste (aprovados pelo dono)

- **Ocre saiu da paleta categórica de dados.** Como série sobre papel dava 1,97:1 (meta 3:1). A categórica passa a ter **5 cores**: `--d-1` azul profundo, `--d-2` laranja queimado, `--d-3` verde-água fosco, `--d-4` ameixa, `--d-5` cinza quente (antes `--d-6`, renumerado). `--cor-ocre` continua existindo como detalhe gráfico de marca. Para mais de 5 séries, agrupar em "outros" ou usar destaque seletivo. Desvio do PLANO-DESIGN §6 ("até 6 séries"). Reverter: devolver `--d-5: #D7A64B` e `--d-6: #6B6B63` em `tokens.css`.
- **Link sobre areia é combinação proibida.** `--link` sobre `--cor-areia` dá 4,22:1 (meta 4,5:1). A paleta não muda: blocos em areia não levam link. Se um bloco areia precisar de ação, usar texto `--texto` com sublinhado ou levar o link para fora do bloco. O par fica marcado como `proibido` em `pares-contraste.ts`.
- **CI de contraste ficou mais rígido:** agora falha se qualquer par permitido reprovar.
