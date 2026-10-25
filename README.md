# Gene Boxplots

`gene-boxplots` is a portable application component for plotting selected
genes across declared sample groups. It is derived from the canonical
[OMIX Gene Boxplots](https://github.com/NIDAP-Community/OMIX/tree/main/modules/OMIX-Gene-Boxplots)
module at a pinned source commit; see [OMIX_MODULE_SOURCE.md](OMIX_MODULE_SOURCE.md).

## Status

This is an unpublished local derivation. It is not yet an OncoChat-enabled
analysis or a published OCI image.

## Input contract

The canonical interface requires a normalized continuous gene-by-sample
expression table, aligned sample metadata, and one or more gene identifiers.
Raw integer counts are not valid direct input. For OncoChat, the normalized
matrix will be a declared workflow artifact derived from the approved database
source.

The default `precomputed_deg` statistics mode also requires a compatible DEG
result table. Alternatively, choose canonical `within_plot` or `none`
explicitly; the application never silently changes statistical mode.

## Local CLI

```bash
Rscript entrypoint.R \
  --expression_table test_data/expression.tsv \
  --metadata_table test_data/sample_metadata.tsv \
  --deg_table test_data/deg_results.tsv \
  --genes GeneA \
  --gene_column GeneName \
  --sample_column Sample \
  --category_column Group \
  --statistics_mode precomputed_deg \
  --output_dir results/example
```

The canonical interface and parameter definitions are in
[schemas/interface.yml](schemas/interface.yml). A successful application run
writes a self-describing bundle:

```text
<output_dir>/
├── RUN_METADATA.md
├── run_manifest.json
├── tables/
│   ├── gene_boxplot_expression_long.csv
│   ├── gene_boxplot_run_summary.csv
│   └── gene_boxplot_statistics.csv
├── figures/gene_boxplots/<gene>.png
└── logs/sessionInfo.txt
```

## Container status

The application image will build from the pinned OMIX `r-visualization` runtime
for `linux/amd64`. The helper uses the standard read-only `/data` and writable
`/output` mount contract. Publication is intentionally deferred until source
parity, container, representative-data, and OncoChat acceptance gates pass.
