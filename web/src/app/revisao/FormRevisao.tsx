"use client";

import { useActionState } from "react";
import { Botao } from "@/components/ui/Botao";
import { revisar, type EstadoRevisao } from "./acoes";
import s from "./revisao.module.css";

export function FormRevisao({
  analiseId,
  categorias,
}: {
  analiseId: number;
  categorias: Record<string, string>;
}) {
  const [estado, acao, enviando] = useActionState<EstadoRevisao, FormData>(revisar, null);
  return (
    <form action={acao} className={s.form}>
      <input type="hidden" name="analise_id" value={analiseId} />
      <fieldset>
        <legend>Erros encontrados (base da taxa de erro)</legend>
        <div className={s.erros}>
          {Object.entries(categorias).map(([k, rot]) => (
            <label key={k}>
              <input type="checkbox" name="erros" value={k} /> {rot}
            </label>
          ))}
        </div>
      </fieldset>
      <label className={s.nota}>
        Nota (opcional)
        <textarea name="nota" rows={2} />
      </label>
      {estado?.erro && (
        <p role="alert" className={s.alerta}>
          {estado.erro}
        </p>
      )}
      <div className={s.acoes}>
        <Botao type="submit" name="decisao" value="aprovada" disabled={enviando}>
          Aprovar e publicar
        </Botao>
        <Botao type="submit" name="decisao" value="rejeitada" variante="secundario" disabled={enviando}>
          Rejeitar
        </Botao>
      </div>
    </form>
  );
}
