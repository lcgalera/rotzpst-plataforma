/**
 * Gera src/components/grafismo/brasil.gerado.ts: contorno do Brasil (Natural Earth 1:110m, domínio público)
 * em SVG e as coordenadas do centroide do polígono (d3.geoCentroid). Rode: pnpm silhueta
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { geoCentroid, geoMercator, geoPath } from "d3-geo";
import { feature } from "topojson-client";

const aqui = dirname(fileURLToPath(import.meta.url));
const topo = JSON.parse(readFileSync(resolve(aqui, "../../data/geo/countries-110m.json"), "utf8"));
const paises = feature(topo, topo.objects.countries) as unknown as GeoJSON.FeatureCollection;
const brasil = paises.features.find((f) => f.id === "076");
if (!brasil) throw new Error("Brasil (076) não encontrado na geometria.");

const L = 100;
const proj = geoMercator().fitSize([L, L], brasil);
const d = geoPath(proj.precision(0.2))(brasil)!.replace(/(\d+\.\d{1})\d+/g, "$1");
const [lon, lat] = geoCentroid(brasil);

function dms(v: number, pos: string, neg: string): string {
  const abs = Math.abs(v);
  const g = Math.floor(abs);
  const m = Math.round((abs - g) * 60);
  return `${g}°${String(m).padStart(2, "0")}′${v >= 0 ? pos : neg}`;
}

const saida = `// Gerado por scripts/silhueta-brasil.ts a partir de data/geo/countries-110m.json. Não editar à mão.
// Fonte: Natural Earth 1:110m (domínio público). Coordenadas = centroide do polígono (d3.geoCentroid).
export const BRASIL_VIEWBOX = "0 0 ${L} ${L}";
export const BRASIL_PATH = ${JSON.stringify(d)};
export const BRASIL_CENTROIDE = ${JSON.stringify(`${dms(lat, "N", "S")} ${dms(lon, "E", "W")}`)};
`;
writeFileSync(resolve(aqui, "../src/components/grafismo/brasil.gerado.ts"), saida);
console.log("Centroide:", lat.toFixed(3), lon.toFixed(3), "| path:", d.length, "caracteres");
