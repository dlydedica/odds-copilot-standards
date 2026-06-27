---
name: qa-api-contracts
description: "Use when: проверка API контрактов, соответствие ответов сервера STAC-схеме, init/offers/feed контракты, sdui_client_implemented_contract, типы ошибок сервера, HTTP статус-коды, валидация json-schema"
---

# QA API Contracts

## Источник знаний
- `docs/server_docs/sdui_client_implemented_contract.md` — фактически реализованный контракт
- `docs/server_docs/sdui_runtime_contract_v2.md` — канонический контракт v2
- `docs/server_docs/sdui_runtime_routes_contract.md` — транспортные контракты
- `docs/server_docs/schemas/` — JSON Schema
- `server/app/schemas/sdui/mobile/` — Pydantic source of truth

## Когда применять
- проверка, что серверный ответ соответствует ожидаемой клиентом схеме
- аудит контрактов после изменений в init/offers/feed
- тестирование новых полей в mobile/init response
- проверка error-кейсов и статус-кодов
- валидация STAC-структуры в ответе

## Ключевые контракты

### 1. POST /odds/v1/mobile/init
- Status 200: `{type, schema_version, client_token, structure, color_scheme, feeds, ...}`
- Status 400: невалидный request
- Status 404: bundle_name не найден
- Status 401: невалидный client_token
- Status 429: rate-limit
- Status 503: деградация

**Что проверять:**
- `type` всегда `appConfigMobile`
- `schema_version` = `2.0.0`
- `structure` не использует `main_ui` (legacy)
- `client_token` не пустой
- `rss_feeds` и `offers_feeds` опциональны

### 2. GET /odds/v1/mobile/offers
- Status 200: `{success: true, data: {items: [...], meta: {count, empty_reason?}}}`
- Status 401: отсутствует/невалиден X-Client-Token
- Пустой offers: 200 с `items: []` и `meta.empty_reason`

**Что проверять:**
- offers возвращаются в карточном контракте `offerCard`
- Клиент НЕ должен маппить поля доменной модели в UI вручную

### 3. GET /odds/v1/feed/{feed_id}
- Status 302/307: успешный redirect на target URL
- Status 401: отсутствует X-Client-Token
- Status 403: доступ запрещён
- Status 404: feed_id не найден
- Status 429: превышен лимит

## Известные ограничения (на момент аудита)
- `grey` сценарий не активен
- `geo_mismatch` всегда false
- GeoIP lookup не подключён
- `openapi_feeds` не реализованы
- Offers: штатный пустой сценарий — 200 с `items: []`
