import "server-only";

import { geoEqualEarth, geoPath } from "d3-geo";
import { feature } from "topojson-client";
import type { GeometryCollection, Topology } from "topojson-specification";
import topo110 from "../../../public/geo/countries-110m.json";

export const LARGURA = 960;
export const ALTURA = 470;
/** Antártida fica fora do mapa plano: ocupa espaço e não tem dados no piloto. */
const EXCLUIR = new Set(["010"]);

export type Forma = { id: string | null; nome: string; d: string };

let cache: Forma[] | null = null;

/** Caminhos SVG de cada país (Natural Earth 1:110m, Equal Earth). Calculado uma vez por processo. */
export function formasDoMundo(): Forma[] {
  if (cache) return cache;
  const t = topo110 as unknown as Topology<{ countries: GeometryCollection<{ name: string }> }>;
  const fc = feature(t, t.objects.countries) as GeoJSON.FeatureCollection<GeoJSON.Geometry, { name: string }>;
  const feicoes = fc.features.filter((f) => !EXCLUIR.has(String(f.id)));
  const proj = geoEqualEarth().fitSize([LARGURA, ALTURA], { type: "FeatureCollection", features: feicoes });
  const caminho = geoPath(proj);
  cache = feicoes.map((f) => ({
    id: typeof f.id === "string" && /^\d{3}$/.test(f.id) ? f.id : null,
    nome: f.properties.name,
    d: (caminho(f) ?? "").replace(/(\.\d)\d+/g, "$1"),
  }));
  return cache;
}
