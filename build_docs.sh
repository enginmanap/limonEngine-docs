#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$SCRIPT_DIR/docs"
BUILD_DIR="$SCRIPT_DIR/_build/html"

export PATH="$SCRIPT_DIR/.venv/Scripts:$PATH"

echo "Building docs..."
sphinx-build -b html "$DOCS_DIR" "$BUILD_DIR"

echo ""
echo "Done. Open: file:///$BUILD_DIR/index.html"
