from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]


class CleanupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        expression = r'''
          let
            flake = builtins.getFlake (toString ./.);
            pkgs = flake.inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
            fakeNode = pkgs.writeShellScriptBin "npx" ''
              printf '%s\n' "$@" > "$CLEANUP_TEST_LOG"
              exit "$CLEANUP_TEST_EXIT"
            '';
          in import ./home/platforms/darwin/simulator-cleanup.nix {
            pkgs = pkgs // { nodejs = fakeNode; };
          }
        '''
        package = subprocess.check_output(
            ['nix', 'build', '--impure', '--no-link', '--print-out-paths', '--expr', expression],
            cwd=ROOT, text=True).strip()
        cls.command = str(Path(package) / 'bin/simulator-cleanup')

    def run_cleanup(self, *args, failure=False):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'args'
            env = dict(HOME=str(Path.home()), PATH='/usr/bin:/bin',
                       CLEANUP_TEST_LOG=str(log), CLEANUP_TEST_EXIT='7' if failure else '0')
            result = subprocess.run([self.command, *args], input='', text=True,
                                    capture_output=True, env=env)
            return result, log.read_text().splitlines() if log.exists() else None

    def test_no_confirmation_does_not_stop_sessions(self):
        result, args = self.run_cleanup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(args)

    def test_confirmation_targets_t3_daemon(self):
        result, args = self.run_cleanup('--confirmed')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(args, ['--yes', 'agent-device@0.21.31', 'daemon', 'stop', '--clean',
                                '--state-dir', str(Path.home() / '.t3/userdata/device/agent-device')])

    def test_failure_is_reported(self):
        result, _ = self.run_cleanup('--confirmed', failure=True)
        self.assertEqual(result.returncode, 7)
        self.assertNotIn('Cleanup complete', result.stdout)

    def test_unknown_option_does_not_stop_sessions(self):
        result, args = self.run_cleanup('--force')
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(args)


if __name__ == '__main__':
    unittest.main()
