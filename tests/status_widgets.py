"""Run with: python3 -m unittest discover -s tests -p 'status_widgets.py'."""

import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location(
    "status", Path(__file__).resolve().parents[1] / "home/platforms/nixos/eww/status.py"
)
status = importlib.util.module_from_spec(spec)
spec.loader.exec_module(status)


class StatusWidgets(unittest.TestCase):
    def test_battery_discovery_and_missing_hardware(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.assertFalse(status.battery(root)["available"])
            supply = root / "BAT1"
            supply.mkdir()
            for name, value in {"type": "Battery", "capacity": "73", "status": "Charging"}.items():
                (supply / name).write_text(value)
            self.assertEqual(status.battery(root), {
                "available": True, "percent": 73, "status": "Charging"
            })
            (supply / "present").write_text("0")
            self.assertFalse(status.battery(root)["available"])

    def test_unreadable_battery_is_skipped(self):
        with tempfile.TemporaryDirectory() as directory:
            supply = Path(directory) / "BAT0"
            supply.mkdir()
            (supply / "type").write_text("Battery")
            self.assertFalse(status.battery(Path(directory))["available"])

    @patch.object(status, "wpctl")
    def test_volume_tracks_mute_and_caps_amplified_audio(self, wpctl):
        wpctl.return_value = "Volume: 0.42 [MUTED]\n"
        self.assertEqual(status.volume(), {"available": True, "percent": 42, "muted": True})
        wpctl.return_value = "Volume: 1.25\n"
        self.assertEqual(status.volume()["percent"], 100)
        wpctl.side_effect = subprocess.CalledProcessError(1, "wpctl")
        self.assertFalse(status.volume()["available"])

    @patch.object(status, "wpctl")
    def test_slider_sets_default_sink_and_unmutes(self, wpctl):
        status.set_volume("37.5")
        self.assertEqual(wpctl.call_args_list[0].args,
                         ("set-volume", "--limit", "1.0", "@DEFAULT_AUDIO_SINK@", "37.5%"))
        self.assertEqual(wpctl.call_args_list[1].args,
                         ("set-mute", "@DEFAULT_AUDIO_SINK@", "0"))

    @patch.object(status, "wpctl")
    def test_invalid_volume_never_reaches_audio_server(self, wpctl):
        for value in ["-1", "101", "nan", "inf", "garbage"]:
            with self.assertRaises(ValueError):
                status.set_volume(value)
        wpctl.assert_not_called()

    @patch.object(status.subprocess, "run")
    def test_tailscale_lists_self_and_all_peers_with_connection_status_and_ips(self, run):
        run.return_value.stdout = json.dumps({
            "BackendState": "Running",
            "Self": {"HostName": "plank", "DNSName": "plank.example.ts.net.",
                     "TailscaleIPs": ["100.64.0.1", "fd7a:115c:a1e0::1"]},
            "Peer": {
                "a": {"HostName": "zebra", "Online": True, "Active": False,
                      "TailscaleIPs": ["100.64.0.2", "fd7a:115c:a1e0::2"]},
                "b": {"HostName": "phone", "OS": "iOS", "Online": False, "Active": True,
                      "TailscaleIPs": ["100.64.0.3"]},
                "c": {"DNSName": "box.example.ts.net.", "Online": True,
                      "TailscaleIPs": ["100.64.0.4"]},
            },
        })
        result = status.tailscale()
        self.assertEqual(result["status"], "Connected")
        self.assertEqual(result["count"], 4)
        self.assertEqual([d["name"] for d in result["devices"]],
                         ["plank.example.ts.net", "box.example.ts.net", "phone", "zebra"])
        self.assertEqual([d["online"] for d in result["devices"]], [True, True, False, True])
        self.assertEqual(result["devices"][2]["ips"], "100.64.0.3")
        self.assertEqual(result["devices"][3]["ips"], "100.64.0.2\nfd7a:115c:a1e0::2")
        run.assert_called_once_with(
            ["tailscale", "status", "--json"], check=True,
            capture_output=True, text=True, timeout=3,
        )

    @patch.object(status.subprocess, "run")
    def test_tailscale_phone_stays_visible_when_connection_changes(self, run):
        phone = {"HostName": "localhost", "DNSName": "mobile.example.ts.net.",
                 "OS": "iOS", "TailscaleIPs": ["100.64.0.5"]}
        for online in [True, False, True]:
            run.return_value.stdout = json.dumps({
                "BackendState": "Running", "Peer": {"phone": {**phone, "Online": online}},
            })
            result = status.tailscale()
            self.assertEqual(result["count"], 1)
            self.assertEqual(result["devices"], [{
                "name": "mobile.example.ts.net", "ips": "100.64.0.5", "online": online,
            }])

    @patch.object(status.subprocess, "run")
    def test_tailscale_connection_states_hide_stale_peers(self, run):
        for state, message in [("Stopped", "Disconnected"), ("NeedsLogin", "Sign in to Tailscale"),
                               ("NeedsMachineAuth", "Device awaiting approval")]:
            run.return_value.stdout = json.dumps({
                "BackendState": state,
                "Peer": {"stale": {"Online": True, "HostName": "old"}},
            })
            self.assertEqual(status.tailscale(), {"status": message, "devices": [], "count": 0})

    @patch.object(status.subprocess, "run")
    def test_tailscale_empty_and_unavailable(self, run):
        run.return_value.stdout = '{"BackendState":"Running","Self":null,"Peer":null}'
        self.assertEqual(status.tailscale(), {"status": "Connected", "devices": [], "count": 0})
        for output in ["invalid json", "null"]:
            run.return_value.stdout = output
            self.assertEqual(status.tailscale()["status"], "Tailscale unavailable")
        for error in [FileNotFoundError(), subprocess.TimeoutExpired("tailscale", 3),
                      subprocess.CalledProcessError(1, "tailscale")]:
            run.side_effect = error
            self.assertEqual(status.tailscale()["status"], "Tailscale unavailable")
