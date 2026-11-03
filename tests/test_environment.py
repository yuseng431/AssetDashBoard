"""Exercise environment selection without downloading or launching real SDKs."""
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class EnvironmentTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='ricp environment ')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name).resolve()
        (self.root / 'scripts').mkdir()
        shutil.copyfile(ROOT / 'scripts/environment.sh', self.root / 'scripts/environment.sh')
        shutil.copyfile(ROOT / '.node-version', self.root / '.node-version')
        shutil.copyfile(ROOT / 'global.json', self.root / 'global.json')
        self.node = (self.root / '.node-version').read_text().strip()
        self.sdk = json.loads((self.root / 'global.json').read_text())['sdk']['version']
        self.bin = self.root / 'runner tools'
        self.bin.mkdir()
        self.tool('node', 'v' + self.node)
        self.tool('dotnet', self.sdk)

    def tool(self, name, version):
        path = self.bin / name
        path.write_text('#!/bin/sh\nprintf "%s\\n" "' + version + '"\n')
        path.chmod(0o755)

    def run_environment(self, source=None):
        env = os.environ.copy()
        env.pop('RICP_TOOL_SOURCE', None)
        if source is not None:
            env['RICP_TOOL_SOURCE'] = source
        env['PATH'] = str(self.bin) + os.pathsep + env['PATH']
        env['DOTNET_ROOT'] = str(self.root / 'runner sdk')
        # Real Python reports the shell's exported environment for assertions.
        command = '''set -e
source scripts/environment.sh
python3 -c 'import json,os; print(json.dumps(dict(os.environ)))'
'''
        return subprocess.run(['bash', '-c', command], cwd=self.root, env=env,
                              text=True, capture_output=True)

    def test_system_mode_preserves_runner_sdk_and_scopes_caches(self):
        result = self.run_environment('system')
        self.assertEqual(result.returncode, 0, result.stderr)
        env = json.loads(result.stdout)
        self.assertEqual(env['DOTNET_ROOT'], str(self.root / 'runner sdk'))
        self.assertEqual(env['NUGET_PACKAGES'], str(self.root / '.cache/nuget'))
        self.assertEqual(env['npm_config_cache'], str(self.root / '.cache/npm'))
        self.assertNotIn(str(self.root / '.tools'), env['PATH'])

    def test_system_mode_rejects_node_version_mismatch(self):
        self.tool('node', 'v0.0.0')
        result = self.run_environment('system')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Expected Node.js', result.stderr)

    def test_system_mode_rejects_sdk_version_mismatch(self):
        self.tool('dotnet', '0.0.0')
        result = self.run_environment('system')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Expected .NET SDK', result.stderr)

    def test_default_mode_requires_local_installation(self):
        result = self.run_environment()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Tools are not installed', result.stderr)

    def test_default_mode_uses_local_tools_even_if_runner_tools_exist(self):
        sdk_dir = self.root / '.tools' / ('dotnet-' + self.sdk)
        node_dir = self.root / '.tools' / ('node-' + self.node)
        for path in (sdk_dir, node_dir):
            path.mkdir(parents=True)
            (path / '.complete').touch()
        result = self.run_environment()
        self.assertEqual(result.returncode, 0, result.stderr)
        env = json.loads(result.stdout)
        self.assertEqual(env['DOTNET_ROOT'], str(sdk_dir))
        self.assertEqual(env['PATH'].split(os.pathsep)[:2], [str(node_dir / 'bin'), str(sdk_dir)])

    def test_unknown_tool_source_is_rejected(self):
        result = self.run_environment('typo')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('RICP_TOOL_SOURCE must be local or system', result.stderr)


if __name__ == '__main__':
    unittest.main()
