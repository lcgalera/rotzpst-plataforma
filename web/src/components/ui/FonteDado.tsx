import { formatarData } from "@/lib/formato";
import s from "./FonteDado.module.css";

/** "Fonte: FMI, atualizado em 03/11/2026." Sempre abaixo do dado, discreta, com link para a origem. */
export function FonteDado({
  sigla,
  url,
  atualizadoEm,
  extra,
}: {
  sigla: string;
  url?: string;
  atualizadoEm?: string | null;
  extra?: string | null;
}) {
  return (
    <p className={s.fonte}>
      Fonte: {url ? <a href={url}>{sigla}</a> : sigla}
      {atualizadoEm ? `, atualizado em ${formatarData(atualizadoEm)}` : ""}.{extra ? ` ${extra}` : ""}
    </p>
  );
}
