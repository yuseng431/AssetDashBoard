#!/usr/bin/env bash
# Source from the other scripts; no permanent PATH or shell-profile changes.
RICP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RICP_NODE_VERSION="$(cat "$RICP_ROOT/.node-version")"
RICP_SDK_VERSION="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["sdk"]["version"])' "$RICP_ROOT/global.json")"
export DOTNET_CLI_HOME="$RICP_ROOT/.cache/dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
export NUGET_PACKAGES="$RICP_ROOT/.cache/nuget"
export npm_config_cache="$RICP_ROOT/.cache/npm"
case "${RICP_TOOL_SOURCE:-local}" in
  local)
    export DOTNET_ROOT="$RICP_ROOT/.tools/dotnet-$RICP_SDK_VERSION"
    export PATH="$RICP_ROOT/.tools/node-$RICP_NODE_VERSION/bin:$DOTNET_ROOT:$PATH"
    if [[ ! -f "$DOTNET_ROOT/.complete" || ! -f "$RICP_ROOT/.tools/node-$RICP_NODE_VERSION/.complete" ]]; then
      echo 'Tools are not installed. Run: python3 scripts/install_tools.py' >&2
      return 1
    fi
    ;;
  system)
    # CI setup actions supply PATH and DOTNET_ROOT; preserve those values.
    # Fail before restore if the runner does not have the repository's pinned tools.
    if [[ "$(node --version)" != "v$RICP_NODE_VERSION" ]]; then
      echo "Expected Node.js $RICP_NODE_VERSION on PATH." >&2
      return 1
    fi
    if [[ "$(dotnet --version)" != "$RICP_SDK_VERSION" ]]; then
      echo "Expected .NET SDK $RICP_SDK_VERSION on PATH." >&2
      return 1
    fi
    ;;
  *)
    echo 'RICP_TOOL_SOURCE must be local or system.' >&2
    return 1
    ;;
esac
