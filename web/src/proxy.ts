import { type NextRequest, NextResponse } from "next/server";

/**
 * Proteção do painel /revisao com Basic Auth (usuário "revisor", senha em REVISAO_SENHA).
 * Checagem "otimista": as ações que gravam no banco conferem a credencial de novo (src/lib/revisao.ts).
 * Sem REVISAO_SENHA configurada, o painel fica fechado.
 */
export function proxy(request: NextRequest) {
  const senha = process.env.REVISAO_SENHA;
  const cab = request.headers.get("authorization");
  if (senha && cab?.startsWith("Basic ")) {
    const [usuario, ...resto] = atob(cab.slice(6)).split(":");
    if (usuario === "revisor" && resto.join(":") === senha) return NextResponse.next();
  }
  return new NextResponse("Acesso restrito ao painel de revisão.", {
    status: 401,
    headers: { "WWW-Authenticate": 'Basic realm="rotzx revisao", charset="UTF-8"' },
  });
}

export const config = {
  matcher: ["/revisao", "/revisao/:path*"],
};
