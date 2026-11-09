# CLAUDE.md: rotzx

Plataforma editorial de economia, geopolítica e inteligência global. Planos completos:
- `PLANO-ROTZX.md`: produto, dados, arquitetura e fases. **Vale em produto/dados/arquitetura.**
- `PLANO-DESIGN.md`: visual, tokens e componentes. **Vale em visual.**

## Regras inegociáveis
1. **Uma fase por vez.** Ao terminar, resumir e esperar o OK do dono. Nada de fase futura sem pedido.
2. **Perguntar antes** de decisões grandes: stack, fontes de dados, modelo de IA, escopo, e qualquer troca de fonte, paleta ou decisão da seção 1 do PLANO-DESIGN.
3. **Nunca inventar dados, endpoints, números ou fontes.** Dado ausente aparece como ausente. Exemplos só se marcados como fictícios.
4. **Todo dado mostra fonte e data** de atualização (e o período real a que se refere).
5. **Fato separado de interpretação.** Conteúdo de IA rotulado e sempre com link para as fontes originais. Nunca republicar texto integral de terceiros.
6. **Pesquisar a documentação oficial** de cada fonte/API antes de integrar e registrar em `docs/fontes.md` (formato, frequência, licença).
7. **Só tokens no visual:** cores, tamanhos, espaços e movimento vêm de `web/src/styles/tokens.css`. Um teste (`regra-tokens.test.ts`) barra cor solta.
8. **Commits pequenos em português.** Decisões relevantes em `docs/decisoes.md`.
9. **Segredos só em variáveis de ambiente**; manter `.env.example` atualizado.
10. **Simplicidade primeiro:** nada de microserviços ou infra complexa antes de haver usuários.
11. Português brasileiro primeiro (interface, docs, commits).

## Estrutura
- `web/`: Next.js (App Router, `src/`) + TypeScript. pnpm.
- `ingest/`: jobs Python (uv). `sources/` um módulo por fonte; `news/`; `jobs/`; `tests/`.
- `db/migrations/`, `data/raw/` (nunca editar à mão), `data/geo/`, `docs/`.

## Comandos
Web (dentro de `web/`):
- `pnpm dev`: servidor local (página do design system em `/design`)
- `pnpm lint` · `pnpm typecheck` · `pnpm test` · `pnpm format` · `pnpm build`
- `pnpm contraste`: regenera `docs/contraste.md` a partir dos tokens. Ao criar combinação nova de cor, adicione o par em `src/lib/pares-contraste.ts`.

Ingestão (dentro de `ingest/`):
- `uv sync` · `uv run pytest` · `uv run ruff check .` · `uv run ruff format .`

## Next.js 16
Esta versão tem mudanças em relação ao que modelos conhecem. Antes de usar uma API do Next, ler o guia em `web/node_modules/next/dist/docs/` (ver `web/AGENTS.md`).
