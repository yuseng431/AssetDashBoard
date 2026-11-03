#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/environment.sh
case "${1:-}" in
  api)
    export ASPNETCORE_ENVIRONMENT=Development
    dotnet run --project src/backend/RICP.Api --no-launch-profile --urls http://127.0.0.1:5080
    ;;
  frontend)
    cd src/frontend
    npm run dev
    ;;
  *) echo 'Usage: bash scripts/dev.sh api|frontend' >&2; exit 2 ;;
esac
