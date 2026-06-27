---
name: server-security
description: "Use when: проверка безопасности сервера, UFW, Redis, MySQL, Docker изоляция, SSH, fail2ban, compliance-скрипты, server_security_contract"
---

# Server Security Contract

## Источник знаний
- `docs/server_docs/server_security_contract.md` — полный контракт безопасности

## Когда применять
- проверка/настройка UFW правил
- настройка Redis (protected-mode, bind, UFW)
- настройка MySQL (bind-address, пользователи)
- Docker socket permissions
- публикация портов контейнеров
- изоляция Docker сетей
- SSH конфигурация и fail2ban
- compliance-проверка при деплое

## Ключевые требования (REQ-SEC)

### Сеть (UFW)
- `ufw default deny incoming/routed`, `allow outgoing`
- Открывать только минимальные source-сети, не Anywhere
- Whitelist: 22/tcp (SSH), 80/tcp (HTTP), 443/tcp (HTTPS), 6379/tcp (Redis для Docker bridge)

### Redis
- `bind 127.0.0.1 -::1`, `protected-mode no`
- UFW ограничивает доступ к Redis только Docker bridge сетями
- Пароль (если нужен) — минимум 32 символа, только в .env

### MySQL
- `bind-address = 127.0.0.1`
- Доступ только через `host.docker.internal:3306`
- Отдельные учётные записи для каждого проекта

### Docker
- Docker socket (`/var/run/docker.sock`) — права `srw-rw----`, владелец `root:docker`
- Монтирование socket в контейнеры — только по согласованию
- **Только `line-game-nginx` публикует порты (80/443)**
- Каждый проект в своей bridge-сети (`<project>-net`)
- Межпроектная связь — через `docker_default`

### SSH
- `PermitRootLogin without-password`, `PasswordAuthentication no`
- Fail2ban: bantime=3600, findtime=600, maxretry=5

## Compliance-проверка
Скрипт проверки в контракте (`docs/server_docs/server_security_contract.md#81-периодичность`)
