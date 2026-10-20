#!/bin/bash
set -euo pipefail

echo "========================================"
echo "🚀 Starting DevOps Learning Hub Build"
echo "========================================"

# Determine project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${ROOT_DIR}"

# Clean existing build output to avoid stale or orphaned artifacts
echo "🧹 Cleaning previous build artifacts in public/..."
rm -rf public
mkdir -p public/images

# Verify source files exist before copying
for file in index.html style.css script.js; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required source file '$file' is missing!" >&2
        exit 1
    fi
done

# Copy core web assets
echo "📦 Copying web assets (HTML, CSS, JS)..."
cp index.html public/
cp style.css public/
cp script.js public/

# Copy images and media assets
if [ -d "images" ]; then
    echo "🖼️  Copying media assets from images/..."
    cp -r images/* public/images/ 2>/dev/null || true
fi

# Generate build metadata for CI/CD traceability
COMMIT_SHA="${CI_COMMIT_SHORT_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo 'local')}"
BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
PIPELINE_ID="${CI_PIPELINE_IID:-dev-local}"

echo "📝 Generating build metadata (SHA: ${COMMIT_SHA})..."
cat <<EOF > public/build-meta.json
{
  "version": "2.0.0",
  "commit": "${COMMIT_SHA}",
  "buildTime": "${BUILD_DATE}",
  "pipelineId": "${PIPELINE_ID}",
  "environment": "${CI_ENVIRONMENT_NAME:-production}"
}
EOF

# Calculate and report output statistics
FILE_COUNT="$(find public -type f | wc -l | tr -d ' ')"
TOTAL_SIZE="$(du -sh public | cut -f1)"

echo "✅ Build completed successfully!"
echo "   Target Directory: public/"
echo "   Total Files:      ${FILE_COUNT}"
echo "   Bundle Size:      ${TOTAL_SIZE}"
echo "========================================"