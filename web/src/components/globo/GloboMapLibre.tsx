"use client";

import "maplibre-gl/dist/maplibre-gl.css";
import * as maplibregl from "maplibre-gl";
import { useEffect, useRef } from "react";
import { carregarGeometria, type PropsGlobo, token } from "./comum";
import s from "./Globo.module.css";

// O worker do MapLibre 6 é um módulo separado; servido como arquivo estático fixado na versão (pnpm vendor).
maplibregl.setWorkerUrl("/vendor/maplibre-gl-worker-6.17.0.mjs");

export default function GloboMapLibre({ paises, selecionado, onSelecionar, girando, onMedicao }: PropsGlobo) {
  const ref = useRef<HTMLDivElement>(null);
  const mapa = useRef<maplibregl.Map | null>(null);
  const porNum = useRef(new Map(paises.map((p) => [p.isoNum, p])));
  const girandoRef = useRef(girando);
  useEffect(() => {
    girandoRef.current = girando;
  }, [girando]);

  useEffect(() => {
    const t0 = performance.now();
    const m = new maplibregl.Map({
      container: ref.current!,
      style: {
        version: 8,
        projection: { type: "globe" },
        sky: { "atmosphere-blend": 0 }, // sem brilho/atmosfera
        sources: {},
        layers: [{ id: "oceano", type: "background", paint: { "background-color": token("--cor-areia") } }],
      },
      center: [-50, -12],
      // Globo ocupa ~85% do contêiner: diâmetro ≈ 512·2^z/π px.
      zoom: Math.log2((0.85 * Math.min(ref.current!.clientWidth, ref.current!.clientHeight) * Math.PI) / 512),
      attributionControl: false,
      renderWorldCopies: false,
    });
    mapa.current = m;
    m.keyboard.enable();

    m.on("load", async () => {
      const geo = await carregarGeometria();
      const piloto = paises.filter((p) => p.piloto).map((p) => p.isoNum);
      m.addSource("paises", { type: "geojson", data: geo, promoteId: "iso" });
      m.addLayer({
        id: "paises-preench",
        type: "fill",
        source: "paises",
        paint: {
          "fill-color": [
            "case",
            ["boolean", ["feature-state", "selecionado"], false],
            token("--cor-azul-profundo"),
            ["in", ["get", "iso"], ["literal", piloto]],
            token("--d-seq-2"),
            token("--cor-papel"),
          ],
        },
      });
      m.addLayer({
        id: "paises-borda",
        type: "line",
        source: "paises",
        paint: { "line-color": token("--cor-linha"), "line-width": 0.6 },
      });
      m.once("idle", () => onMedicao?.({ primeiroQuadroMs: performance.now() - t0 }));

      m.on("click", "paises-preench", (e) => {
        const iso = String(e.features?.[0]?.properties?.iso ?? "");
        const p = porNum.current.get(iso);
        if (p) onSelecionar(p.iso3);
      });
      m.on("mouseenter", "paises-preench", () => (m.getCanvas().style.cursor = "pointer"));
      m.on("mouseleave", "paises-preench", () => (m.getCanvas().style.cursor = ""));
    });

    // Rotação lenta, pausável; para enquanto o usuário interage.
    let raf = 0;
    let ultimo = performance.now();
    const girar = (agora: number) => {
      const dt = agora - ultimo;
      ultimo = agora;
      if (girandoRef.current && !m.isMoving()) {
        const c = m.getCenter();
        m.setCenter([c.lng + dt * 0.004, c.lat]);
      }
      raf = requestAnimationFrame(girar);
    };
    raf = requestAnimationFrame(girar);

    return () => {
      cancelAnimationFrame(raf);
      m.remove();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps -- o mapa é criado uma vez
  }, []);

  // Selecionado: feature-state + voo até o país
  useEffect(() => {
    const m = mapa.current;
    if (!m) return;
    const aplicar = () => {
      if (!m.getSource("paises")) return;
      m.removeFeatureState({ source: "paises" });
      const p = paises.find((x) => x.iso3 === selecionado);
      if (!p) return;
      m.setFeatureState({ source: "paises", id: p.isoNum }, { selecionado: true });
      const f = m.querySourceFeatures("paises", { filter: ["==", ["get", "iso"], p.isoNum] })[0];
      if (f) {
        const b = new maplibregl.LngLatBounds();
        const coords = (
          f.geometry.type === "Polygon"
            ? [f.geometry.coordinates]
            : f.geometry.type === "MultiPolygon"
              ? f.geometry.coordinates
              : []
        ) as number[][][][];
        coords.flat(2).forEach((c) => b.extend(c as [number, number]));
        m.easeTo({
          center: b.getCenter(),
          duration: matchMedia("(prefers-reduced-motion: reduce)").matches ? 0 : 800,
        });
      }
    };
    if (m.isStyleLoaded() && m.getSource("paises")) aplicar();
    else m.once("idle", aplicar);
  }, [selecionado, paises]);

  return (
    <div
      ref={ref}
      className={s.globo}
      role="application"
      aria-roledescription="globo interativo"
      aria-label="Globo. Use as setas para girar e + ou − para aproximar. Para escolher um país pelo teclado, use a lista ao lado."
    />
  );
}
