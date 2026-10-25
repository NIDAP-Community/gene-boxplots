# Architecture

`gene-boxplots` is an application-layer component derived from canonical OMIX
Gene Boxplots. The copied R implementation and CLI own plotting and
statistical behavior; the root wrapper only provides portable result
organization and provenance.

OncoChat stages a normalized expression artifact, aligned metadata, and—only
for canonical `precomputed_deg` mode—a compatible upstream DEG artifact under
`/data`. The image never connects to PostgreSQL directly. See the canonical
[Gene Boxplots preflight](https://github.com/NIDAP-Community/OMIX/blob/main/docs/derivations/gene-boxplots-preflight.md).
