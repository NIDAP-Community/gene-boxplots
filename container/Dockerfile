# syntax=docker/dockerfile:1
# Repository-owned application image derived from the reviewed visualization
# runtime. The pinned digest—not a mutable tag—is the runtime baseline.
ARG BASE_IMAGE=ghcr.io/nidap-community/omix-r-visualization@sha256:1d9f453b49412aa05e9d3420cd4b1b4ea0beac4923cb40572af38b0ae2a46830
FROM ${BASE_IMAGE}

WORKDIR /app

COPY R/ R/
COPY scripts/ scripts/
COPY schemas/ schemas/
COPY test_data/ test_data/
COPY module.yml entrypoint.R OMIX_MODULE_SOURCE.md renv.lock ./

ARG VCS_REF=unknown
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.title="gene-boxplots" \
      org.opencontainers.image.description="Portable Gene Boxplots component derived from OMIX" \
      org.opencontainers.image.source="https://github.com/NIDAP-Community/gene-boxplots" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.base.name="ghcr.io/nidap-community/omix-r-visualization@sha256:1d9f453b49412aa05e9d3420cd4b1b4ea0beac4923cb40572af38b0ae2a46830" \
      org.opencontainers.image.created="${BUILD_DATE}"

RUN mkdir -p /data /output \
    && useradd --create-home --uid 10001 --shell /usr/sbin/nologin boxplots \
    && chown --recursive boxplots:boxplots /app /data /output

ENV GENE_BOXPLOTS_IMAGE_REVISION=${VCS_REF} \
    GENE_BOXPLOTS_OMIX_SOURCE_COMMIT=0ea6223129de6d98d69469027c19fa1887b59f6a \
    GENE_BOXPLOTS_BASE_IMAGE=ghcr.io/nidap-community/omix-r-visualization@sha256:1d9f453b49412aa05e9d3420cd4b1b4ea0beac4923cb40572af38b0ae2a46830
USER boxplots
ENTRYPOINT ["Rscript", "--vanilla", "/app/entrypoint.R"]
CMD ["--help"]
