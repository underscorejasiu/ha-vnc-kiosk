FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    chromium \
    tigervnc-scraping-server \
    xvfb \
    openbox \
    websockify \
    xdotool \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG NOVNC_VERSION=v0.5.1
RUN git clone --branch $NOVNC_VERSION https://github.com/novnc/noVNC.git /opt/novnc

COPY index.html /opt/novnc/index.html
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/autologin.sh  /usr/local/bin/autologin.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/autologin.sh

EXPOSE 5900 6080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
