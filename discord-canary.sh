#!/bin/bash
FLATPAK_ID=${FLATPAK_ID:-"com.discordapp.DiscordCanary"}
socat $SOCAT_ARGS \
    UNIX-LISTEN:$XDG_RUNTIME_DIR/app/${FLATPAK_ID}/discord-ipc-0,forever,fork \
    UNIX-CONNECT:$XDG_RUNTIME_DIR/discord-ipc-0 \
    &
socat_pid=$!

if [[ $XDG_SESSION_TYPE == "wayland" ]]
then
    FEATURES="WaylandWindowDecorations"
fi

FLAGS="--ozone-platform=$XDG_SESSION_TYPE \
--enable-features=$FEATURES"

if [[ $XDG_SESSION_TYPE == "wayland" ]] && [ -c /dev/nvidia0 ]
then
    FLAGS="$FLAGS --disable-gpu-sandbox"
fi

disable-breaking-updates.py
env TMPDIR=$XDG_CACHE_HOME zypak-wrapper /app/discord-canary/DiscordCanary $FLAGS "$@"
kill -SIGTERM $socat_pid
