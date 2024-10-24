#!/bin/bash
FLATPAK_ID=${FLATPAK_ID:-"com.discordapp.DiscordCanary"}
socat $SOCAT_ARGS \
    UNIX-LISTEN:$XDG_RUNTIME_DIR/app/${FLATPAK_ID}/discord-ipc-0,forever,fork \
    UNIX-CONNECT:$XDG_RUNTIME_DIR/discord-ipc-0 \
    &
socat_pid=$!

WAYLAND_SOCKET=${WAYLAND_DISPLAY:-"wayland-0"}
FLAGS=("${DISCORD_FLAGS[@]}" "--enable-speech-dispatcher")

if [[ -e "$XDG_RUNTIME_DIR/${WAYLAND_SOCKET}" || -e "${WAYLAND_DISPLAY}" ]]
then
    FLAGS+=("--enable-features=WaylandWindowDecorations" "--ozone-platform-hint=auto")
fi

disable-breaking-updates.py
env TMPDIR=$XDG_CACHE_HOME zypak-wrapper /app/discord-canary/DiscordCanary "${FLAGS[@]}" "$@"
kill -SIGTERM $socat_pid
