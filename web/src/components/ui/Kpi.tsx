import { formatarData, formatarValor, formatarVariacao, sentidoVariacao } from "@/lib/formato";
import s from "./Kpi.module.css";

/**
 * Indicador (KPI): valor grande, variação com seta E sinal (+/−), período, fonte e data discretas.
 * A variação não usa cor de "bom/ruim": inflação subindo e PIB subindo têm sentidos opostos.
 */
export function Kpi({
  rotulo,
  valor,
  unidade,
  periodo,
  anterior,
  fonte,
  atualizadoEm,
  nota,
}: {
  rotulo: string;
  valor: number | null;
  unidade: string;
  periodo: number | null;
  anterior?: { periodo: number; valor: number } | null;
  fonte: string | null;
  atualizadoEm: string | null;
  nota?: string | null;
}) {
  if (valor === null || periodo === null) {
    return (
      <div className={s.kpi}>
        <p className={s.rotulo}>{rotulo}</p>
        <p className={s.vazio}>Ainda não temos dados desse indicador para este país.</p>
      </div>
    );
  }
  const f = formatarValor(valor, unidade);
  const delta = anterior ? valor - anterior.valor : null;
  const sentido = delta === null ? null : sentidoVariacao(delta, unidade);
  const seta = sentido === null ? null : sentido > 0 ? "▲" : sentido < 0 ? "▼" : "▬";
  return (
    <div className={s.kpi}>
      <p className={s.rotulo}>
        {rotulo} <span className={s.periodo}>· {periodo}</span>
      </p>
      <p className={s.valor}>
        <span className="num">{f.numero}</span>
        {f.unidade && <span className={s.unidade}>{f.unidade}</span>}
      </p>
      {delta !== null && anterior && (
        <p className={s.variacao}>
          <span aria-hidden="true">{seta}</span>{" "}
          <span className="num">{formatarVariacao(delta, unidade)}</span>{" "}
          <span className={s.suave}>em relação a {anterior.periodo}</span>
        </p>
      )}
      {nota && <p className={s.nota}>{nota}</p>}
      {fonte && (
        <p className={s.fonte}>
          Fonte: {fonte}
          {atualizadoEm ? `, atualizado em ${formatarData(atualizadoEm)}` : ""}.
        </p>
      )}
    </div>
  );
}
