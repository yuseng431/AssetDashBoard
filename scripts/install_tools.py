#!/usr/bin/env python3
"""Install pinned official macOS tools inside this repository; never writes shell profiles."""
import hashlib
import json
import platform
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / '.tools'


def download(url, destination):
    subprocess.run(['curl', '--fail', '--location', '--silent', '--show-error',
                    '--proto', '=https', '--proto-redir', '=https',
                    '--connect-timeout', '15', '--max-time', '600',
                    '--output', str(destination), url], check=True)


def verified_extract(archive, expected, algorithm, destination, strip=0):
    digest = hashlib.new(algorithm)
    with archive.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(chunk)
    if digest.hexdigest().lower() != expected.lower():
        raise ValueError('Archive checksum mismatch; installation stopped')
    destination.mkdir(parents=True, exist_ok=True)
    subprocess.run(['tar', '-xzf', str(archive), '-C', str(destination),
                    '--strip-components', str(strip)], check=True)


def main():
    if platform.system() != 'Darwin':
        raise ValueError('This installer is for macOS only')
    architecture = {'arm64': 'arm64', 'x86_64': 'x64'}.get(platform.machine())
    if architecture is None:
        raise ValueError('Unsupported architecture')
    node_version = (ROOT / '.node-version').read_text().strip()
    sdk_version = json.loads((ROOT / 'global.json').read_text())['sdk']['version']
    TOOLS.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='ricp-install-') as temporary:
        temp = Path(temporary)
        node_dir = TOOLS / ('node-' + node_version)
        if not (node_dir / '.complete').exists():
            filename = 'node-v{}-darwin-{}.tar.gz'.format(node_version, architecture)
            base = 'https://nodejs.org/dist/v' + node_version + '/'
            download(base + 'SHASUMS256.txt', temp / 'checksums')
            entries = dict((line.split()[1], line.split()[0])
                           for line in (temp / 'checksums').read_text().splitlines() if line.strip())
            expected = entries[filename]
            print('Downloading Node.js ' + node_version, flush=True)
            download(base + filename, temp / 'node.tar.gz')
            verified_extract(temp / 'node.tar.gz', expected, 'sha256', node_dir, 1)
            subprocess.run([str(node_dir / 'bin/node'), '--version'], check=True)
            (node_dir / '.complete').write_text(node_version + '\n')

        sdk_dir = TOOLS / ('dotnet-' + sdk_version)
        if not (sdk_dir / '.complete').exists():
            download('https://builds.dotnet.microsoft.com/dotnet/release-metadata/10.0/releases.json',
                     temp / 'dotnet.json')
            metadata = json.loads((temp / 'dotnet.json').read_text())
            candidates = [sdk for release in metadata['releases']
                          for sdk in release.get('sdks', [release.get('sdk', {})])
                          if sdk.get('version') == sdk_version]
            if not candidates:
                raise ValueError('Pinned SDK is absent from official release metadata')
            artifact = next(item for item in candidates[0]['files']
                            if item['rid'] == 'osx-' + architecture and item['url'].endswith('.tar.gz'))
            print('Downloading .NET SDK ' + sdk_version, flush=True)
            download(artifact['url'], temp / 'dotnet.tar.gz')
            verified_extract(temp / 'dotnet.tar.gz', artifact['hash'], 'sha512', sdk_dir)
            subprocess.run([str(sdk_dir / 'dotnet'), '--list-sdks'], check=True)
            (sdk_dir / '.complete').write_text(sdk_version + '\n')
    print('Installed tools in ' + str(TOOLS))


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.CalledProcessError) as error:
        print('Installation incomplete: ' + str(error), file=sys.stderr)
        sys.exit(1)
