---
name: backend-deploy
description: "Use when: Docker деплой, GitHub Actions workflow, docker-compose, новый хост, GHCR, secrets, миграции Alembic в Docker, bridge сеть, host-gateway, persist изображений, образы контейнеров"
---

# Backend Deploy

## Источник знаний
- `docs/server_docs/deploy_odds_new_host_docker.md` — полный гайд деплоя
- `.github/workflows/deploy-odds-docker.yml` — CI/CD workflow
- `server/docker/` — docker compose файлы
- `server/docker/admin-bot/docker-compose.yml` — compose админ-бота

## Когда применять
- настройка/правка GitHub Actions workflow
- сборка и публикация Docker-образов
- развёртывание на новом хосте
- управление secrets в GitHub
- миграции БД в Docker-контуре
- проблемы с bridge/network режимом

## Процесс деплоя

### ⚠️ Жёсткое правило: деплой ТОЛЬКО через GitHub Actions
- Запрещено копировать файлы на сервер через SCP/SSH/docker cp напрямую.
- Запрещено пересоздавать контейнеры на сервере вручную (`docker run`, `docker compose up`).
- Любое изменение кода → commit + push → GitHub Actions build + deploy.
- Исключение: только если сервер не отвечает и нужно экстренно восстановить работоспособность (с последующим обязательным коммитом).

### 1. GitHub Actions Workflow
- Триггер: push в `feature/mobile-new-codex-ui-network-service` или `main`
- Шаги: checkout → build Docker image → push to GHCR → deploy via SSH
- Secrets: `SERVER_HOST_141`, `SERVER_USER_141`, `SERVER_SSH_KEY_141`, `GHCR_TOKEN`

### 2. Docker образ
- Базовый образ: `python:3.10-slim`
- Установка зависимостей из `server/requirements.txt`
- Запуск через Uvicorn (не Passenger)

### 3. Docker compose
- `server/docker-compose.newhost.yml` — шаблон для нового хоста
- `extra_hosts: host.docker.internal:host-gateway`
- `expose: 8000` без `ports`
- Внешняя сеть: `docker_default`
- Bind-mount для изображений: `${ODDS_IMAGES_HOST_DIR}` → `${ODDS_IMAGES_DIR}`

### 4. Переменные окружения
- `ODDS_DB_HOST=host.docker.internal` (bridge mode)
- `SKIP_MIGRATIONS=1` — миграции выполняются отдельным шагом
- `ODDS_DOCKER_NETWORK_MODE=bridge`
- `ODDS_REDIS_URL=redis://host.docker.internal:6379/3`

### 5. Миграции
- Выполняются отдельным контейнером (однократный job в workflow)
- В рабочем контейнере: `SKIP_MIGRATIONS=1` (предотвращает гонки при рестарте)

## Частые проблемы
- `ODDS_DB_HOST=127.0.0.1` в bridge mode → ошибка, нужно `host.docker.internal`
- `Permission denied` на bind-mount директории → создать вручную на хосте
- Пустой upstream для socat → передавать литералы без подстановки переменных в ssh
