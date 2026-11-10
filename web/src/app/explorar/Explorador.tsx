"use client";

import Link from "next/link";
import { lazy, type ReactNode, Suspense, useState, useSyncExternalStore } from "react";
import type { PaisGlobo } from "@/components/globo/comum";
import { Carregamento } from "@/components/grafismo/Carregamento";
import { Bandeira } from "@/components/ui/Bandeira";
import { Botao } from "@/components/ui/Botao";
import { formatarData } from "@/lib/formato";
import s from "./Explorador.module.css";

// Só é importado no cliente, depois de montar: o servidor nunca carrega o MapLibre.
const GloboMapLibre = lazy(() => import("@/components/globo/GloboMapLibre"));

export type PaisExplorar = PaisGlobo & { iso2: string; regiao: string | null };
export type LinhaResumo = { rotulo: string; texto: string; periodo: number };
export type Resumo = Record<string, LinhaResumo[]>;

export function Explorador({
  paises,
  resumo,
  fonte,
  mapaPlano,
  frase,
}: {
  paises: PaisExplorar[];
  resumo: Resumo;
  fonte: { sigla: string; atualizadoEm: string | null };
  mapaPlano: ReactNode;
  frase: boolean;
}) {
  const [vista, setVista] = useState<"globo" | "plano">("globo");
  const [sel, setSel] = useState<string | null>(null);
  const [girando, setGirando] = useState(false);
  // true só no cliente (no servidor e na hidratação, false): o MapLibre nunca roda no servidor.
  const montado = useSyncExternalStore(
    () => () => {},
    () => true,
    () => false,
  );

  const pais = paises.find((p) => p.iso3 === sel) ?? null;
  const piloto = paises.filter((p) => p.piloto);
  const outros = paises.filter((p) => !p.piloto);

  return (
    <div className={`grade ${s.explorador}`}>
      <div className={`col-8 ${s.palco}`}>
        <div className={s.controles} role="group" aria-label="Forma de visualização">
          <Botao
            variante={vista === "globo" ? "primario" : "secundario"}
            aria-pressed={vista === "globo"}
            onClick={() => setVista("globo")}
          >
            Globo
          </Botao>
          <Botao
            variante={vista === "plano" ? "primario" : "secundario"}
            aria-pressed={vista === "plano"}
            onClick={() => setVista("plano")}
          >
            Mapa plano
          </Botao>
          {vista === "globo" && (
            <Botao variante="terciario" aria-pressed={girando} onClick={() => setGirando((g) => !g)}>
              {girando ? "Parar rotação" : "Girar o globo"}
            </Botao>
          )}
        </div>

        {vista === "globo" ? (
          // A caixa tem o mesmo tamanho do globo desde o início: nada "pula" quando ele chega (CLS).
          <div className={s.caixaGlobo}>
            <Suspense fallback={<Carregamento rotulo="Carregando o globo" frase={frase} />}>
              {montado ? (
                <GloboMapLibre paises={paises} selecionado={sel} onSelecionar={setSel} girando={girando} />
              ) : (
                <Carregamento rotulo="Carregando o globo" frase={frase} />
              )}
            </Suspense>
          </div>
        ) : (
          mapaPlano
        )}
      </div>

      <aside className={`col-4 ${s.painel}`} aria-labelledby="painel-titulo">
        <label className={s.rotuloSelect} htmlFor="escolher-pais">
          Escolher país
        </label>
        <select
          id="escolher-pais"
          className={s.select}
          value={sel ?? ""}
          onChange={(e) => setSel(e.target.value || null)}
        >
          <option value="">Selecione…</option>
          <optgroup label="Com dados completos">
            {piloto.map((p) => (
              <option key={p.iso3} value={p.iso3}>
                {p.nome}
              </option>
            ))}
          </optgroup>
          <optgroup label="Demais países">
            {outros.map((p) => (
              <option key={p.iso3} value={p.iso3}>
                {p.nome}
              </option>
            ))}
          </optgroup>
        </select>

        <div aria-live="polite" className={s.detalhe}>
          {pais ? (
            <>
              <h2 id="painel-titulo" className={s.nome}>
                <Bandeira iso2={pais.iso2} nome={pais.nome} /> {pais.nome}
              </h2>
              {pais.regiao && <p className="rotulo">{pais.regiao}</p>}
              {resumo[pais.iso3]?.length ? (
                <>
                  <dl className={s.lista}>
                    {resumo[pais.iso3].map((l) => (
                      <div key={l.rotulo}>
                        <dt>
                          {l.rotulo} <span className={s.periodo}>· {l.periodo}</span>
                        </dt>
                        <dd className="num">{l.texto}</dd>
                      </div>
                    ))}
                  </dl>
                  <p className={s.fonte}>
                    Fonte: {fonte.sigla}
                    {fonte.atualizadoEm ? `, atualizado em ${formatarData(fonte.atualizadoEm)}` : ""}.
                  </p>
                </>
              ) : (
                <p className={s.vazio}>Ainda não temos dados completos deste país.</p>
              )}
              <p className={s.abrir}>
                <Link href={`/pais/${pais.slug}`}>Ver o panorama completo</Link>
              </p>
            </>
          ) : (
            <>
              <h2 id="painel-titulo" className={s.nome}>
                Escolha um país
              </h2>
              <p className={s.vazio}>
                Clique no globo, use a lista acima ou mude para o mapa plano. Os {piloto.length} países em
                destaque têm indicadores completos.
              </p>
            </>
          )}
        </div>
      </aside>
    </div>
  );
}
