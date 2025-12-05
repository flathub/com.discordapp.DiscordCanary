# Discord Canary

Discord is a free all-in-one messaging, voice and video client that's available on your computer and phone.

This repo hosts the flatpak wrapper for [Discord Canary](https://canary.discord.com/), available at Flathub-Beta.

```sh
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install flathub-beta com.discordapp.DiscordCanary
flatpak run com.discordapp.DiscordCanary
```

## Reporting bugs

If you're experiencing a problem exclusive to the Flatpak version of Discord, i.e. it doesn't happen when running the official [deb](https://discord.com/api/download/canary?platform=linux&format=deb) or [tar.gz](https://discord.com/api/download/canary?platform=linux&format=tar.gz) packages unsandboxed, feel free to open an issue about it here.

Otherwise, please use the [official bug report form](https://support.discord.com/hc/en-us/articles/1500006052822-How-to-Report-a-Bug) instead, as it increases the chances of a bug getting fixed.


## Differences in flatpak version

The flatpak version runs in a sandbox to provide better safety and privacy for users.

However, this sandboxing prevents the following features from working:

- **Game Activity**: This flatpak version of Discord cannot scan running processes to detect running games.  
  There is currently no workaround or solution for this limitation.
- **Unrestricted File Access**: Default sandbox permissions for this package does not allow host filesystem access. You can attach files using "send file" menu, but "drag-n-drop" feature will not work.  
  This limitation will likely be overcomed eventually, when Electron give us a file picker portal which will allow full access to the filesystem while still restricting unauthorized access.  
  To work around this now, you can change sandbox permissions of installed flatpak applications (for example, with [Flatseal](https://flathub.org/apps/details/com.github.tchx84.Flatseal) or with `flatpak override --user --filesystem=home com.discordapp.DiscordCanary`) to give Discord broader file system access, allowing file attachments from more locations.
- **Rich Presence**: See [this page](https://github.com/flathub/com.discordapp.Discord/wiki/Rich-Precense-(discord-rpc)) if you want to expose Discord's rich presence interface for other applications.


### Wayland

Wayland support is enabled by default since Discord 0.0.820 (released in 2025-12-05).

Please note that native window decorations are not enabled by default. To do so, add the following lines to your [persistent launch options](#persistent-launch-options):

```
--enable-features=WaylandWindowDecorations
--ozone-platform-hint=auto
```

To disable Wayland support permanently, run:

```
flatpak override --user --nosocket=wayland com.discordapp.DiscordCanary
```

### Persistent launch options

To make Discord's launch options persistent, add them to `~/.var/app/com.discordapp.DiscordCanary/config/discord-flags.conf` (one option per line):

```conf
# This line will be ignored
--enable-features=WaylandWindowDecorations

# https://chromium.googlesource.com/chromium/src/+/master/docs/linux/password_storage.md
--password-store=basic
```

#### Persistent launch options (deprecated)

You can change `DISCORD_FLAGS` env variable to add any required flags:
```sh
flatpak override --user --env=DISCORD_FLAGS=--required-flag com.discordapp.DiscordCanary
```

To reset env changes do the same with `--unset-env=DISCORD_FLAGS`


### Opening Discord automatically at system startup

The Discord app has a built-in option for that, but it doesn't work on Flatpak mostly because of sandbox restrictions.

But we can still do that manually, with these two commands:

```sh
mkdir -p ~/.config/autostart
ln -s "$(flatpak info -l com.discordapp.DiscordCanary//beta | sed 's#/app/.*#/exports/share/applications/com.discordapp.DiscordCanary.desktop#')" ~/.config/autostart
```

To undo that, run:

```sh
rm ~/.config/autostart/com.discordapp.DiscordCanary.desktop
```

## Legal

The Discord app itself is **proprietary** (closed source).
