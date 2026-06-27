---
name: flutter-sdui-runtime
description: "Use when: STAC runtime контракт v2, appShell структура, секции home/matches/offers/news, навигация inAppLink, UiResponse парсеры, buildAppShellPayload трансформация"
---

# Flutter SDUI Runtime Contract

## Источник знаний
- `docs/server_docs/sdui_runtime_contract_v2.md` — канонический контракт
- `docs/server_docs/sdui_runtime_routes_contract.md` — transport-детали
- `lib/features/app_shell/stac/stac_app_shell_parser.dart` — главный парсер
- `lib/features/app_shell/stac/models/app_shell_models.dart` — модели AppShellData/TabItem
- `lib/core/models/mobile_init_response_v2.dart` — трансформация init → STAC

## Когда применять
- трансформация ответа mobile/init в STAC-дерево
- разбор appShell: tabs, sections, additionalMenuItems
- работа с UiResponse (matchesUiResponse, offersUiResponse, newsUiResponse)
- inAppLinkContainer и навигация через AppShellNavigationBus
- feed_transport_mode (direct/runtime/live/fallback/local/dev)

## Ключевые моменты

### AppShellData
- Собирается из `structure` ответа init
- `MobileInitResponseV2._buildAppShellPayload()` встраивает feed-данные в секции
- `uiMode` определяет: `appShell`, `atomicStac` или `empty`

### TabItem
- Каждый tab имеет `screenType` (определяет тип секции), `sectionPath`, `feedId`, `adapterPath`
- `menuPlacement`: `bottom` или `bottom_drawer`

### Навигация
- `AppShellNavigationBus` — ValueNotifier-based шина для onTap-навигации
- `InAppLinkContainerParser` — GestureDetector, который диспатчит ссылку в шину
- `InAppNavigateActionParser` — StacActionParser для STAC-actions
- Схема ссылок: `app://inapp?tabBarId=...&topMenuId=...&itemId=...`
- `external:` префикс для внешних URL

### Feed Transport Mode
- Режим передачи данных фида: `direct` (по умолчанию), `runtime`, `live`, `fallback`, `local`, `dev`
- Определяет, откуда секция берёт данные

## Инварианты
- `part`-файлы НЕ ИСПОЛЬЗОВАТЬ — вся архитектура через import
- STAC-парсеры регистрируются в `_initializeStac()` в `main.dart`
- При падении парсинга секции — показывать `_SectionDebugView`
