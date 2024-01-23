FROM debian:buster-slim

RUN apt-get update && apt-get install -y wget gnupg \
    && rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION=22.0 \
    BITCOIN_URL=https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    BITCOIN_SHA256_URL=https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc

RUN wget ${BITCOIN_URL} \
    && wget ${BITCOIN_SHA256_URL} \
    && wget https://bitcoincore.org/keys.asc \
    && gpg --import keys.asc \
    && gpg --verify SHA256SUMS.asc \
    && grep $(sha256sum bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz | awk '{print $1}') SHA256SUMS.asc \
    && tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz -C /usr/local --strip-components=1 \
    && rm *.tar.gz *.asc keys.asc

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin
USER bitcoin

ENTRYPOINT ["bitcoind"]
