FROM mcr.microsoft.com/devcontainers/base:bullseye
LABEL Piotr ZAWADZKI "pzawadzki@polsl.pl"

RUN apt-get update && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y -qq --no-install-recommends curl git libgraphite2-3 mc cmake make fontconfig perl cpanminus && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/apt/

WORKDIR /tmp

# latexindent
ARG LATEXINDENT_VERSION
ENV LATEXINDENT_VERSION ${LATEXINDENT_VERSION:-V3.23.1}

RUN git clone --depth 1 https://github.com/cmhughes/latexindent.pl --branch "${LATEXINDENT_VERSION}"

WORKDIR /tmp/latexindent.pl/helper-scripts

RUN echo "Y" | perl latexindent-module-installer.pl

WORKDIR /tmp/latexindent.pl/build

RUN cmake ../path-helper-files && make install && ln -s /usr/local/bin/latexindent.pl /usr/local/bin/latexindent

WORKDIR /usr/local/bin

# tectonic
RUN curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net |sh
