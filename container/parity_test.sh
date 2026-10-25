#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -ne 2 ]]; then
  printf '%s\n' 'Usage: container/parity_test.sh <application-image> <canonical-omix-module-dir>' >&2
  exit 2
fi

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(CDPATH= cd -- "${script_dir}/.." && pwd)"
application_image="$1"
canonical_module_dir="$2"
runtime_image="${GENE_BOXPLOTS_CANONICAL_RUNTIME:-ghcr.io/nidap-community/omix-r-visualization@sha256:1d9f453b49412aa05e9d3420cd4b1b4ea0beac4923cb40572af38b0ae2a46830}"
test -d "${canonical_module_dir}" || { printf 'Canonical module directory does not exist: %s\n' "${canonical_module_dir}" >&2; exit 2; }

parity_root="$(mktemp -d "${TMPDIR:-/tmp}/gene-boxplots-parity.XXXXXX")"
standalone_output="${parity_root}/standalone"
canonical_output="${parity_root}/canonical"
mkdir -p "${canonical_output}"

"${script_dir}/run_docker.sh" "${application_image}" "${project_dir}/test_data" "${standalone_output}" \
  --expression_table /data/expression.tsv --metadata_table /data/sample_metadata.tsv \
  --deg_table /data/deg_results.tsv --genes GeneA --gene_column GeneName \
  --sample_column Sample --category_column Group --statistics_mode precomputed_deg \
  --output_dir /output

docker run --rm --platform "${DOCKER_PLATFORM:-linux/amd64}" --workdir /output \
  --user "$(id -u):$(id -g)" \
  --mount "type=bind,src=$(CDPATH= cd -- "${canonical_module_dir}" && pwd -P),dst=/omix/OMIX-Gene-Boxplots,readonly" \
  --mount "type=bind,src=${project_dir}/test_data,dst=/data,readonly" \
  --mount "type=bind,src=${canonical_output},dst=/output" \
  --entrypoint Rscript "${runtime_image}" --vanilla /omix/OMIX-Gene-Boxplots/scripts/run_gene_boxplots.R \
  --expression_table /data/expression.tsv --metadata_table /data/sample_metadata.tsv \
  --deg_table /data/deg_results.tsv --genes GeneA --gene_column GeneName \
  --sample_column Sample --category_column Group --statistics_mode precomputed_deg --output_dir /output

cmp "${standalone_output}/tables/gene_boxplot_statistics.csv" "${canonical_output}/gene_boxplot_statistics.csv"
cmp "${standalone_output}/tables/gene_boxplot_expression_long.csv" "${canonical_output}/gene_boxplot_expression_long.csv"
cmp "${standalone_output}/tables/gene_boxplot_run_summary.csv" "${canonical_output}/gene_boxplot_run_summary.csv"
printf 'Canonical/standalone Gene Boxplots parity passed: %s\n' "${parity_root}"
