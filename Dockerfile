# Use a lightweight version of Debian as the base image
FROM debian:latest

# Set environment variables for the Bitcoin Core version
ENV BITCOIN_VERSION=26.0
ENV BITCOIN_DATA="/home/bitcoin/.bitcoin"

# Accept build arguments
ARG BITCOIN_URL
ARG BITCOIN_SHA256_URL
ARG BITCOIN_ASC_URL

# Install dependencies needed to fetch, verify, and run Bitcoin Core
RUN apt-get update && apt-get install -y wget gnupg git \
    && rm -rf /var/lib/apt/lists/*


# Download Bitcoin Core binaries, SHA256 checksums, and the corresponding signatures
RUN wget ${BITCOIN_URL} \
    && wget ${BITCOIN_SHA256_URL} \
    && wget ${BITCOIN_ASC_URL}

# Download the specific GPG key
RUN wget https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/fanquake.gpg -O fanquake.gpg

# Clone the guix.sigs repository to get the public keys
RUN git clone https://github.com/bitcoin-core/guix.sigs.git

# Import the public keys of trusted signers
RUN gpg --import fanquake.gpg \
    && gpg --import guix.sigs/builder-keys/*

# Verify the downloaded binary with the checksum and signatures
RUN sha256sum --ignore-missing --check SHA256SUMS \
    && gpg --verify SHA256SUMS.asc

# Clean up git and other unnecessary packages to reduce image size
RUN apt-get remove --purge -y git \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /guix.sigs


# Install Bitcoin Core
RUN tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz -C /usr/local --strip-components=1 \
    && rm *.tar.gz SHA256SUMS SHA256SUMS.asc

# Create a non-root user to run the daemon
RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin
USER bitcoin

# Expose the port Bitcoin daemon listens on
EXPOSE 8332

# Run Bitcoin daemon by default
ENTRYPOINT ["bitcoind"]



