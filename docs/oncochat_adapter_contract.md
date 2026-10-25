# OncoChat Adapter Contract

The adapter accepts bounded request fields defined in `schemas/interface.yml`,
stages approved workflow artifacts at `/data`, and invokes the resolved OCI
digest. It never forwards host paths, credentials, or arbitrary shell flags.

`precomputed_deg` requires a declared compatible DEG artifact; users must
explicitly select canonical `within_plot` or `none` when no such artifact is
available. The required staging and release gates are defined in the canonical
[Gene Boxplots preflight](https://github.com/NIDAP-Community/OMIX/blob/main/docs/derivations/gene-boxplots-preflight.md).
