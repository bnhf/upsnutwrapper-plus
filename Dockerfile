#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -f Dockerfile -t bnhf/upsnutwrapper-plus:latest -t bnhf/upsnutwrapper-plus:2025.08.19 . --push --no-cache
FROM debian:12-slim

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    nano \
    procps \
    iputils-ping \
    ucspi-tcp \
    apcupsd \
    && rm -rf /var/lib/apt/lists/*

COPY upsnutwrapper-plus.sh .

RUN chmod +x ./upsnutwrapper-plus.sh \
    && touch /tmp/upsnutwrapper.log

# Expose default NUT port
EXPOSE 3493

# Set the container entrypoint
CMD ["sh", "-c", "tcpserver -q -c 10 -HR 0.0.0.0 3493 ./upsnutwrapper-plus.sh & tail -F /tmp/upsnutwrapper.log"]
