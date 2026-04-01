#!/bin/bash
set -e

DISPLAY_NUM=${DISPLAY_NUM:-1}
export DISPLAY=:${DISPLAY_NUM}

echo "[*] Starting Xvfb..."
Xvfb :${DISPLAY_NUM} -screen 0 ${SCREEN_WIDTH:-1920}x${SCREEN_HEIGHT:-1080}x24 -ac &
sleep 1

echo "[*] Starting x11vnc..."
x11vnc -display :${DISPLAY_NUM} -forever -shared -rfbport 5900 -nopw &
sleep 1

echo "[*] Starting noVNC..."
websockify --web /usr/share/novnc 6080 localhost:5900 &
sleep 1

echo "[*] Clearing Chromium profile locks..."
rm -f /profile/SingletonLock /profile/SingletonSocket /profile/SingletonCookie

echo "[*] Starting Chromium → ${HA_URL}"
chromium \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --user-data-dir=/profile \
    --window-size=${SCREEN_WIDTH:-1024},${SCREEN_HEIGHT:-600} \
    --window-position=0,0 \
    --kiosk \
    --noerrdialogs \
    --disable-infobars \
    --disable-session-crashed-bubble \
    --disable-restore-session-state \
    --ignore-profile-directory-lock \
    "${HA_URL:-http://homeassistant.local:8123}" &

if [ -n "$HA_USERNAME" ] && [ -n "$HA_PASSWORD" ]; then
    echo "[*] Auto-login scheduled..."
    /usr/local/bin/autologin.sh &
fi

wait
