FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    chromium \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    xdotool \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/autologin.sh  /usr/local/bin/autologin.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/autologin.sh

EXPOSE 5900 6080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
