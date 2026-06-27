---
name: backend-architecture
description: "Use when: архитектура backend, трёхслойная модель Route/Service/Infrastructure, UoW/Repository, SQLAlchemy, границы слоёв, server_architecture_ai_contract, структура каталогов server/"
---

# Backend Architecture

## Источник знаний
- `docs/server_docs/server_architecture_ai_contract.md` — канонический архитектурный контракт
- `docs/server_docs/route_service_boundaries.md` — детальные границы слоёв
- `docs/server_docs/server_structure.md` — структура каталогов

## Когда применять
- любые изменения в серверной части `server/`
- добавление нового роута/сервиса/репозитория
- рефакторинг с сохранением архитектурных границ
- проверка, что изменения не нарушают трёхслойную модель

## Трёхслойная архитектура

```
ROUTE Layer          → server/app/api/routes/
SERVICE Layer        → server/app/services/
INFRASTRUCTURE Layer → server/app/db/repositories/, server/app/infrastructure/
```

### Route Layer
- Парсинг HTTP (query/path/body/headers)
- `uow: SessionUoW = Depends(get_uow)` → сервис
- Никаких `select()` из SQLAlchemy, никаких прямых запросов через `session`
- HTTP-ответы, статус-коды

### Service Layer
- Бизнес-логика, оркестрация, валидация
- Конструктор: `__init__(self, uow: SessionUoW)`
- Использует Repository через UoW
- Никакого HTTP-слоя, никаких миграций

### Infrastructure Layer
- SQLAlchemy: `select()`, CRUD, фильтрация
- Repository: `BaseRepository` + специфичные методы
- UoW: `execute/scalar/scalars/add/flush/commit`
- Никакой бизнес-логики

## UoW Контракт
- В route: `uow: SessionUoW = Depends(get_uow)`
- В service: `__init__(self, uow: SessionUoW)`
- Передавать только `uow`, не `uow.session`
- Антипаттерн: `PartnerService(uow.session)`

## Канонические файлы
- `server/app/db/uow.py` — SessionUoW
- `server/app/db/repositories/base.py` — BaseRepository
- `server/app/schemas/` — Pydantic-схемы
- `server/migrations/` — Alembic
