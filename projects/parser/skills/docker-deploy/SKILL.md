---
name: docker-deploy
description: "Деплой Docker контейнеров проекта. Использовать для: сборки Docker образов, docker compose, SCP на сервер, проверки контейнеров, SSH на сервер 141.105.64.214. Триггеры: docker, compose, контейнер, образ, SCP, SSH, deploy, деплой, server 141."
---

# Docker деплой проекта

## Сервисы и образы

| Сервис | Образ ghcr.io | Compose файл |
|--------|--------------|--------------|
| parser | `ghcr.io/dlydedica/parser-adapters:latest` | `docker/parser/docker-compose.parser.yml` |
| control | `ghcr.io/dlydedica/parser-control:latest` | `docker/control/docker-compose.control.yml` |
| fastapi | `ghcr.io/dlydedica/parser-api:latest` | `docker/fastapi/docker-compose.fastapi.yml` |
| nginx | — | `docker/nginx/docker-compose.nginx.yml` |

## SSH

```bash
ssh -t root@141.105.64.214 -p 22 -i "D:\Users\Ravil\.ssh\id_ed25519_hostkey_141_105_64_214"
```

## Команды на сервере

```bash
# Проверка статуса
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

# Логи
docker logs -f --tail 50 parser-adapters
docker logs -f --tail 50 parser-control
docker logs -f --tail 50 parser-api

# Рестарт сервиса (только аварийно!)
docker compose -f docker/parser/docker-compose.parser.yml restart
docker compose -f docker/control/docker-compose.control.yml restart
docker compose -f docker/fastapi/docker-compose.fastapi.yml restart

# Pull нового образа
docker compose -f docker/parser/docker-compose.parser.yml pull

# Полный перезапуск с новым образом
docker compose -f docker/parser/docker-compose.parser.yml up -d --pull=always
```

## Структура на сервере

- Корень проекта: `/www/parser_project` (переменная `PROJECT_ROOT_141`)
- Env-файлы: `docker/{parser,control,fastapi}/.env`
- Логи: `logs/{parser,control,fastapi}/`
- Сеть Docker: `parser-net`, `docker_default`

## Правила

- **Prod deploy — только через git push + GitHub Actions**
- Ручной `docker compose up` — только для аварийных ситуаций
- После `git pull` на сервере нужно делать `docker compose up -d --pull=always`
- Env-файлы: каждый сервис имеет единственный `.env` в `deployment/docker/<service>/.env`
- После правок runtime кода всегда проверять логи после перезапуска
