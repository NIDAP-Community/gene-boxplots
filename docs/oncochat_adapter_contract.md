# OncoChat Adapter Contract

The adapter accepts bounded request fields defined in `schemas/interface.yml`,
stages approved workflow artifacts at `/data`, and invokes the resolved OCI
digest. It never forwards host paths, credentials, or arbitrary shell flags.

The default `within_plot` mode calculates independent comparisons from the
staged normalized expression and metadata. `precomputed_deg` requires a
declared compatible DEG artifact and must be selected explicitly. The required
staging and release gates are defined in the canonical [Gene Boxplots
preflight](https://github.com/NIDAP-Community/OMIX/blob/main/docs/derivations/gene-boxplots-preflight.md).
