#!/usr/bin/env bash
# Gera db/seeds/ci.sql: recorte REAL do banco de desenvolvimento para o build do site no CI.
# Inclui catálogo, todos os países e as séries de Brasil (completo), Índia (sem dívida) e Venezuela (inflação defasada).
# Uso: DATABASE_URL=... db/seeds/gerar_semente_ci.sh
set -euo pipefail
cd "$(dirname "$0")"
{
  echo "-- Gerado por gerar_semente_ci.sh em $(date -u +%Y-%m-%d). Dados reais (Banco Mundial e FMI), recorte para CI. Não editar à mão."
  pg_dump "$DATABASE_URL" --data-only --no-owner --no-privileges --inserts --rows-per-insert=500 \
    -t fontes_dados -t indicadores -t paises
  psql "$DATABASE_URL" -Atc "COPY (SELECT * FROM series WHERE pais_iso3 IN ('BRA','IND','VEN') ORDER BY 1,2,3) TO STDOUT WITH CSV" \
    | awk 'BEGIN{print "COPY public.series FROM stdin WITH CSV;"} {print} END{print "\\."}'
} > ci.sql
echo "ci.sql: $(wc -c < ci.sql) bytes"
