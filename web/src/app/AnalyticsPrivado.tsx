"use client";

import { Analytics } from "@vercel/analytics/next";

/**
 * Vercel Web Analytics (sem cookies; dados de sessão descartados em 24 h, segundo a Vercel).
 * Por privacidade: o painel interno não é medido e o texto digitado na busca nunca sai do navegador.
 */
export function AnalyticsPrivado() {
  return (
    <Analytics
      beforeSend={(evento) => {
        const url = new URL(evento.url);
        if (url.pathname.startsWith("/revisao")) return null;
        url.search = "";
        return { ...evento, url: url.toString() };
      }}
    />
  );
}
