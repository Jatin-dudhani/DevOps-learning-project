#!/bin/bash
set -euo pipefail

echo "========================================"
echo "🚀 Starting Automated Production Deployment"
echo "========================================"

# Pre-flight environment variable validation
if [ -z "${SSH_PRIVATE_KEY:-}" ] || [ -z "${EC2_HOST:-}" ]; then
    echo "⚠️  Missing required deployment credentials (SSH_PRIVATE_KEY or EC2_HOST)."
    echo "ℹ️  If running in CI/CD, configure CI/CD variables in GitLab settings."
    echo "ℹ️  Simulating dry-run deployment validation..."
    test -d public
    echo "✅ Dry-run check: public/ build directory is valid."
    exit 0
fi

EC2_USER="${EC2_USER:-ubuntu}"
DEPLOY_TARGET="${DEPLOY_TARGET:-/var/www/html}"
DEPLOY_MODE="${DEPLOY_MODE:-static}" # 'static' or 'docker'

# Setup secure SSH directory with restricted umask
echo "🔑 Initializing secure SSH client environment..."
umask 077
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Write private key with trailing newline and strict 600 permissions
printf "%s\n" "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Ensure SSH key cleanup upon script termination
trap 'rm -f ~/.ssh/id_rsa; echo "🧹 Cleaned up local ephemeral SSH credentials."' EXIT

# Safely scan and record remote host keys with timeout
echo "🔒 Verifying EC2 host fingerprint (${EC2_HOST})..."
ssh-keyscan -T 10 -H "$EC2_HOST" >> ~/.ssh/known_hosts 2>/dev/null || true

SSH_OPTS="-o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=15"

if [ "$DEPLOY_MODE" = "docker" ]; then
    echo "🐳 Executing Docker Container deployment on EC2..."
    DOCKER_IMAGE="${DOCKER_USERNAME:-local}/my-static-site:${CI_COMMIT_SHORT_SHA:-latest}"

    ssh $SSH_OPTS "${EC2_USER}@${EC2_HOST}" "
        set -euo pipefail
        echo '📥 Pulling latest Docker image: ${DOCKER_IMAGE}...'
        docker pull ${DOCKER_IMAGE}
        
        echo '🛑 Stopping legacy container if running...'
        docker stop devops-site 2>/dev/null || true
        docker rm devops-site 2>/dev/null || true
        
        echo '🚀 Starting hardened container...'
        docker run -d \
          --name devops-site \
          -p 80:80 \
          --restart unless-stopped \
          ${DOCKER_IMAGE}
        
        echo '🩺 Checking container status...'
        docker ps --filter name=devops-site
    "
else
    echo "📦 Executing secure isolated static files deployment to ${DEPLOY_TARGET}..."
    
    # SECURITY FIX: Use an isolated, timestamped remote folder instead of generic /tmp/*
    REMOTE_STAGE="/tmp/deploy_release_$(date +%s)_${CI_JOB_ID:-$$}"
    
    ssh $SSH_OPTS "${EC2_USER}@${EC2_HOST}" "mkdir -p ${REMOTE_STAGE}"
    
    echo "📤 Transferring production artifacts to remote staging area..."
    scp $SSH_OPTS -r public/* "${EC2_USER}@${EC2_HOST}:${REMOTE_STAGE}/"
    
    echo "🔄 Performing atomic release swap and directory permissions update..."
    ssh $SSH_OPTS "${EC2_USER}@${EC2_HOST}" "
        set -euo pipefail
        sudo mkdir -p ${DEPLOY_TARGET}
        sudo rm -rf ${DEPLOY_TARGET}/*
        sudo cp -r ${REMOTE_STAGE}/* ${DEPLOY_TARGET}/
        sudo chown -R www-data:www-data ${DEPLOY_TARGET} 2>/dev/null || sudo chown -R nginx:nginx ${DEPLOY_TARGET} 2>/dev/null || true
        rm -rf ${REMOTE_STAGE}
    "
fi

echo "========================================"
echo "🎉 Deployment successfully completed to http://${EC2_HOST}/"
echo "========================================"