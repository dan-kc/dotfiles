What are you doing here?

### Linux status widgets

The Niri Home Manager configuration installs an Eww status panel with battery
percentage, charging state, a 0–100% output-volume slider, and Tailscale devices.
It uses the current colour scheme and font. The panel is centred on monitor 0 and
does not reserve desktop space.

After rebuilding Plank from this directory:

```sh
sudo nixos-rebuild switch --flake path:.#plank
status-toggle
```

Press `Mod+U` or run `status-toggle` again to close it. The panel also has a close
button. Eww starts on demand; no startup service is required. The old
`status-notify` command also toggles the panel.
The “Log out” button closes the panel and opens Niri's session-exit confirmation.

Volume follows the default PipeWire output, including media-key changes. Moving
the slider unmutes it. Missing audio devices disable the slider; missing battery
hardware shows “No battery detected”. Battery data refreshes every ten seconds,
and audio every second.

Tailscale refreshes every five seconds using the local `tailscale status --json`
command. It shows this machine and online peers visible to it, with every assigned
Tailscale IPv4 and IPv6 address. Offline peers are omitted. The device list scrolls
to keep the panel bounded, and reports disconnected, signed-out, or unavailable
states without needing an API key. These are Tailscale addresses, not LAN or public
endpoint addresses.

The panel lives in `home/platforms/nixos/eww/`, with Nix integration in
`home/platforms/nixos/eww.nix`. Check its hardware adapter locally with:

```sh
python3 -m unittest discover -s tests -p status_widgets.py
```
