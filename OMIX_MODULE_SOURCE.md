# Canonical OMIX Module Source

## Pinned source snapshot

| Item | Value |
| --- | --- |
| Canonical module | `OMIX-Gene-Boxplots` |
| Canonical path | `modules/OMIX-Gene-Boxplots/` |
| OMIX source commit | `0ea6223129de6d98d69469027c19fa1887b59f6a` |
| Module version | `1.0.0` |
| Interface version | `1` |
| Canonical tag | Pending; no tag exists for this snapshot |
| Runtime profile | `r-visualization` |

## Imported files

| Canonical file | Repository copy | SHA-256 |
| --- | --- | --- |
| `R/Boxplot_with_Stats.R` | `R/Boxplot_with_Stats.R` | `dd4ce18058849c8560b8f137b2d8ab9b1712c88fbbd256be3ecd505469620715` |
| `R/OMIX_Gene_Boxplots.R` | `R/OMIX_Gene_Boxplots.R` | `9a5b8405b11347e63a7e2433356a55ec4c03f46fcbe09b1ef3bd5a3f142e6801` |
| `scripts/run_gene_boxplots.R` | `scripts/run_gene_boxplots.R` | `72d219759d0b46a5da993fe1d969bc05f625fd930c2f2783de8853514c43ae70` |
| `schemas/interface.yml` | `schemas/interface.yml` | `57f2aee00ad5cdbccbfdb6c78ef6c89d392d0f60506d2d5eacca61c9d3f28033` |
| `module.yml` | `module.yml` | `4be79b82197b1c4604c165a77c5e1048fe0f71c1c2aa0f80d1b404226c702336` |

The scientific implementation is a pinned OMIX export. Do not edit it in this
repository. Scientific or reusable-interface changes must be made, validated,
and versioned in OMIX before this export is refreshed.

## Runtime source

```text
ghcr.io/nidap-community/omix-r-visualization@sha256:1d9f453b49412aa05e9d3420cd4b1b4ea0beac4923cb40572af38b0ae2a46830
```

The copied `renv.lock` has SHA-256
`ad17b0bec64cad3f97dfcc9e352f183fe99dcf77555b6bab6494ec277aa81b32`.
The derived application image must be validated independently and recorded by
its own immutable digest before use by OncoChat.
