import type { Uso } from "./contraste";

/**
 * Pares frente/fundo usados (ou previstos) na interface.
 * Ao criar um componente com uma combinação nova, adicione o par aqui
 * e rode `pnpm contraste` para atualizar docs/contraste.md.
 */
/** `proibido`: combinação reprovada que a interface não usa (decisão registrada em docs/decisoes.md). */
export type Par = { frente: string; fundo: string; uso: Uso; onde: string; proibido?: true };

export const PARES: Par[] = [
  // Texto sobre papel
  { frente: "texto", fundo: "fundo", uso: "texto", onde: "Corpo de texto" },
  { frente: "texto-suave", fundo: "fundo", uso: "texto", onde: "Metadados, fonte e data" },
  { frente: "link", fundo: "fundo", uso: "texto", onde: "Links (azul-profundo)" },
  {
    frente: "cor-terracota",
    fundo: "fundo",
    uso: "texto-grande",
    onde: "Terracota de marca em título grande",
  },
  { frente: "cor-verde-mata", fundo: "fundo", uso: "texto", onde: "Texto em verde-mata" },
  { frente: "cor-azul-profundo", fundo: "fundo", uso: "texto", onde: "Texto em azul profundo" },

  // Texto sobre areia
  { frente: "texto", fundo: "cor-areia", uso: "texto", onde: "Texto sobre bloco areia" },
  { frente: "texto-suave", fundo: "cor-areia", uso: "texto", onde: "Metadados sobre bloco areia" },
  { frente: "link", fundo: "cor-areia", uso: "texto", onde: "Link sobre bloco areia" },

  // Invertidos (botão primário no hover, blocos estruturais)
  { frente: "cor-papel", fundo: "cor-grafite", uso: "texto", onde: "Botão primário / bloco invertido" },
  { frente: "cor-papel", fundo: "cor-verde-mata", uso: "texto", onde: "Texto sobre bloco verde-mata" },
  { frente: "cor-papel", fundo: "cor-azul-profundo", uso: "texto", onde: "Texto sobre bloco azul profundo" },
  { frente: "cor-papel", fundo: "cor-terracota", uso: "texto-grande", onde: "Texto grande sobre terracota" },

  // Elementos de interface (3:1)
  { frente: "foco", fundo: "fundo", uso: "interface", onde: "Anel de foco sobre papel" },
  { frente: "foco", fundo: "cor-areia", uso: "interface", onde: "Anel de foco sobre areia" },
  { frente: "cor-grafite", fundo: "fundo", uso: "interface", onde: "Contorno do botão secundário" },
  { frente: "cor-terracota", fundo: "fundo", uso: "interface", onde: "Sublinhado da aba ativa" },
  {
    frente: "cor-azul-profundo",
    fundo: "cor-areia",
    uso: "interface",
    onde: "País selecionado no globo (sobre oceano)",
  },

  // Decorativos (sem meta; registrados por transparência)
  {
    frente: "cor-linha",
    fundo: "fundo",
    uso: "decorativo",
    onde: "Divisórias finas (hierarquia vem do espaço)",
  },
  { frente: "cor-ocre", fundo: "fundo", uso: "decorativo", onde: "Ocre: só detalhe gráfico, nunca texto" },

  // Paleta de dados sobre papel (objetos gráficos: 3:1)
  { frente: "d-1", fundo: "fundo", uso: "interface", onde: "Série de dados 1" },
  { frente: "d-2", fundo: "fundo", uso: "interface", onde: "Série de dados 2" },
  { frente: "d-3", fundo: "fundo", uso: "interface", onde: "Série de dados 3" },
  { frente: "d-4", fundo: "fundo", uso: "interface", onde: "Série de dados 4" },
  { frente: "d-5", fundo: "fundo", uso: "interface", onde: "Série de dados 5" },
  { frente: "d-pos", fundo: "fundo", uso: "interface", onde: "Variação positiva" },
  { frente: "d-neg", fundo: "fundo", uso: "interface", onde: "Variação negativa" },
];
