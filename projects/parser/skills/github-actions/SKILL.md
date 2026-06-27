---
name: github-actions
description: "CI/CD пайплайн проекта через GitHub Actions. Использовать для: настройки workflow, деплоя на сервер 141, сборки Docker образов, изменения pipeline, добавления шагов, secrets. Триггеры: GitHub Actions, CI/CD, workflow, pipeline, actions, деплой, сборка, ghcr."
---

# GitHub Actions — CI/CD

## Workflow

**Файл:** `.github/workflows/deploy-server-141.yml`
**Ветка:** `site/line-game/v4`

## Структура пайплайна

```
on: push (site/line-game/v4) + workflow_dispatch
  │
  ├── Job 1: detect ─── определяет какие сервисы деплоить
  │     Анализирует changed files и workflow_dispatch input
  │
  ├── Job 2: build ─── собирает Docker образы (с кэшем слоёв)
  │     Условие: если detect выставил *_rebuild = true
  │     Публикует в ghcr.io
  │
  └── Job 3: deploy ─── пуллит образы на сервере и перезапускает
        Условие: если detect выставил deploy_* = true
        SSH на сервер → docker pull → docker compose up -d
```

## Триггеры

### Push
- Ветка `site/line-game/v4`
- Пути: `containers/**`, `shared/**`, `docker/**`, `requirements*.txt`, `.github/workflows/deploy-server-141.yml`

### Workflow dispatch
Ручной запуск с выбором сервисов (fastapi/parser/control).

## Требуемые Secrets

| Secret | Назначение |
|--------|-----------|
| `SERVER_HOST_141` | IP сервера (141.105.64.214) |
| `SERVER_USER` | SSH пользователь |
| `SERVER_SSH_KEY_141` | SSH ключ |
| `PROJECT_ROOT_141` | Корень проекта на сервере (default: `/www/parser_project`) |
| `GHCR_TOKEN_PARSER_141` | GitHub PAT с правами `read:packages` |
| `TELEGRAM_BOT_TOKEN` | (optional) уведомления |
| `TELEGRAM_CHAT_ID` | (optional) уведомления |

## Concurrency

- Группа: `deploy-${{ github.ref }}`
- Отмена in-progress: `false` (не отменять текущий деплой)

## Локальная проверка

```bash
# Проверить синтаксис workflow
# (требуется act или push в ветку)
```
