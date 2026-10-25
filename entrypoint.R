#!/usr/bin/env Rscript

# Application wrapper only: the copied OMIX files own all plotting and
# statistical behavior. This layer standardizes the portable result bundle and
# records provenance after a successful canonical invocation.
args <- commandArgs(trailingOnly = TRUE)
script_path <- file.path("scripts", "run_gene_boxplots.R")

if (!file.exists(script_path)) {
  stop("Canonical Gene Boxplots CLI is missing: ", script_path)
}

option_value <- function(option_name, values) {
  exact_match <- which(values == option_name)
  if (length(exact_match) == 1L && exact_match < length(values)) {
    return(values[[exact_match + 1L]])
  }
  prefix <- paste0(option_name, "=")
  inline_match <- values[startsWith(values, prefix)]
  if (length(inline_match) == 1L) {
    return(substring(inline_match, nchar(prefix) + 1L))
  }
  NULL
}

write_result_bundle <- function(output_dir, arguments) {
  artifacts <- data.frame(
    role = c("Gene-boxplot statistics", "Long-form expression", "Canonical run summary"),
    source = file.path(output_dir, c(
      "gene_boxplot_statistics.csv",
      "gene_boxplot_expression_long.csv",
      "gene_boxplot_run_summary.csv"
    )),
    destination = file.path("tables", c(
      "gene_boxplot_statistics.csv",
      "gene_boxplot_expression_long.csv",
      "gene_boxplot_run_summary.csv"
    )),
    stringsAsFactors = FALSE
  )
  plot_source <- file.path(output_dir, "gene_boxplots")

  if (!all(file.exists(artifacts$source)) || !dir.exists(plot_source)) {
    stop("Canonical run completed without all expected Gene Boxplots artifacts.")
  }

  dir.create(file.path(output_dir, "tables"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(output_dir, "figures"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(output_dir, "logs"), recursive = TRUE, showWarnings = FALSE)
  for (index in seq_len(nrow(artifacts))) {
    if (!file.rename(artifacts$source[[index]], file.path(output_dir, artifacts$destination[[index]]))) {
      stop("Could not place result artifact: ", artifacts$role[[index]])
    }
  }
  if (!file.rename(plot_source, file.path(output_dir, "figures", "gene_boxplots"))) {
    stop("Could not place the Gene Boxplots figure directory.")
  }
  capture.output(sessionInfo(), file = file.path(output_dir, "logs", "sessionInfo.txt"))

  input_options <- c("--expression_table", "--metadata_table", "--deg_table")
  input_paths <- vapply(input_options, function(option_name) {
    value <- option_value(option_name, arguments)
    if (is.null(value)) "" else value
  }, character(1L))
  names(input_paths) <- input_options
  input_paths <- input_paths[nzchar(input_paths)]
  input_manifest <- data.frame(
    option = names(input_paths),
    path = unname(input_paths),
    md5 = unname(tools::md5sum(unname(input_paths))),
    stringsAsFactors = FALSE
  )

  runtime_versions <- c(
    R = R.version.string,
    ggplot2 = as.character(utils::packageVersion("ggplot2")),
    jsonlite = as.character(utils::packageVersion("jsonlite"))
  )
  application_revision <- Sys.getenv("GENE_BOXPLOTS_IMAGE_REVISION", "unknown")
  omix_source_commit <- Sys.getenv("GENE_BOXPLOTS_OMIX_SOURCE_COMMIT", "unknown")
  base_image <- Sys.getenv("GENE_BOXPLOTS_BASE_IMAGE", "unknown")
  timestamp <- format(Sys.time(), tz = "UTC", usetz = TRUE)

  metadata_lines <- c(
    "# Gene Boxplots Run Metadata", "", "## Status", "", "Completed successfully.",
    "", "## Provenance", "",
    paste("- Application revision:", application_revision),
    paste("- Canonical OMIX source commit:", omix_source_commit),
    "- Canonical OMIX module: OMIX-Gene-Boxplots (version 1.0.0; interface 1)",
    paste("- Pinned base image:", base_image),
    paste("- Completed UTC:", timestamp), "", "## Runtime", "",
    paste("-", names(runtime_versions), runtime_versions), "",
    "## Declared input artifacts", "", "| Option | Container path | MD5 |",
    "| --- | --- | --- |",
    paste0("| ", input_manifest$option, " | `", input_manifest$path, "` | `", input_manifest$md5, "` |"),
    "", "## Parameters", "", paste0("`", paste(arguments, collapse = " ` `"), "`"),
    "", "## Interpretation", "",
    "This is an exploratory research analysis, not clinical decision support."
  )
  writeLines(metadata_lines, file.path(output_dir, "RUN_METADATA.md"))

  manifest <- list(
    status = "completed",
    completed_utc = timestamp,
    application_revision = application_revision,
    canonical_omix_source_commit = omix_source_commit,
    base_image = base_image,
    artifacts = c(
      lapply(seq_len(nrow(artifacts)), function(index) {
        list(role = artifacts$role[[index]], path = artifacts$destination[[index]])
      }),
      list(
        list(role = "Gene Boxplots figures", path = "figures/gene_boxplots"),
        list(role = "R session information", path = "logs/sessionInfo.txt")
      )
    ),
    input_artifacts = lapply(seq_len(nrow(input_manifest)), function(index) {
      list(option = input_manifest$option[[index]], path = input_manifest$path[[index]], md5 = input_manifest$md5[[index]])
    }),
    arguments = arguments,
    runtime = as.list(runtime_versions)
  )
  jsonlite::write_json(manifest, file.path(output_dir, "run_manifest.json"), auto_unbox = TRUE, pretty = TRUE)
}

rscript <- file.path(R.home("bin"), "Rscript")
status <- system2(rscript, args = c("--vanilla", shQuote(script_path), shQuote(args)))
output_dir <- option_value("--output_dir", args)
if (identical(as.integer(status), 0L) && !is.null(output_dir)) {
  write_result_bundle(output_dir, args)
}
quit(save = "no", status = as.integer(status))
