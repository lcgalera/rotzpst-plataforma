import s from "./Bandeira.module.css";

/**
 * Bandeira pequena e informativa, ao lado do nome do país (nunca decoração dominante).
 * Quando o nome já está ao lado, é decorativa (alt vazio) para leitores de tela não repetirem.
 */
export function Bandeira({
  iso2,
  nome,
  tamanho = "p",
  decorativa = true,
}: {
  iso2: string;
  nome: string;
  tamanho?: "p" | "m";
  decorativa?: boolean;
}) {
  return (
    // eslint-disable-next-line @next/next/no-img-element -- SVG local e pequeno; next/image não acrescenta nada aqui
    <img
      src={`/flags/${iso2.toLowerCase()}.svg`}
      alt={decorativa ? "" : `Bandeira: ${nome}`}
      className={`${s.bandeira} ${s[tamanho]}`}
      width={tamanho === "m" ? 32 : 20}
      height={tamanho === "m" ? 24 : 15}
      loading="lazy"
    />
  );
}
