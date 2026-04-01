#!/bin/bash
export DISPLAY=:${DISPLAY_NUM:-1}

echo "[autologin] Waiting for Chromium..."
for i in $(seq 1 40); do
    WID=$(xdotool search --class chromium 2>/dev/null | head -1)
    [ -n "$WID" ] && break
    sleep 1
done

if [ -z "$WID" ]; then
    echo "[autologin] ERROR: Chromium window not found"
    exit 1
fi

sleep 5

echo "[autologin] Typing username..."
xdotool windowfocus --sync "$WID"
sleep 0.5
xdotool type --clearmodifiers --delay 80 "${HA_USERNAME}"
xdotool key Return

sleep 3

echo "[autologin] Typing password..."
xdotool type --clearmodifiers --delay 80 "${HA_PASSWORD}"
xdotool key Return

echo "[autologin] Done."
