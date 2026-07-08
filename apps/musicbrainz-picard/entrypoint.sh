#!/usr/bin/env bash
set -euo pipefail

# Start virtual framebuffer
Xvfb "${DISPLAY}" -screen 0 "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24" -nolisten tcp &

# Wait for X to be ready
for _ in $(seq 1 30); do
    if xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; then
        break
    fi
    sleep 0.2
done

# Start window manager
openbox &

# Start VNC server (x11vnc exposes Xvfb on port 5900)
x11vnc -display "${DISPLAY}" -forever -shared -nopw -rfbport 5900 &

# Start noVNC web client (proxies VNC on port 5800)
websockify --web=/usr/share/novnc 5800 localhost:5900 &

# Start MusicBrainz Picard
exec picard
