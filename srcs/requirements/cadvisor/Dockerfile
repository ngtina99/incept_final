# bookworm is the latest stable release of Debian - required for latest cAdvisor
FROM debian:bookworm

RUN apt update -y && \
    apt install -y wget ca-certificates && \
    wget https://github.com/google/cadvisor/releases/download/v0.53.0/cadvisor-v0.53.0-linux-arm64 && \
    chmod +x cadvisor-v0.53.0-linux-arm64 && \
    mv cadvisor-v0.53.0-linux-arm64 /usr/local/bin/cadvisor

EXPOSE 8080
CMD ["cadvisor"]
