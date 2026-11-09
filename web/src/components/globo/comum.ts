"use client";

import { feature } from "topojson-client";
import type { GeometryCollection, Topology } from "topojson-specification";

/** Lê um token de cor do CSS (WebGL não entende var()). Mantém tokens.css como fonte única. */
export function token(nome: string): string {
  return getComputedStyle(document.documentElement).getPropertyValue(nome).trim();
}

export function prefereMenosMovimento(): boolean {
  return window.matchMedia("(prefers-reduced-motion: reduce)").matches;
}

/**
 * Anéis que cruzam o antimeridiano (Fiji, Rússia) saltam de +179° para −179° e viram uma faixa
 * atravessando o globo. Aqui as longitudes ficam contínuas dentro de cada anel (podem passar de 180°).
 */
export function desdobrarAnel(anel: number[][]): number[][] {
  const out: number[][] = [];
  let desloc = 0;
  for (let i = 0; i < anel.length; i++) {
    const [lng, lat] = anel[i];
    if (i > 0) {
      const dif = lng + desloc - out[i - 1][0];
      if (dif > 180) desloc -= 360;
      else if (dif < -180) desloc += 360;
    }
    out.push([lng + desloc, lat]);
  }
  return out;
}

function desdobrar(g: GeoJSON.Geometry): GeoJSON.Geometry {
  if (g.type === "Polygon") return { ...g, coordinates: g.coordinates.map(desdobrarAnel) };
  if (g.type === "MultiPolygon") return { ...g, coordinates: g.coordinates.map((p) => p.map(desdobrarAnel)) };
  return g;
}

export type PaisGlobo = { isoNum: string; iso3: string; nome: string; slug: string; piloto: boolean };

/** Baixa a geometria (Natural Earth 1:110m) e devolve GeoJSON com iso numérico no `id`. */
export async function carregarGeometria(): Promise<GeoJSON.FeatureCollection> {
  const resp = await fetch("/geo/countries-110m.json");
  const topo = (await resp.json()) as Topology<{ countries: GeometryCollection }>;
  const fc = feature(topo, topo.objects.countries) as GeoJSON.FeatureCollection;
  return {
    type: "FeatureCollection",
    features: fc.features
      .filter((f) => f.id !== "010")
      .map((f) => ({
        ...f,
        geometry: desdobrar(f.geometry),
        properties: { ...f.properties, iso: String(f.id ?? "") },
      })),
  };
}

export type PropsGlobo = {
  paises: PaisGlobo[];
  selecionado: string | null; // iso3
  onSelecionar: (iso3: string) => void;
  girando: boolean;
  onMedicao?: (m: { primeiroQuadroMs: number }) => void;
};
