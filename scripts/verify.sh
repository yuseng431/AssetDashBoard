#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest discover -s tests -p 'test_*.py' -v
source scripts/environment.sh
dotnet restore RICP.slnx --locked-mode
dotnet build RICP.slnx --no-restore --configuration Release
dotnet test RICP.slnx --no-build --no-restore --configuration Release --logger trx
cd src/frontend
npm ci
npm run typecheck
npm test
npm run build
