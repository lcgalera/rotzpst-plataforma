# Relatório de contraste

> Gerado automaticamente por `web/scripts/contraste.ts` a partir de `web/src/styles/tokens.css`.
> **Não editar à mão.** Rode `pnpm contraste` dentro de `web/` para atualizar.

Metas (PLANO-DESIGN.md, seção 2): **4,50:1** para texto normal; **3,00:1** para texto grande (≥ 24px, ou ≥ 18,66px em negrito) e elementos de interface/gráficos. Pares decorativos são listados só por transparência.

| Frente | Fundo | Razão | Uso | Resultado | Onde |
|---|---|---:|---|---|---|
| `--texto` #252622 | `--fundo` #F5F1E8 | 13,51:1 | Texto normal (4,5:1) | ✅ passa | Corpo de texto |
| `--texto-suave` #55564F | `--fundo` #F5F1E8 | 6,58:1 | Texto normal (4,5:1) | ✅ passa | Metadados, fonte e data |
| `--link` #9C4A33 | `--fundo` #F5F1E8 | 5,41:1 | Texto normal (4,5:1) | ✅ passa | Links e texto pequeno em terracota |
| `--cor-terracota` #B96549 | `--fundo` #F5F1E8 | 3,71:1 | Texto grande (3:1) | ✅ passa | Terracota de marca em título grande |
| `--cor-verde-mata` #355C4B | `--fundo` #F5F1E8 | 6,69:1 | Texto normal (4,5:1) | ✅ passa | Texto em verde-mata |
| `--cor-azul-profundo` #294D68 | `--fundo` #F5F1E8 | 7,91:1 | Texto normal (4,5:1) | ✅ passa | Texto em azul profundo |
| `--texto` #252622 | `--cor-areia` #DDD6C9 | 10,54:1 | Texto normal (4,5:1) | ✅ passa | Texto sobre bloco areia |
| `--texto-suave` #55564F | `--cor-areia` #DDD6C9 | 5,14:1 | Texto normal (4,5:1) | ✅ passa | Metadados sobre bloco areia |
| `--link` #9C4A33 | `--cor-areia` #DDD6C9 | 4,22:1 | Texto normal (4,5:1) | 🚫 proibido | Link sobre bloco areia |
| `--cor-papel` #F5F1E8 | `--cor-grafite` #252622 | 13,51:1 | Texto normal (4,5:1) | ✅ passa | Botão primário / bloco invertido |
| `--cor-papel` #F5F1E8 | `--cor-verde-mata` #355C4B | 6,69:1 | Texto normal (4,5:1) | ✅ passa | Texto sobre bloco verde-mata |
| `--cor-papel` #F5F1E8 | `--cor-azul-profundo` #294D68 | 7,91:1 | Texto normal (4,5:1) | ✅ passa | Texto sobre bloco azul profundo |
| `--cor-papel` #F5F1E8 | `--cor-terracota` #B96549 | 3,71:1 | Texto grande (3:1) | ✅ passa | Texto grande sobre terracota |
| `--foco` #294D68 | `--fundo` #F5F1E8 | 7,91:1 | Interface/gráfico (3:1) | ✅ passa | Anel de foco sobre papel |
| `--foco` #294D68 | `--cor-areia` #DDD6C9 | 6,17:1 | Interface/gráfico (3:1) | ✅ passa | Anel de foco sobre areia |
| `--cor-grafite` #252622 | `--fundo` #F5F1E8 | 13,51:1 | Interface/gráfico (3:1) | ✅ passa | Contorno do botão secundário |
| `--cor-terracota` #B96549 | `--fundo` #F5F1E8 | 3,71:1 | Interface/gráfico (3:1) | ✅ passa | Sublinhado da aba ativa |
| `--cor-azul-profundo` #294D68 | `--cor-areia` #DDD6C9 | 6,17:1 | Interface/gráfico (3:1) | ✅ passa | País selecionado no globo (sobre oceano) |
| `--cor-linha` #D0C9BB | `--fundo` #F5F1E8 | 1,46:1 | Decorativo (sem meta) | — | Divisórias finas (hierarquia vem do espaço) |
| `--cor-ocre` #D7A64B | `--fundo` #F5F1E8 | 1,97:1 | Decorativo (sem meta) | — | Ocre: só detalhe gráfico, nunca texto |
| `--d-1` #294D68 | `--fundo` #F5F1E8 | 7,91:1 | Interface/gráfico (3:1) | ✅ passa | Série de dados 1 |
| `--d-2` #C8742A | `--fundo` #F5F1E8 | 3,11:1 | Interface/gráfico (3:1) | ✅ passa | Série de dados 2 |
| `--d-3` #5E8C7B | `--fundo` #F5F1E8 | 3,38:1 | Interface/gráfico (3:1) | ✅ passa | Série de dados 3 |
| `--d-4` #8A5A8C | `--fundo` #F5F1E8 | 4,75:1 | Interface/gráfico (3:1) | ✅ passa | Série de dados 4 |
| `--d-5` #6B6B63 | `--fundo` #F5F1E8 | 4,77:1 | Interface/gráfico (3:1) | ✅ passa | Série de dados 5 |
| `--d-pos` #2F6F8F | `--fundo` #F5F1E8 | 4,91:1 | Interface/gráfico (3:1) | ✅ passa | Variação positiva |
| `--d-neg` #B4492E | `--fundo` #F5F1E8 | 4,74:1 | Interface/gráfico (3:1) | ✅ passa | Variação negativa |

## Resumo

- Pares permitidos avaliados com meta: 24
- Reprovados: 0

## Combinações proibidas

Reprovam na meta e **não podem ser usadas** na interface (ver `docs/decisoes.md`).

- `--link` sobre `--cor-areia` (4,22:1): Link sobre bloco areia
