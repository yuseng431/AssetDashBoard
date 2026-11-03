#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 scripts/install_tools.py
source scripts/environment.sh
dotnet --version
node --version
npm --version
dotnet restore RICP.slnx
cd src/frontend
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
  # Convert initial compatible ranges to the exact versions resolved by npm.
  python3 - <<'PY'
import json
from pathlib import Path
path = Path('package.json')
package = json.loads(path.read_text())
lock = json.loads(Path('package-lock.json').read_text())
for group in ('dependencies', 'devDependencies'):
    for name in package.get(group, {}):
        package[group][name] = lock['packages']['node_modules/' + name]['version']
path.write_text(json.dumps(package, indent=2) + '\n')
PY
  npm install --package-lock-only
fi
