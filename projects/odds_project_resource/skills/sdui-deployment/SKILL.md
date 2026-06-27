---
description: "Деплой SDUI ресурсов на сервер. Use when: деплой, публикация, развёртывание UI-ресурсов, SCP на сервер, push в main"
---

# SDUI Deployment — Деплой UI ресурсов

## Сервер

- **Хост:** `141.105.64.214`
- **Пользователь:** `root`
- **Порт:** `22`
- **SSH-ключ:** `id_ed25519_hostkey_141_105_64_214` (локально: `D:\Users\Ravil\.ssh\id_ed25519_hostkey_141_105_64_214`)
- **Целевой путь:** `/www/parser_project/resours/app/lg/v2/ui_resources/`

## Автоматический деплой (GitHub Actions)

Workflow: `.github/workflows/deploy.yml`

**Триггеры:**
- Пуш в ветку `main` с изменениями в `app/assets/ui_resources/**`
- Ручной запуск через `workflow_dispatch`

**Как работает:**
1. Checkout репозитория
2. Копирование через SCP (appleboy/scp-action):
   - Source: `app/assets/ui_resources/`
   - Target: `/www/parser_project/resours/app/lg/v2/ui_resources`
   - `strip_components: 3` — убирает `app/assets/ui_resources/`, оставляя `init_response.json`, `en/`, `ru/`, `mx/`
   - `rm: true` — очищает целевую директорию перед копированием

**Secrets (GitHub):**
- `DEPLOY_HOST` — `141.105.64.214`
- `DEPLOY_USER` — `root`
- `DEPLOY_SSH_KEY` — приватный ключ `id_ed25519_hostkey_141_105_64_214`
- `SERVER_PORT` — `22`

## Ручной деплой (через SCP)

```bash
# Копирование всех ресурсов
scp -i "D:\Users\Ravil\.ssh\id_ed25519_hostkey_141_105_64_214" -P 22 -r \
  D:\MyProject\odds_project\feature\odds_project_resource\app\assets\ui_resources\* \
  root@141.105.64.214:/www/parser_project/resours/app/lg/v2/ui_resources/

# Проверка на сервере
ssh -i "D:\Users\Ravil\.ssh\id_ed25519_hostkey_141_105_64_214" root@141.105.64.214 \
  "find /www/parser_project/resours/app/lg/v2/ui_resources -type f | sort"
```

## Проверка деплоя

```bash
# Количество файлов на сервере (должно быть 34)
ssh -i "D:\Users\Ravil\.ssh\id_ed25519_hostkey_141_105_64_214" root@141.105.64.214 \
  "find /www/parser_project/resours/app/lg/v2/ui_resources -type f | wc -l"

# Статус последнего workflow
gh run list --workflow deploy.yml --limit 3 --branch main
```

## Важные моменты

1. **Всегда проверяй пути** перед деплоем — ошибочный путь может привести к пустой директории на сервере
2. **После деплоя проверяй** количество файлов и структуру локалей
3. **Не деплой вручную** если только что был пуш — подожди завершения GitHub Actions
4. **`rm: true`** удаляет старые файлы — если в репозитории удалили файл, на сервере он тоже исчезнет
