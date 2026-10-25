#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(CDPATH= cd -- "${script_dir}/.." && pwd)"
image="${1:-gene-boxplots:local}"
smoke_root="$(mktemp -d "${TMPDIR:-/tmp}/gene-boxplots-smoke.XXXXXX")"
output_dir="${smoke_root}/output"

"${script_dir}/run_docker.sh" "${image}" "${project_dir}/test_data" "${output_dir}" \
  --expression_table /data/expression.tsv \
  --metadata_table /data/sample_metadata.tsv \
  --genes GeneA \
  --gene_column GeneName \
  --sample_column Sample \
  --category_column Group \
  --output_dir /output

for artifact in \
  tables/gene_boxplot_statistics.csv \
  tables/gene_boxplot_expression_long.csv \
  tables/gene_boxplot_run_summary.csv \
  figures/gene_boxplots/GeneA.png \
  logs/sessionInfo.txt \
  RUN_METADATA.md \
  run_manifest.json; do
  test -s "${output_dir}/${artifact}" || { printf 'Missing smoke artifact: %s\n' "${artifact}" >&2; exit 1; }
done
grep -q 'Completed successfully.' "${output_dir}/RUN_METADATA.md"
grep -q '"status": "completed"' "${output_dir}/run_manifest.json"
printf 'Gene Boxplots container smoke test passed: %s\n' "${output_dir}"
