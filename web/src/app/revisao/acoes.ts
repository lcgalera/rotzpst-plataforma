"use server";

import { updateTag } from "next/cache";
import { headers } from "next/headers";
import { redirect } from "next/navigation";
import { TAG_NOTICIAS } from "@/lib/noticias";
import { autorizado, type CategoriaErro, registrarRevisao } from "@/lib/revisao";

export type EstadoRevisao = { erro: string } | null;

/** Grava a decisão do revisor. Confere a credencial aqui também: ações são endpoints públicos. */
export async function revisar(_anterior: EstadoRevisao, formData: FormData): Promise<EstadoRevisao> {
  if (!autorizado((await headers()).get("authorization"))) throw new Error("Não autorizado.");
  const id = Number(formData.get("analise_id"));
  const decisao = formData.get("decisao");
  if (!Number.isInteger(id) || (decisao !== "aprovada" && decisao !== "rejeitada"))
    return { erro: "Dados inválidos." };
  const erros = formData.getAll("erros").map(String) as CategoriaErro[];
  const nota = String(formData.get("nota") ?? "").trim() || null;
  if (decisao === "rejeitada" && erros.length === 0 && !nota) {
    return { erro: "Ao rejeitar, marque ao menos uma categoria de erro ou escreva uma nota." };
  }
  if (!(await registrarRevisao(id, decisao, erros, nota))) {
    return { erro: "Esta análise já foi revisada (talvez em outra aba). Recarregue a página." };
  }
  updateTag(TAG_NOTICIAS);
  redirect("/revisao");
}
