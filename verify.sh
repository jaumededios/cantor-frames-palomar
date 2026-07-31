#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" != "Linux" ]; then
  echo "Comparator requires landrun, and landrun is Linux-only." >&2
  exit 1
fi

for cmd in git go lake python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "missing required command: $cmd" >&2
    exit 1
  fi
done

PALOMAR_WORK="${COMPARATOR_WORK:-${XDG_CACHE_HOME:-$HOME/.cache}/cantor-frames-palomar}"
PALOMAR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PALOMAR_SRC="$PALOMAR_WORK/src"
PALOMAR_BIN="$PALOMAR_WORK/bin"
COMPARATOR_REV="68a064109f01c08f47c8edc9f51d6a2bbffaa188"
LEAN4EXPORT_REV="a3e35a584f59b390667db7269cd37fca8575e4bf"
LANDRUN_REV="811cfff51ceaf3d9843708aa6d22e9b84ccac8b4"

mkdir -p "$PALOMAR_SRC" "$PALOMAR_BIN"

checkout_tool() {
  local repo_url="$1"
  local repo_dir="$2"
  local revision="$3"

  if [ ! -d "$repo_dir/.git" ]; then
    git clone --filter=blob:none "$repo_url" "$repo_dir"
  fi
  git -C "$repo_dir" fetch origin "$revision"
  git -C "$repo_dir" checkout --detach "$revision"
}

checkout_tool \
  https://github.com/leanprover/comparator.git \
  "$PALOMAR_SRC/comparator" \
  "$COMPARATOR_REV"
checkout_tool \
  https://github.com/leanprover/lean4export.git \
  "$PALOMAR_SRC/lean4export" \
  "$LEAN4EXPORT_REV"

(cd "$PALOMAR_SRC/comparator" && lake build comparator)
(cd "$PALOMAR_SRC/lean4export" && lake build lean4export)

cp "$PALOMAR_SRC/comparator/.lake/build/bin/comparator" "$PALOMAR_BIN/comparator"
cp "$PALOMAR_SRC/lean4export/.lake/build/bin/lean4export" "$PALOMAR_BIN/lean4export"
GOBIN="$PALOMAR_BIN" go install "github.com/zouuup/landrun/cmd/landrun@$LANDRUN_REV"

export PATH="$PALOMAR_BIN:$PATH"
export COMPARATOR_LANDRUN="$PALOMAR_ROOT/scripts/landrun_passthrough.py"
export COMPARATOR_LEAN4EXPORT="$PALOMAR_BIN/lean4export"
export PALOMAR_LANDRUN_REAL="$PALOMAR_BIN/landrun"
lake exe cache get
lake env "$PALOMAR_BIN/comparator" comparator.json
