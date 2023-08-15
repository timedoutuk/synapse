ARG PYTHON_VERSION=3.14

FROM docker.io/python:${PYTHON_VERSION}-slim as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libjpeg-dev \
    libpq-dev \
    libssl-dev \
    libwebp-dev \
    libxml++2.6-dev \
    libxslt1-dev \
    zlib1g-dev \
    openssl \
    git \
    curl \
 && rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/rust
ENV CARGO_HOME=/cargo
ENV PATH=/cargo/bin:/rust/bin:$PATH
RUN mkdir /rust /cargo

RUN curl -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable

COPY synapse /synapse/synapse/
COPY rust /synapse/rust/
COPY README.rst pyproject.toml requirements.txt build_rust.py /synapse/

RUN pip install --prefix="/install" --no-warn-script-location --ignore-installed \
        --no-deps -r /synapse/requirements.txt \
 && pip install --prefix="/install" --no-warn-script-location \
        --no-deps \
	'synapse-simple-antispam @ git+https://github.com/maunium/synapse-simple-antispam' \
	'synapse-http-antispam @ git+https://github.com/maunium/synapse-http-antispam' \
	'shared_secret_authenticator @ git+https://github.com/devture/matrix-synapse-shared-secret-auth@2.0.3' \
 && pip install --prefix="/install" --no-warn-script-location \
        --no-deps /synapse

FROM docker.io/python:${PYTHON_VERSION}-slim

RUN apt-get update && apt-get install -y \
    curl \
    libjpeg62-turbo \
    libpq5 \
    libwebp7 \
    xmlsec1 \
    libjemalloc2 \
    openssl \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local

VOLUME ["/data"]
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

ENTRYPOINT ["python3", "-m", "synapse.app.homeserver"]
CMD ["--keys-directory", "/data", "-c", "/data/homeserver.yaml"]

HEALTHCHECK --start-period=5s --interval=1m --timeout=5s \
  CMD curl -fSs http://localhost:8008/health || exit 1
