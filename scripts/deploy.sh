#!/usr/bin/env bash
set -euo pipefail

echo "[deploy] Starting deployment..."

# Env injectée par GitHub Actions
IMAGE_TAG="${GITHUB_SHA:-latest}"
DOCKER_USERNAME="${DOCKER_USERNAME:-your-docker-username}"

BACKEND_IMAGE="${DOCKER_USERNAME}/cloudnative-backend:${IMAGE_TAG}"
FRONTEND_IMAGE="${DOCKER_USERNAME}/cloudnative-frontend:${IMAGE_TAG}"

echo "[deploy] Using IMAGE_TAG=${IMAGE_TAG}"
echo "[deploy] Backend image:  ${BACKEND_IMAGE}"
echo "[deploy] Frontend image: ${FRONTEND_IMAGE}"

# 1) Arrêter les conteneurs (sans supprimer les volumes)
echo "[deploy] Stopping current stack with docker compose down..."
docker compose down

# 2) Récupérer les dernières images depuis Docker Hub
echo "[deploy] Pulling images from Docker Hub..."
docker pull "${BACKEND_IMAGE}"
docker pull "${FRONTEND_IMAGE}"

# 3) Relancer la stack avec le bon tag
echo "[deploy] Starting stack with docker compose up -d..."
export IMAGE_TAG
docker compose up -d

echo "[deploy] Deployment finished successfully."
