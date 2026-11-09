"use client";

import ReactDOM from "react-dom";

/** Preload só das 2 famílias iniciais (Fraunces + Plex Sans regular), como pede o PLANO-DESIGN §10. */
const FONTES_INICIAIS = ["/fonts/fraunces-latin-var.woff2", "/fonts/ibm-plex-sans-latin-400-normal.woff2"];

export function PreloadFontes() {
  for (const href of FONTES_INICIAIS) {
    ReactDOM.preload(href, { as: "font", type: "font/woff2", crossOrigin: "anonymous" });
  }
  return null;
}
