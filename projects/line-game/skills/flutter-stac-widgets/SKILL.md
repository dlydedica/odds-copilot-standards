---
name: flutter-stac-widgets
description: "Use when: STAC-виджеты, appShell scaffold, SectionHost, skeleton'ы, UiResponse, SectionMessagePlaceholder, RuntimeNetworkImage, LoadingDotsIndicator, RefreshIndicator"
---

# Flutter STAC Widgets

## Источник знаний
- `lib/features/app_shell/stac/` — все STAC-виджеты appShell
- `lib/core/widgets/` — общие виджеты (RuntimeNetworkImage, SectionMessagePlaceholder, LoadingDotsIndicator)
- `docs/server_docs/sdui_client_implemented_contract.md` — что сервер реально отдаёт

## Когда применять
- создание/правка STAC-парсеров для новых типов секций
- skeleton'ы, placeholder'ы, empty states
- карусели, списки, сетки в фидах
- интеграция RuntimeNetworkImage (SVG/raster/data URI)
- refresh-механизмы (AppRefreshIndicator, RefreshOrchestrator)

## Ключевые виджеты

### AppShell
- `_AppShellWidget` — StatefulWidget с BottomNavigationBar + IndexedStack
- Секции переключаются через `_selectedIndex`
- `_AppShellSectionHost` — хост секции: определяет тип (matches/offers/news/STAC) и рендерит
- `AppRefreshIndicator` — обёртка над `RefreshIndicator` с `InitRefreshScope`

### Placeholder'ы
- `SectionMessagePlaceholder` — универсальный: title + subtitle + action. Использует ТОЛЬКО тему, без хардкода
- `_SectionDebugView` — отладочное отображение (только в dev, для нереализованных секций)

### Loading
- `LoadingDotsIndicator` — анимированные точки (5 пульсирующих кругов)
- Skeleton'ы: `*_skeleton_part.dart` — по одному на секцию

### Image
- `RuntimeNetworkImage` — SVG + raster + data URI, с `RuntimeImageService`
- `RuntimeImageCacheManager` — через `flutter_cache_manager`

## Инварианты
- skeleton'ы в отдельных файлах, не смешивать с UI-виджетами
- Все placeholder'ы должны работать в обеих темах (light/dark)
- `SectionMessagePlaceholder.subtitle` — опционально
- `RuntimeNetworkImage` поддерживает `color` и `colorBlendMode` для tinting
