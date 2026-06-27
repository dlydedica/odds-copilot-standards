---
name: env-setup
description: "Use when: настройка локального окружения, Python venv, Flutter SDK, зависимости pip/pub, Docker настройка, конфигурация .env, миграции Alembic, проверка toolchain"
---

# Environment Setup

## Источник знаний
- `server/requirements.txt` — Python зависимости
- `client/flutter/app_odds_new/pubspec.yaml` — Flutter зависимости
- `server/pytest.ini` — конфигурация тестов
- `.github/workflows/deploy-odds-docker.yml` — CI/CD
- `server/docker/` — compose-файлы
- `server/migrations/` — Alembic

## Когда применять
- первоначальная настройка проекта на новой машине
- установка/обновление зависимостей
- настройка Docker и docker-compose
- создание/обновление .env файлов
- запуск миграций БД
- проверка toolchain (версии Python, Flutter, Docker)

## Процесс настройки

### 1. Python backend

```powershell
cd server
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Переменные окружения для локального запуска:
- `ODDS_SKIP_INIT_DB=1` — пропустить подключение к БД при импорте
- `PYTHONPATH=server/` — для корректных импортов

### 2. Flutter клиент

```powershell
cd client/flutter/app_odds_new
flutter pub get
```

Проверка: `flutter analyze` — 0 ошибок.

### 3. Docker

```powershell
cd server/docker/odds-service
docker compose build
docker compose up -d
```

Проверка: `docker ps` — контейнеры в статусе Up.

### 4. .env файлы

Стандарт: каждый сервис имеет `.env` в своей директории docker/.
- `server/docker/odds-service/.env`
- `server/docker/admin-bot/.env`

Минимальный набор переменных:
```env
ODDS_DB_HOST=host.docker.internal
ODDS_DB_PORT=3306
ODDS_DB_NAME=odds
ODDS_DB_USER=odds_user
ODDS_DB_PASSWORD=<password>
SKIP_MIGRATIONS=1
```

### 5. Миграции Alembic

```powershell
cd server
alembic upgrade head
```

Проверка: `alembic current` — показывает последнюю миграцию.

### 6. Smoke-тесты

```powershell
$env:ODDS_SKIP_INIT_DB=1
cd server
python ../scripts/mobile_init_cloaking_check.py
python ../scripts/mobile_offers_feed_check.py
```

## Проверка toolchain

| Инструмент | Минимальная версия | Команда проверки |
|-----------|-------------------|-----------------|
| Python | 3.10 | `python --version` |
| Flutter | 3.29+ | `flutter --version` |
| Docker | 24+ | `docker --version` |
| Docker Compose | 2.24+ | `docker compose version` |

## Типовые проблемы

- **MySQL connection refused**: проверить `ODDS_DB_HOST`, для bridge mode использовать `host.docker.internal`
- **Flutter analyze ошибки**: `flutter clean && flutter pub get && flutter analyze`
- **Docker permission denied**: проверить bind-mount директории на хосте (`mkdir -p /www/parser_project/data/images`)
- **Alembic target database not found**: `alembic upgrade head` — предварительно создать БД вручную
