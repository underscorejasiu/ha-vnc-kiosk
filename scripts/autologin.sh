#!/bin/bash
export DISPLAY=:${DISPLAY_NUM:-0}

find_chromium_window() {
    xdotool search --class chromium 2>/dev/null | head -1
    xdotool search --class Chromium 2>/dev/null | head -1
    xdotool search --name "Chromium" 2>/dev/null | head -1
}

echo "[autologin] Waiting for Chromium..."
for i in $(seq 1 60); do
    WID=$(find_chromium_window | head -1)
    [ -n "$WID" ] && break
    [ "$i" = "10" ] && echo "[autologin] Still waiting... known windows: $(xdotool search --name '' 2>/dev/null | wc -l)"
    sleep 1
done

if [ -z "$WID" ]; then
    echo "[autologin] ERROR: Chromium window not found after 60s"
    echo "[autologin] All windows: $(xdotool search --name '' 2>/dev/null)"
    exit 1
fi

echo "[autologin] Found window: $WID"
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
