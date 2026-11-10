# Teste de daltonismo da paleta de dados

> Gerado por `web/scripts/daltonismo.ts` a partir de `tokens.css`. **Não editar à mão.**
> Simulação de Machado, Oliveira & Fernandes (2009), severidade máxima; diferença de cor CIE76 (ΔE) em Lab.
> Par com ΔE < 10 é marcado com ⚠️: difícil de separar só pela cor numa linha fina.

## Categórica (séries do comparador)

Além da cor: cada série também tem forma de marcador própria e rótulo direto.

| Par | normal | protanopia | deuteranopia | tritanopia |
|---|---:|---:|---:|---:|
| `--d-1` × `--d-2` | 82,7 | 70,9 | 80,5 | 78,5 |
| `--d-1` × `--d-3` | 36,7 | 33,9 | 33,4 | 23,3 |
| `--d-1` × `--d-4` | 35,2 | 12,2 | 16,2 | 44,1 |
| `--d-1` × `--d-5` | 27,8 | 25,7 | 29,7 | 26,5 |
| `--d-2` × `--d-3` | 67,5 | 43,4 | 51,6 | 72,7 |
| `--d-2` × `--d-4` | 73,1 | 74,4 | 72,8 | 36,6 |
| `--d-2` × `--d-5` | 57,4 | 46,1 | 51,4 | 52,8 |
| `--d-3` × `--d-4` | 54,4 | 33,1 | 21,7 | 42,3 |
| `--d-3` × `--d-5` | 20,4 | 11,3 | 8,9 ⚠️ | 23,6 |
| `--d-4` × `--d-5` | 38,5 | 28,5 | 22,3 | 20,1 |

## Divergente (positivo × negativo)

Além da cor: posição acima/abaixo do zero e sinal (+/−) no rótulo.

| Par | normal | protanopia | deuteranopia | tritanopia |
|---|---:|---:|---:|---:|
| `--d-pos` × `--d-neg` | 80,0 | 51,2 | 67,2 | 92,4 |

## Sequencial (mapa)

Além da cor: classes vizinhas; legenda com faixas de valor.

| Par | normal | protanopia | deuteranopia | tritanopia |
|---|---:|---:|---:|---:|
| `--d-seq-1` × `--d-seq-2` | 13,4 | 12,4 | 14,0 | 12,4 |
| `--d-seq-2` × `--d-seq-3` | 17,7 | 16,4 | 18,1 | 18,5 |
| `--d-seq-3` × `--d-seq-4` | 18,4 | 17,5 | 19,0 | 19,1 |
| `--d-seq-4` × `--d-seq-5` | 20,5 | 20,4 | 20,1 | 20,2 |

## Resumo

- ⚠️ `--d-3` × `--d-5` em deuteranopia (ΔE 8,9)
