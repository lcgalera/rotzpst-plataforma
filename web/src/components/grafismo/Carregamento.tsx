import { BRASIL_CENTROIDE, BRASIL_PATH, BRASIL_VIEWBOX } from "./brasil.gerado";
import s from "./Carregamento.module.css";

/**
 * Carregamento: silhueta do Brasil em traço fino + coordenadas do centroide.
 * Usado como fallback de <Suspense>: nunca cobre nem bloqueia conteúdo já pronto.
 * Duração máxima ~1,2s; com prefers-reduced-motion o traço aparece já completo.
 * A frase "Pátria amada, Brasil." só aparece com `frase` (o servidor passa FEATURE_FRASE_CARREGAMENTO=true;
 * desligada por padrão). Ver `fraseCarregamentoLigada()`.
 */
export function Carregamento({ rotulo = "Carregando", frase = false }: { rotulo?: string; frase?: boolean }) {
  return (
    <div className={s.carregamento} role="status" aria-live="polite">
      <svg viewBox={BRASIL_VIEWBOX} className={s.silhueta} aria-hidden="true" focusable="false">
        <path d={BRASIL_PATH} pathLength={1} className={s.traco} />
      </svg>
      <p className={s.coordenadas}>{BRASIL_CENTROIDE}</p>
      {frase && <p className={s.frase}>Pátria amada, Brasil.</p>}
      <span className="visualmente-oculto">{rotulo}…</span>
    </div>
  );
}

/** Lê a feature flag no servidor (variáveis sem NEXT_PUBLIC_ não chegam ao cliente). */
export function fraseCarregamentoLigada(): boolean {
  return process.env.FEATURE_FRASE_CARREGAMENTO === "true";
}
