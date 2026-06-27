---
name: flutter-init-flow
description: "Use when: flow инициализации приложения, mobile/init endpoint, client_token lifecycle, appShell сборка, init→feed pipeline, авторизация, cloaking white/grey/black, runtime assignment"
---

# Flutter Init Flow

## Источник знаний
- `docs/server_docs/sdui_auth_init_feed_flow.md` — полный operational flow
- `docs/server_docs/sdui_runtime_contract_v2.md` — контракт init response
- `lib/core/services/runtime_init_service.dart` — клиентский сервис init
- `lib/core/models/mobile_init_response_v2.dart` — модель ответа

## Когда применять
При задачах, связанных с:
- первым запуском приложения и получением конфигурации с сервера
- передачей device_info, client_token, geo в запросе
- обработкой ответа mobile/init (appShell, feeds, theme)
- retry-логикой при ошибках init
- cloaking-сценариями (white/blocked)

## Ключевые точки

### 📡 Запрос
- URL: `POST /odds/v1/mobile/init`
- Payload строится в `DeviceInfoService.buildRuntimeInitPayload()`
- Обязательные поля: `bundle_name`, `version_code`, `device_info`
- Опционально: `client_token` (при повторном init), `geo`, `user_data`

### 📦 Ответ
- Модель: `MobileInitResponseV2`
- Ключевые поля: `client_token`, `structure`, `color_scheme`, `feeds`, `rss_feeds`, `offers_feeds`
- `structure` — STAC-дерево корневого UI (appShell или atomic)
- В `app.dart` ответ передаётся в `App(runtimeInit: ...)`

### 🔁 Retry-логика
- `RuntimeInitService.fetchInit()` — единая точка входа
- При ошибке: `RuntimeInitFetchResult.failure(...)` с типом ошибки
- UI слой в `_AppState._reloadInit()` повторяет запрос через `InitRefreshScope`
- Cooldown между попытками: `failureCooldown` (30s)

### 🛡️ Cloaking
- Сервер может вернуть `blocked` профиль — тогда `structure` будет пустой или минимальной
- Клиент проверяет `structure.isNotEmpty` — если пусто, показывает `SectionMessagePlaceholder`
- `RuntimeInitResult.hasRemoteMainUi` — признак наличия UI

## Инварианты
- `client_token` из первого init ОБЯЗАТЕЛЬНО передаётся в feed-запросы (через `X-Client-Token`)
- При `Locale` change происходит `_reloadInit()` (смотри `_AppState.didChangeLocales`)
- `expires_at` и `etag` пока не используются клиентом для кэширования init
