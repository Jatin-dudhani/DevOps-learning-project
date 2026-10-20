#!/bin/bash
set -euo pipefail

echo "=========================================================="
echo "🌐 Verifying Multi-Cloud Production Deployments"
echo "   Frontend: Vercel (https://devops-learning-platform-indol.vercel.app)"
echo "   Backend:  Firebase (https://devops-platform-8f40a.web.app)"
echo "=========================================================="

FAILED=0

test_url() {
    local label="$1"
    local url="$2"
    local expected_code="${3:-200}"

    printf "  • Checking %-50s" "$label..."
    local http_code
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")

    if [ "$http_code" -eq "$expected_code" ]; then
        echo "✅ PASS (HTTP $http_code)"
    else
        echo "❌ FAIL (Expected $expected_code, Got $http_code)"
        FAILED=$((FAILED + 1))
    fi
}

echo ""
echo "--- 1. Testing Vercel Frontend & Core Assets ---"
test_url "Vercel Root Page" "https://devops-learning-platform-indol.vercel.app/"
test_url "Vercel Stylesheet (style.css)" "https://devops-learning-platform-indol.vercel.app/style.css"
test_url "Vercel Application Script (script.js)" "https://devops-learning-platform-indol.vercel.app/script.js"
test_url "Vercel Build Metadata (build-meta.json)" "https://devops-learning-platform-indol.vercel.app/build-meta.json"

echo ""
echo "--- 2. Testing Firebase Backend Endpoints (Direct) ---"
test_url "Firebase API Portal Home" "https://devops-platform-8f40a.web.app/"
test_url "Firebase /api/health" "https://devops-platform-8f40a.web.app/api/health"
test_url "Firebase /api/telemetry" "https://devops-platform-8f40a.web.app/api/telemetry"
test_url "Firebase /api/secops/scan" "https://devops-platform-8f40a.web.app/api/secops/scan"
test_url "Firebase /api/network/dns" "https://devops-platform-8f40a.web.app/api/network/dns"
test_url "Firebase /api/k8s/cluster" "https://devops-platform-8f40a.web.app/api/k8s/cluster"
test_url "Firebase /api/sre/incidents" "https://devops-platform-8f40a.web.app/api/sre/incidents"
test_url "Firebase /api/finops/cost" "https://devops-platform-8f40a.web.app/api/finops/cost"
test_url "Firebase /api/compliance/audit" "https://devops-platform-8f40a.web.app/api/compliance/audit"
test_url "Firebase /api/ai/copilot" "https://devops-platform-8f40a.web.app/api/ai/copilot"

echo ""
echo "--- 3. Testing Connected Routes (Vercel Proxy -> Firebase) ---"
test_url "Vercel Proxy -> /api/firebase/health" "https://devops-learning-platform-indol.vercel.app/api/firebase/health"
test_url "Vercel Proxy -> /api/firebase/telemetry" "https://devops-learning-platform-indol.vercel.app/api/firebase/telemetry"
test_url "Vercel Proxy -> /api/firebase/k8s/cluster" "https://devops-learning-platform-indol.vercel.app/api/firebase/k8s/cluster"
test_url "Vercel Proxy -> /api/firebase/sre/incidents" "https://devops-learning-platform-indol.vercel.app/api/firebase/sre/incidents"
test_url "Vercel Proxy -> /api/firebase/compliance/audit" "https://devops-learning-platform-indol.vercel.app/api/firebase/compliance/audit"

echo ""
echo "=========================================================="
if [ "$FAILED" -eq 0 ]; then
    echo "🎉 ALL 19 MULTI-CLOUD ROUTES & APIS PASSED VERIFICATION!"
    echo "=========================================================="
    exit 0
else
    echo "💥 $FAILED check(s) failed."
    echo "=========================================================="
    exit 1
fi
