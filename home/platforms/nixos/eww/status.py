"""Data for the Eww status panel; stdout is one JSON value per poll."""

import json
import math
from pathlib import Path
import re
import subprocess
import sys


def battery(root=Path("/sys/class/power_supply")):
    # Discover the laptop battery rather than assuming it is called BAT0.
    for supply in sorted(root.glob("*")):
        try:
            if (supply / "type").read_text().strip() != "Battery":
                continue
            if (supply / "present").exists() and (supply / "present").read_text().strip() == "0":
                continue
            percent = max(0, min(100, int((supply / "capacity").read_text())))
            state = (supply / "status").read_text().strip()
            return {"available": True, "percent": percent, "status": state}
        except (OSError, ValueError):
            continue
    return {"available": False, "percent": 0, "status": "No battery detected"}


def wpctl(*args):
    return subprocess.run(
        ["wpctl", *args], check=True, capture_output=True, text=True, timeout=2
    ).stdout


def volume():
    try:
        output = wpctl("get-volume", "@DEFAULT_AUDIO_SINK@")
        match = re.search(r"Volume:\s+(\d+(?:\.\d+)?)", output)
        if match:
            return {
                "available": True,
                "percent": max(0, min(100, round(float(match[1]) * 100))),
                "muted": "[MUTED]" in output,
            }
    except (OSError, subprocess.SubprocessError):
        pass
    return {"available": False, "percent": 0, "muted": False}


def set_volume(value):
    percent = float(value)
    if not math.isfinite(percent) or not 0 <= percent <= 100:
        raise ValueError("Volume must be between 0 and 100")
    wpctl("set-volume", "--limit", "1.0", "@DEFAULT_AUDIO_SINK@", f"{percent}%")
    # Moving the slider should produce sound even if a media key muted the sink.
    wpctl("set-mute", "@DEFAULT_AUDIO_SINK@", "0")


def tailscale():
    empty = {"status": "Tailscale unavailable", "devices": [], "count": 0}
    try:
        result = subprocess.run(
            ["tailscale", "status", "--json"], check=True,
            capture_output=True, text=True, timeout=3,
        )
        data = json.loads(result.stdout)
        if not isinstance(data, dict):
            return empty
    except (OSError, ValueError, subprocess.SubprocessError):
        return empty

    state = data.get("BackendState", "Unknown")
    if state != "Running":
        messages = {
            "Stopped": "Disconnected",
            "NeedsLogin": "Sign in to Tailscale",
            "NeedsMachineAuth": "Device awaiting approval",
            "Starting": "Connecting…",
            "NoState": "Not connected",
        }
        return {**empty, "status": messages.get(state, "Not connected")}

    def device(peer, local=False):
        # Use the tailnet name: mobile devices may report "localhost" as HostName.
        name = (peer.get("DNSName") or "").split(".")[0] or peer.get("HostName") or "Unnamed device"
        return {
            "name": name + (" (this device)" if local else ""),
            "ips": "\n".join(peer.get("TailscaleIPs") or []) or "No Tailscale IP",
            "online": local or bool(peer.get("Online")),
        }

    devices = []
    if data.get("Self"):
        devices.append(device(data["Self"], local=True))
    # Keep offline peers visible. Online describes control-plane connectivity;
    # Active only means recent traffic and must not determine connection status.
    peers = (data.get("Peer") or {}).values()
    devices.extend(sorted((device(peer) for peer in peers), key=lambda d: d["name"].casefold()))
    return {"status": "Connected", "devices": devices, "count": len(devices)}


if __name__ == "__main__":
    try:
        if sys.argv[1:] == ["battery"]:
            print(json.dumps(battery()))
        elif sys.argv[1:] == ["volume"]:
            print(json.dumps(volume()))
        elif sys.argv[1:] == ["tailscale"]:
            print(json.dumps(tailscale()))
        elif len(sys.argv) == 3 and sys.argv[1] == "set-volume":
            set_volume(sys.argv[2])
        else:
            sys.exit("Usage: status-data battery|volume|tailscale|set-volume PERCENT")
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        sys.exit(str(error))
