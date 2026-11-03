import hashlib
import importlib.util
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location(
    'install_tools', Path(__file__).resolve().parents[1] / 'scripts/install_tools.py')
installer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(installer)


class IntegrityTests(unittest.TestCase):
    def test_checksum_mismatch_never_extracts(self):
        with tempfile.TemporaryDirectory() as directory:
            archive = Path(directory) / 'archive'
            archive.write_bytes(b'corrupt archive')
            destination = Path(directory) / 'installed'
            with patch.object(installer.subprocess, 'run') as run:
                with self.assertRaisesRegex(ValueError, 'checksum mismatch'):
                    installer.verified_extract(archive, '0' * 64, 'sha256', destination)
                run.assert_not_called()
            self.assertFalse(destination.exists())

    def test_verified_archive_uses_argument_list_and_requested_destination(self):
        with tempfile.TemporaryDirectory(prefix='ricp test ') as directory:
            archive = Path(directory) / 'archive'
            archive.write_bytes(b'verified test data')
            destination = Path(directory) / 'installed tools'
            expected = hashlib.sha512(archive.read_bytes()).hexdigest()
            with patch.object(installer.subprocess, 'run') as run:
                installer.verified_extract(archive, expected, 'sha512', destination, 1)
                run.assert_called_once_with(
                    ['tar', '-xzf', str(archive), '-C', str(destination),
                     '--strip-components', '1'], check=True)


if __name__ == '__main__':
    unittest.main()
