#!/bin/bash
set -euo pipefail

echo "========================================"
echo "🧪 Running DevOps Verification & Test Suite"
echo "========================================"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${ROOT_DIR}"

FAILED=0

run_test() {
    local test_name="$1"
    local command="$2"

    printf "  • Checking %-45s" "$test_name..."
    if eval "$command" > /dev/null 2>&1; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        FAILED=$((FAILED + 1))
    fi
}

# 1. Artifact Existence & Non-Empty Checks
run_test "public/ directory exists" "[ -d public ]"
run_test "public/index.html is non-empty" "[ -s public/index.html ]"
run_test "public/style.css is non-empty" "[ -s public/style.css ]"
run_test "public/script.js is non-empty" "[ -s public/script.js ]"
run_test "public/build-meta.json exists" "[ -s public/build-meta.json ]"

# 2. HTML Structure Validation
run_test "HTML has <!DOCTYPE html>" "grep -qi '<!doctype html>' public/index.html"
run_test "HTML has valid <title>" "grep -qi '<title>.*</title>' public/index.html"
run_test "HTML has viewport meta tag" "grep -qi 'name=\"viewport\"' public/index.html"
run_test "HTML closes </html> tag" "grep -qi '</html>' public/index.html"

# 3. JavaScript Syntax Verification
if command -v node > /dev/null 2>&1; then
    run_test "JavaScript syntax (node --check)" "node --check public/script.js"
    run_test "Build metadata is valid JSON" "node -e 'JSON.parse(require(\"fs\").readFileSync(\"public/build-meta.json\"))'"
else
    echo "  ⚠️  Node.js not found; skipping JS AST verification"
fi

# 4. Security & Secret Leakage Prevention Scan
run_test "No private keys in public/" "! grep -riE -e '-----BEGIN[ A-Z]*PRIVATE KEY' public/"
run_test "No hardcoded AWS keys in public/" "! grep -riE 'AKIA[0-9A-Z]{16}' public/"
run_test "Hardened nginx.conf exists" "[ -s nginx.conf ]"
run_test "Dockerfile exists & includes HEALTHCHECK" "grep -q 'HEALTHCHECK' Dockerfile"

echo "========================================"
if [ "$FAILED" -eq 0 ]; then
    echo "🎉 All tests passed successfully! Ready for packaging/deployment."
    echo "========================================"
    exit 0
else
    echo "💥 $FAILED test(s) failed. Fix the errors before deploying."
    echo "========================================"
    exit 1
fi