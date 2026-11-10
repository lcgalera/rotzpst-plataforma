import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Privacidade",
  description: "O que o rotzx coleta de quem visita o site (quase nada) e por quê.",
};

export default function Privacidade() {
  return (
    <main className="container" style={{ paddingBlock: "var(--e-12)" }}>
      <p className="rotulo">Privacidade</p>
      <h1>O que coletamos de quem visita</h1>
      <div style={{ maxWidth: "68ch", display: "grid", gap: "var(--e-4)", marginTop: "var(--e-6)" }}>
        <p>
          O rotzx não tem cadastro, login, formulário de contato nem cookies de rastreamento. Não vendemos nem
          compartilhamos dados de visitantes.
        </p>
        <h2>Medição de audiência</h2>
        <p>
          Usamos o Vercel Web Analytics para contar visitas e páginas mais lidas. Segundo a Vercel, a
          ferramenta não usa cookies, guarda só dados anonimizados e descarta os dados de sessão em 24 horas,
          sem seguir a pessoa entre dias ou entre sites. O endereço das páginas é enviado sem os parâmetros: o
          que você digita na busca não sai do seu navegador.
        </p>
        <h2>Registros técnicos</h2>
        <p>
          A hospedagem (Vercel) mantém registros técnicos de acesso, como em qualquer site, para segurança e
          funcionamento. Não usamos esses registros para identificar visitantes.
        </p>
        <h2>Base legal</h2>
        <p>
          A medição agregada de audiência se apoia no legítimo interesse de entender quais conteúdos são úteis
          (LGPD, art. 7º, IX), com dados anonimizados. Para saber como os dados do site são produzidos, veja a{" "}
          <Link href="/metodologia">metodologia</Link>.
        </p>
      </div>
    </main>
  );
}
