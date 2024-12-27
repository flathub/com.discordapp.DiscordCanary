#!/bin/bash

read -ra SOCAT_ARGS <<<"${SOCAT_ARGS}"

FLATPAK_ID=${FLATPAK_ID:-"com.discordapp.DiscordCanary"}
OUR_SOCKET="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}/discord-ipc-0"
DISCORD_SOCKET="${XDG_RUNTIME_DIR}/discord-ipc-0"
rm -f "${OUR_SOCKET}"
socat "${SOCAT_ARGS[@]}" \
    "UNIX-LISTEN:${OUR_SOCKET},forever,fork" \
    "UNIX-CONNECT:${DISCORD_SOCKET}" \
    &
socat_pid=$!

WAYLAND_SOCKET=${WAYLAND_DISPLAY:-"wayland-0"}
FLAGS=("${DISCORD_FLAGS[@]}" "--enable-speech-dispatcher")

if [[ -e "$XDG_RUNTIME_DIR/${WAYLAND_SOCKET}" || -e "${WAYLAND_DISPLAY}" ]]
then
    FLAGS+=("--enable-features=WaylandWindowDecorations" "--ozone-platform-hint=auto")
fi

disable-breaking-updates.py
env TMPDIR="${XDG_CACHE_HOME}" zypak-wrapper /app/discord-canary/DiscordCanary "${FLAGS[@]}" "$@"
kill -SIGTERM $socat_pid
