# Deploy: Vercel (site) + Neon (banco) + GitHub Actions (jobs)

Decisões do dono (2026-11-10): Vercel Hobby (grátis, uso não comercial), Neon Free, Vercel Web Analytics, endereço `.vercel.app`.

> **Senhas e strings de conexão nunca vão para o chat nem para o git.** Elas ficam só nos painéis do Neon, da Vercel e do GitHub (segredos).

## 1. Banco no Neon

1. Crie uma conta em https://neon.com e um projeto (ex.: `rotzx`). Escolha a região mais próxima do Brasil entre as oferecidas.
2. No painel do projeto, em **Connect**, copie a **connection string com pooling** (o host tem `-pooler`). Ela termina em `?sslmode=require`.
3. Guarde essa string: ela é usada nos passos 2 e 3.

## 2. Segredo no GitHub e primeira carga

1. No repositório `lcgalera/rotzpst-plataforma`: **Settings → Secrets and variables → Actions → New repository secret**.
   - Nome: `DATABASE_URL`
   - Valor: a string do Neon.
2. Em **Actions**, rode os workflows manualmente (**Run workflow**), **nesta ordem**:
   1. **Notícias (coleta)**: cria as tabelas e coleta os feeds.
   2. **Dados (indicadores)** com as opções `com_fmi` e `importar_publicacao` marcadas: carrega países, geometrias, indicadores do Banco Mundial e do FMI, e importa as 16 notícias já revisadas (`db/seeds/noticias_publicadas.json`).

   A ordem importa: a checagem de saúde reclama se nenhuma coleta de notícias foi registrada ainda.
3. Daí em diante, os agendamentos rodam sozinhos:

   | Workflow | Quando |
   |---|---|
   | Notícias | 2× por dia |
   | Dados, só Banco Mundial | toda segunda |
   | Dados, com FMI | todo dia 2 |

   Se algum falhar, o GitHub avisa por e-mail.

## 3. Site na Vercel

1. Crie uma conta em https://vercel.com (pode entrar com o GitHub) e clique em **Add New → Project**. Importe `lcgalera/rotzpst-plataforma`.
2. Em **Root Directory**, escolha `web`. O resto (Next.js, pnpm) é detectado sozinho.
3. Em **Environment Variables**, antes do primeiro deploy:

   | Nome | Valor |
   |---|---|
   | `DATABASE_URL` | a mesma string do Neon |
   | `NEXT_PUBLIC_SITE_URL` | `https://<nome-do-projeto>.vercel.app` (o endereço que a Vercel mostrar; precisa existir **antes** do build, porque o sitemap e os links canônicos são gerados com ele) |
   | `REVISAO_SENHA` | uma senha longa para o painel `/revisao` (usuário `revisor`) |

4. Faça o deploy. Se o nome do endereço mudar, atualize `NEXT_PUBLIC_SITE_URL` e faça um novo deploy.
5. Na aba **Analytics** do projeto, ative o **Web Analytics**.

O build precisa do banco já carregado (passo 2): as páginas de país são geradas a partir dele.

## 4. Rotina de notícias com IA (na sua assinatura)

A coleta é automática; a análise e a revisão não são, de propósito.

1. Abra o Claude Code **no seu computador**, na pasta do repositório, com `DATABASE_URL` do Neon num arquivo `.env` local (já ignorado pelo git).
2. Peça: "analise o próximo lote de notícias seguindo `ingest/news/analise/instrucoes.md`". O agente roda `jobs.noticias exportar`, gera o resultado, valida e importa.
3. Revise em `https://<seu-site>/revisao`. Aprovar publica; o site atualiza na hora.
4. De tempos em tempos: `uv run python -m jobs.noticias taxa-erro` para atualizar `docs/taxa-erro-ia.md`.

## O que fica de fora (por enquanto)

- **Atualização dos indicadores no site:** os dados ficam em cache por até 1 dia. Depois de uma carga nova, o site reflete os números em até 24 h (ou na hora, num novo deploy).
- **Banco dormindo:** no plano grátis do Neon, o banco dorme após 5 min sem uso. A primeira visita depois disso pode levar um pouco mais.
- **Conferência da balança comercial com o MDIC:** pode ser feita no ambiente de produção. A análise continua fora do ar até lá.
- **Uso comercial:** a Vercel Hobby proíbe; a Agência Brasil e o FMI exigem autorização para uso comercial. Rever tudo antes de monetizar (Fase 6).
