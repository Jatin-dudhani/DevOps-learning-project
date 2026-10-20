# DevOps Learning Platform - Multi-API Cloud Engineering & DevSecOps Platform

[![GitHub Actions CI/CD](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD%20Passing-2088FF?logo=github-actions&logoColor=white)](https://github.com/Jatin-dudhani/DevOps-learning-project/actions)
[![Vercel Frontend](https://img.shields.io/badge/Vercel-Production%20Live-000000?logo=vercel&logoColor=white)](https://devops-learning-platform-indol.vercel.app)
[![Firebase Backend](https://img.shields.io/badge/Firebase-API%20Gateway%20Live-FFCA28?logo=firebase&logoColor=black)](https://devops-platform-8f40a.web.app)
[![Docker](https://img.shields.io/badge/Docker-Hardened%20Alpine-2496ED?logo=docker&logoColor=white)](https://hub.docker.com)
[![Nginx](https://img.shields.io/badge/Nginx-Security%20Hardened-009639?logo=nginx&logoColor=white)](https://nginx.org)
[![Security Grade](https://img.shields.io/badge/Security-A%2B%20(Zero%20Vulns)-brightgreen)](https://github.com/Jatin-dudhani/DevOps-learning-project)
[![Live APIs](https://img.shields.io/badge/Live%20APIs-OSV%20%7C%20Google%20DoH%20%7C%20GitLab%20%7C%20GitHub-purple)](https://api.osv.dev)

> 🚀 **Live Production Deployments:**
> - **Frontend (Vercel Global Edge):** [https://devops-learning-platform-indol.vercel.app](https://devops-learning-platform-indol.vercel.app)
> - **Backend Microservices (Firebase Hosting):** [https://devops-platform-8f40a.web.app](https://devops-platform-8f40a.web.app)
> - **Connected Proxy Bridge:** [https://devops-learning-platform-indol.vercel.app/api/firebase/health](https://devops-learning-platform-indol.vercel.app/api/firebase/health)
> - **Source Code & CI/CD Pipeline:** [https://github.com/Jatin-dudhani/DevOps-learning-project](https://github.com/Jatin-dudhani/DevOps-learning-project)

A comprehensive, interactive cloud-native engineering platform for **beginner to intermediate** DevOps engineers. Built with **zero hardcoded mock data**, connecting live to public APIs to teach CI/CD automation, DevSecOps vulnerability scanning, container orchestration, DNS/network engineering, and production incident response.

The platform follows a **fluid, modern architectural design** (inspired by Google Antigravity and Linear) without any neon AI or cyberpunk color grading.

---

## 🌐 Connected Live Public APIs

| API Provider | Endpoint | Real-World DevOps Functionality |
| :--- | :--- | :--- |
| **OSV.dev (Open Source Vulnerability API)** | `https://api.osv.dev/v1/query` | Live DevSecOps scanner: queries real CVE advisories, CVSS severity scores, and patch versions for Alpine, Debian, npm, PyPI, and Go packages. |
| **Google DNS-over-HTTPS (DoH)** | `https://dns.google/resolve` | Real-time DNS diagnostics: resolves `A`, `AAAA`, `CNAME`, `TXT`, `MX`, and `NS` records with live TTL values. |
| **GitLab.com Public REST API** | `https://gitlab.com/api/v4/templates/gitlab_ci_ymls` | Fetches canonical, production `.gitlab-ci.yml` pipeline templates directly from GitLab's official repository. |
| **GitHub REST API** | `https://api.github.com/repos/{owner}/{repo}` | Live repository inspector: fetches stars, forks, licenses, and recent commits across public repositories. |
| **ipify Network Telemetry** | `https://api.ipify.org?format=json` | Live client egress IP detection and round-trip network latency measurement for cloud VPC routing context. |

---

## 🏛️ System Architecture

```text
┌────────────────────────┐
│  Developer Workstation │
│  (Git Commit / Branch) │
└───────────┬────────────┘
            │ git push
            ▼
┌────────────────────────┐
│   GitLab Repository    │
│  (Protected Branches)  │
└───────────┬────────────┘
            │ Webhook Trigger
            ▼
┌─────────────────────────────────────────────────────────┐
│              GitLab CI/CD Runner Engine                 │
│                                                         │
│  ├── 1. Build Stage      (bundle assets & build-meta)   │
│  ├── 2. Test Stage       (AST syntax & assertion suite) │
│  ├── 3. Security SAST    (secret scan & umask check)    │
│  ├── 4. Docker Packaging (unprivileged alpine image)    │
│  └── 5. Deploy Stage     (atomic swap / docker on EC2)  │
└───────────┬─────────────────────────────────────────────┘
            │ Docker Push (stdin auth)
            ▼
┌────────────────────────┐
│  Docker Hub Registry   │
│  (SHA + latest tags)   │
└───────────┬────────────┘
            │ SSH Pull & Run / Atomic Swap
            ▼
┌─────────────────────────────────────────────────────────┐
│                    AWS EC2 Instance                     │
│               (Ubuntu 22.04 LTS Server)                 │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Hardened Nginx Gateway (Port 80)                  │  │
│  │ • Strict Content-Security-Policy (CSP)            │  │
│  │ • X-Frame-Options: SAMEORIGIN                     │  │
│  │ • X-Content-Type-Options: nosniff                 │  │
│  │ • Gzip compression & immutable asset caching     │  │
│  │ • /healthz probe endpoint                         │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## ☁️ Connected Multi-Cloud Infrastructure (GitHub ⇄ Vercel ⇄ Firebase)

The platform is deployed across a distributed **Tri-Cloud Enterprise Architecture**:

```text
       ┌────────────────────────────────────────────────────────┐
       │                   1. GITHUB REPOSITORY                 │
       │         https://github.com/Jatin-dudhani/DevOps...     │
       │                                                        │
       │  • Git Source Control & Automated CI/CD Workflows      │
       │  • .github/workflows/deploy.yml (Tests + SAST + Probes)│
       │  • Triggers automated pipelines on git push to main    │
       └──────────────┬──────────────────────────┬──────────────┘
                      │                          │
        Auto-Build    │                          │ Deploy Microservices
        & Edge Sync   ▼                          ▼
┌───────────────────────────────┐      ┌───────────────────────────────┐
│       2. VERCEL FRONTEND      │      │      3. FIREBASE BACKEND      │
│  https://devops-learning-...  │      │  https://devops-platform-...  │
│                               │      │                               │
│ • Global Anycast Edge CDN     │      │ • Dedicated Cloud Project     │
│ • High-performance Fluid UI  │      │ • 9 High-Throughput REST APIs │
│ • Strict Security Headers     │      │ • CORS: Access-Control: *     │
│ • Reverse Proxy Edge Rewrite: │◄────►│ • Developer API Portal & Docs │
│   /api/firebase/* ────────────┼──────┤   (/api/health, /api/sre...)  │
└───────────────────────────────┘      └───────────────────────────────┘
```

### 🔗 How All Three Platforms Are Connected:
1. **GitHub (`Source & CI/CD Pipeline`)**:
   - Manages version control, secret-hygiene linting, and automated testing via GitHub Actions.
   - On every `git push origin main`, runs `scripts/build.sh`, `scripts/test.sh`, and `scripts/verify-deployments.sh` to validate all live multi-cloud routes.
2. **Vercel (`Frontend Edge & Security Gateway`)**:
   - Serves the modern, fluid Google Antigravity-inspired web platform globally with HTTP security headers (`CSP`, `X-Frame-Options`, `HSTS`).
   - Configured via `vercel.json` with an edge proxy rewrite (`/api/firebase/:path*` ➔ `https://devops-platform-8f40a.web.app/api/:path*`), allowing the browser frontend to seamlessly consume Firebase backend services with zero CORS overhead or cold-start latency.
3. **Firebase (`Backend API & Cloud Microservices`)**:
   - Deployed on Google Cloud via Firebase project `devops-platform-8f40a` (`backend-firebase/`).
   - Powers 9 live REST microservices: Telemetry, SecOps vulnerability scanning, Network DoH resolution, Kubernetes cluster state, SRE incident response, FinOps cost modeling, Compliance auditing, and AI Copilot triage.
   - Includes an interactive Developer API Portal accessible directly at `https://devops-platform-8f40a.web.app`.

---

## 🎓 Learning Curriculum (Beginner to Intermediate)

### 🟢 Level 1: Foundations (Beginner)
1. **Module 1: Version Control & Git Workflows**
   - Commit hashing & immutability, conventional commits.
   - Trunk-Based Development vs GitFlow.
   - Rebase vs Merge mechanics.
2. **Module 2: Linux Administration & Shell Scripting**
   - POSIX permissions & octal modes (`chmod 600`, `700`, `755`).
   - `umask 077` credential protection.
   - `set -euo pipefail` script hardening and exit signal traps (`trap '...' EXIT`).

### 🟡 Level 2: Automation & Containers (Intermediate)
3. **Module 3: Docker & Containerization Deep Dive**
   - Namespaces, cgroups, and layered union filesystems.
   - Multi-stage builds: reducing image sizes from 1GB to ~23MB.
   - Running as an unprivileged non-root user (`USER nginx` / UID 10001).
   - Container readiness monitoring with `HEALTHCHECK`.
4. **Module 4: CI/CD Pipelines & Automation**
   - Directed Acyclic Graph (DAG) pipeline stages.
   - Artifacts vs runner caching.
   - Protected masked variables and secure `--password-stdin` streams.

### 🔴 Level 3: DevSecOps & Cloud Engineering (Intermediate/Advanced)
5. **Module 5: DevSecOps & Supply Chain Security**
   - Pre-deployment secret leak detection.
   - Software Composition Analysis (SCA) using the live OSV.dev API.
   - HTTP security headers (`Content-Security-Policy`, `X-Frame-Options`).
6. **Module 6: AWS EC2, VPC Networking & Deployments**
   - AWS Security Groups (inbound/outbound virtual firewalls).
   - Zero-downtime atomic release swapping in `/var/www/html/`.
   - Nginx reverse proxies, static asset caching, and `/healthz` probes.

---

## 🛠️ Multi-Page Workspaces & Feature Menu Showcase

The platform is designed with a **spacious, symmetric multi-page architecture** featuring high-level cubic-bezier entrance animations, subtle ambient glow reflections, and zero neon/cyberpunk grading.

### 🏛️ Dedicated Feature Pages:
1. **Auto-DevOps Project Generator & Architect Studio (`#/generator`)**:
   - **Multi-Stack Manifest Analyzer & Auto-Detection**: Paste any `package.json`, `requirements.txt`, `go.mod`, `pom.xml`, `Cargo.toml`, or directory tree. The engine automatically analyzes dependencies, frameworks, entrypoints, and backing databases.
   - **8 Production-Ready Automation Assets Generated**:
     1. 🐳 `Dockerfile`: Multi-stage build, minimal alpine/distroless/slim runtime, unprivileged `appuser` (UID 10001), layer caching, and `HEALTHCHECK` probe.
     2. 🐙 `docker-compose.yml`: Multi-container stack with app, database (PostgreSQL 16, Redis 7, MongoDB 7, MySQL 8) with healthchecks and persistent named volumes, plus Nginx reverse proxy on an isolated bridge network.
     3. 🚀 `.github/workflows/deploy.yml`: GitHub Actions pipeline with concurrency locks, lint/test, Trivy SAST vulnerability scan, Docker Buildx with GitHub Actions layer cache, and zero-downtime deployment with automatic rollback.
     4. 🦊 `.gitlab-ci.yml`: 5-stage GitLab CI pipeline with Kaniko rootless image build and rollback traps.
     5. ☸️ `k8s/deployment.yaml`: Production Kubernetes Deployment with rolling updates, read-only root filesystems, CPU/RAM resource quotas, liveness & readiness probes, ClusterIP Service, Ingress TLS, and HorizontalPodAutoscaler (HPA).
     6. 🛡️ `nginx.conf`: Hardened reverse proxy with rate-limiting, Gzip, SSL TLSv1.3, CSP, HSTS, X-Frame-Options, and `/healthz` internal health probe.
     7. 📜 `scripts/deploy.sh`: Atomic zero-downtime deployment script in strict POSIX bash (`set -euo pipefail`), `umask 077`, staging directory, healthcheck polling with exponential backoff, and automatic rollback on failure.
     8. ☁️ `terraform/main.tf`: Complete AWS Infrastructure as Code with VPC, public/private subnets across multiple AZs, Internet Gateway, NAT Gateway, least-privilege Security Groups, and ECS Cluster / ALB.
   - **Interactive Tabbed Artifact Studio**: View, copy, download individual files, or download `devops-init.sh` to bootstrap the full infrastructure in 1 command.
   - **Cross-Tool Ecosystem Bridges**: 1-click bridge to audit generated code in the Script Inspector, consult the DevOps AI Copilot, or load commands into the CLI Sandbox.
2. **Global Enterprise Command Palette (`Cmd + K` / `Ctrl + K`)**:
   - Instant omnibar navigation across all studios, quick generators, SRE incident drills, and cloud environment switches with keyboard navigation (`↑`, `↓`, `↵`, `esc`).
3. **Live Cloud Architecture & Topology Visualizer (`#/topology`)**:
   - **Interactive SVG Canvas**: Real-time animated packet flows connecting Anycast CDN, AWS ALB, Envoy Gateway, Microservices, Aurora Primary, Read Replicas, Kafka, and S3.
   - **Live Diagnostics Modal**: Click any node to inspect active connections, CPU/Memory telemetry, and production Kubernetes/AWS YAML specifications.
   - **Chaos Engineering & Resilience Drills**: Simulate Aurora RDS failover, Edge CDN blackouts, and pod memory spikes with real-time route reconfiguration.
4. **SRE Incident War Room & Observability Suite (`#/observability`)**:
   - **Google SRE Golden Signals Dashboard**: Real-time throughput, P99 latency, 5xx error rate, and 30-day SLO error budget meters with dynamic fluctuations.
   - **4 Production Outage Drills**: Pod OOMKilled CrashLoop, Nginx 502 Bad Gateway, Expired TLS Certificate, and Layer 7 HTTP DDoS flood.
   - **Live Container Stdout/Stderr Log Stream**: Pause, resume, filter, and clear live container logs.
   - **One-Click Automated Runbook Remediation**: Execute SRE commands to patch resource limits, scale replicas, and restore systems to nominal green.
   - **Automated SRE Post-Mortem & RCA Generator**: Generates blameless, executive-ready incident post-mortems in structured Markdown with one-click export.
5. **FinOps Cloud Cost Estimator & Infracost Calculator (`#/finops`)**:
   - **Multi-Cloud Architecture Model**: Project monthly and annual infrastructure spending across AWS, Google Cloud, and Microsoft Azure.
   - **Silicon Efficiency**: Real-time ARM64 Graviton3 vs x86_64 comparison with instant 20% discount calculation.
   - **Commitment Modeling**: On-Demand, 1-Year Savings Plan (38% off), 3-Year Savings Plan (58% off), and Spot Workloads (72% off).
   - **1-Click FinOps Optimization Engine**: Automated waste detection scan and 1-click application of high-yield architectural savings.
6. **Interactive Kubernetes Cluster & Pod Inspector (`#/k8s`)**:
   - **K9s & Lens Style Console**: Real-time cluster context, namespace filter (`production`, `ingress-nginx`, `monitoring`, `kube-system`), and pod lifecycle status.
   - **Pod Operations**: Stream live container logs, inspect formatted `kubectl describe pod` manifests with events, and trigger graceful rolling restarts.
   - **Deployment Replica Autoscaler**: Dynamically scale replica count with animated pod spawn and termination in the workloads table.
7. **SOC 2, ISO 27001 & SBOM Security Compliance Suite (`#/compliance`)**:
   - **Audit Scorecard**: Real-time compliance readiness score (96.8% Grade A+) across SOC 2 Type II, ISO/IEC 27001:2022, NIST SP 800-53, and CIS Benchmarks.
   - **Interactive Verification**: Audit individual trust controls and run full automated cloud verification sweeps.
   - **Machine-Readable SBOM Generator**: Export compliant Software Bill of Materials in CycloneDX v1.5 and SPDX v2.3 JSON formats with component hashes and licenses.
8. **Script Inspector & DevSecOps (`#/inspector`)**:
   - **Interactive Script & Config Security Inspector**: Paste Bash scripts, Dockerfiles, or CI pipelines to detect vulnerabilities, unquoted variables, and race conditions, with one-click auto-hardening.
   - **Live DevSecOps Vulnerability Scanner**: Query live CVEs via OSV.dev API with CVSS scoring across Alpine, Debian, npm, PyPI, and Go packages.
9. **DevOps AI Copilot (`#/ai`)**:
   - **Dual-Mode AI Engine**: Built-in intelligent offline DevOps reasoning engine + live Google Gemini 1.5 Flash client.
   - **Prompt Suggestion Chips**: Instant architectural triage for Nginx 502s, umask 077, multi-stage Dockerfiles, and AWS subnets.
10. **Interactive CLI & Pipeline Simulator (`#/terminal`)**:
    - **Browser-Based Linux CLI Sandbox**: Real shell environment (`ubuntu@devops-node-01:~$`) with command history (Up/Down arrow keys), `docker ps`, `umask 077`, `chmod 600`, `nginx -t`, and `curl -I`.
    - **Production CI/CD Engine & Sandbox**: 5-stage pipeline with real-time logs and 5 simulated edge-case failure modes.
11. **Cloud Networking & Container Studio (`#/network`)**:
    - **DNS-over-HTTPS & Subnet CIDR Calculator**: Google DoH DNS lookups (`A`, `AAAA`, `TXT`, `MX`) and AWS VPC CIDR subnet allocation math.
    - **Dockerfile & Compose Studio**: CIS Benchmark security linter auditing root users and healthchecks.
    - **GitLab & GitHub API Feeds**: Official template explorer and live repo inspector.
12. **DevOps Academy & Labs (`#/academy`)**:
    - **Curriculum**: 6 structured learning modules from beginner to intermediate.
    - **Incident Response Triage Lab**: Production on-call outage simulations (502, full disk, crashed daemon).
    - **Knowledge Quiz**: Assessment testing across 5 cloud domains.
    - **CLI Cheat Sheet**: Instant search and copy for verified Linux/Docker/AWS commands.

---

## 🚀 Quickstart & Local Execution

### 1. Build & Test
```bash
# Clone the repository
git clone https://github.com/Jatin-dudhani/DevOps-learning-project.git
cd DevOps-learning-project

# Run the automated build script (generates public/ and build-meta.json)
bash scripts/build.sh

# Run the automated verification test suite
bash scripts/test.sh
```

### 2. Preview Locally
```bash
# Start local preview server on port 8080
python3 -m http.server 8080 --directory public

# Open in browser:
open http://localhost:8080
```

### 3. Run via Docker
```bash
# Build production-hardened Alpine container
docker build -t devops-learning-platform:latest .

# Run container with auto-restart policy
docker run -d --name devops-app -p 8080:80 --restart unless-stopped devops-learning-platform:latest

# Verify healthcheck probe
curl -I http://localhost:8080/healthz
```

---

## 👨‍💻 Author

**Jatin Dudhani**  
B.Tech Student | DevOps & Cloud Native Engineering  
Building modern, automated, security-hardened deployment infrastructure.
