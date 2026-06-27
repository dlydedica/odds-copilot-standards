---
name: server-diagnostics
description: "Use when: диагностика сервера, проверка Docker контейнеров, просмотр логов, healthcheck, SSH доступ, ресурсы сервера (disk/memory/CPU), restart сервисов, ошибки продакшена"
---

# Server Diagnostics

## Источник знаний
- `server/docker/` — compose-файлы сервисов
- `.github/workflows/deploy-odds-docker.yml` — CI/CD pipeline
- `docs/server_docs/deploy_odds_new_host_docker.md` — гайд деплоя

## Когда применять
- сервер не отвечает / контейнер упал
- нужно проверить логи контейнера
- проверить занятость диска / памяти / CPU
- перезапустить сервис после деплоя
- проверить доступность БД / Redis
- production инцидент — быстрая диагностика

## Подключение к серверу

```powershell
ssh -i ~\.ssh\id_ed25519_hostkey_141_105_64_214 -p 22 root@141.105.64.214
```

## Диагностические команды

### Общее состояние
```powershell
# Все контейнеры
docker ps --filter "name=odds-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

# Логи контейнера (last 50 строк)
docker logs <container_name> --tail 50

# Ресурсы сервера
df -h                    # диски
free -h                  # память
top -bn1 | head -20      # CPU/процессы
```

### Поиск в логах
```powershell
# Поиск ошибок
docker logs <container_name> 2>&1 | grep -i "error\|exception\|traceback"

# Логи за последние N минут
docker logs <container_name> --since 5m
```

### Перезапуск сервисов
```powershell
cd /www/parser_project/docker/<service>
docker compose down
docker compose up -d
docker compose logs --tail 30
```

### Проверка БД (через контейнер)
```powershell
docker exec <container_name> python -c "
from app.db.session import get_session
with get_session() as s:
    s.execute('SELECT 1')
    print('DB OK')
"
```

### Сеть и порты
```powershell
# Проверить что порт слушается
ss -tlnp | grep 8000

# Проверить доступность внешнего хоста
curl -I https://line-game.name/odds/health
```

## Частые проблемы

| Симптом | Диагностика | Решение |
|---------|------------|---------|
| Контейнер не стартует | `docker logs <name> --tail 50` | Проверить .env, порты, volume |
| Ошибка `Connection refused` | `ss -tlnp \| grep 8000` | Не тот порт, не стартанул |
| Диск занят на 100% | `df -h` | `docker system prune -f`, удалить старые логи |
| Redis не отвечает | `docker logs odds-redis` | `protected-mode no` в conf |
| MySQL connection error | Проверить `ODDS_DB_HOST` | Для bridge: `host.docker.internal` |

## Инварианты
- Никогда не менять production .env без backup
- Перед перезапуском: `docker ps` — убедиться что знаешь текущее состояние
- После изменений: `docker logs --tail 20` — проверить что стартануло
- Для длительных логов использовать `--tail 100`, не `less` (интерактив не поддерживается)
