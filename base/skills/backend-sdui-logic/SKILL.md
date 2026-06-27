---
name: backend-sdui-logic
description: "Use when: SDUI бизнес-логика, init сборка, offers service, cloaking, feed маршрутизация, админ-панель SDUi, offer lifecycle, short links, ETL импорт, row_hash дедупликация"
---

# Backend SDUI Logic

## Источник знаний
- `docs/server_docs/sdui_business_logic.md` — бизнес-логика SDUI агрегатора
- `docs/server_docs/sdui_mobile_cloaking.md` — cloaking-правила
- `docs/server_docs/offer_extended_design.md` — extended offer модель
- `docs/server_docs/partner_method_streaming.md` — streaming импорт

## Когда применять
- реализация/правка init service и structure builder
- импорт офферов от партнёров (ETL, staging, dedup)
- cloaking-политики (white/grey/blocked + DB rules)
- feed redirect transport
- short links управление
- админ-панель SDUI-тестирования

## Ключевые потоки

### Init Flow
- `MobileInitService.execute()` → resolve app → resolve geo → policy decision → build structure
- Cloaking: `white` (полный payload) / `grey` (деградированный) / `blocked` (безопасный)
- DB rules (`is_active=true`) — дополнительный блокирующий слой над дефолтной политикой
- `InitStructureBuilder` собирает STAC-дерево с appShell-tabs

### Offers
- `OffersService` — фильтрация по app_id, geo, traffic_type, categories
- Ответ: `{success: true, data: {items: [offerCard, ...], meta: {empty_reason}}`
- Пустой offers: 200 с `items: []` и `meta.empty_reason`
- Dedup через `row_hash` (SHA256 canonical JSON)

### Feed Redirect
- `GET /odds/v1/feed/{feed_id}` с `X-Client-Token`
- 302/307 редирект на целевой RSS/OpenAPI URL
- Аналитика: `feed_redirect_requested/sent/blocked`

## Инварианты
- `grey` в схеме есть, но активной ветки в `init_service.execute()` пока нет
- `geo_mismatch` в схеме есть, но фактически не выставляется (дефолт false)
- `openapi_feeds` пока не реализованы
- Offers возвращаются уже в карточном контракте `offerCard` — клиент не маппит
