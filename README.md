# Discord Canary

Discord is a free all-in-one messaging, voice and video client that's available on your computer and phone.

This repo hosts the flatpak wrapper for [Discord Canary](https://canary.discord.com/), available at Flathub-Beta.

```sh
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install flathub com.discordapp.DiscordCanary
flatpak run com.discordapp.DiscordCanary
```

## Limitations
* This flatpak version of Discord cannot scan running processes to detect running games.
* Default sandbox permissions for this package does not allow host filesystem access. You can attach files using "send file" menu, but "drag-n-drop" feature will not work.  
  To work around this now, you can change sandbox permissions (for example, with [Flatseal](https://flathub.org/apps/details/com.github.tchx84.Flatseal) or with `flatpak override --filesystem=home com.discordapp.DiscordCanary`) to give Discord broader file system access, allowing drag-n-drop file attachments from more locations.
* Rich Presence socket is not exposed for other applications by default.  
  Please consult [Discord (Stable) wiki page](https://github.com/flathub/com.discordapp.Discord/wiki/Rich-Precense-(discord-rpc)) if you want to expose Discord's rich presence interface for other applications.

## Opt-in features

### Wayland support

This package enables the flags to run on Wayland, however it is opt-in. To opt-in run:

```sh
flatpak override --user --socket=wayland com.discordapp.DiscordCanary
```

To opt-out do the same with `--nosocket=wayland`.


### Startup flags customization

You can change `DISCORD_FLAGS` env variable to add any required flags:
```sh
flatpak override --user --env=DISCORD_FLAGS=--required-flag com.discordapp.DiscordCanary
```

To reset env changes do the same with `--unset-env=DISCORD_FLAGS`
