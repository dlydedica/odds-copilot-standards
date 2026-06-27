---
description: "Официальный Stac SDK для Flutter — Server-Driven UI фреймворк. Use when: работа с Stac SDK, понимание виджетов Stac, парсеров, инициализации, Stac Cloud, кастомных расширений"
---

# Stac Framework — Server-Driven UI for Flutter

**GitHub:** https://github.com/StacDev/stac  
**Pub.dev:** https://pub.dev/packages/stac (v1.5.0)  
**Сайт:** https://stac.dev  
**Документация:** https://docs.stac.dev  

## Что такое Stac?

**Stac** — это SDUI (Server-Driven UI) фреймворк для Flutter. Позволяет описывать UI через JSON/Dart DSL и рендерить его нативно.

### Ключевые возможности
- **Dart DSL** — UI пишется на Dart (как обычный Flutter), но компилируется в JSON через `stac build`
- **Stac Cloud** — облачный хостинг SDUI-экранов
- **90+ встроенных виджетов** — container, text, row, column, stack, scaffold, image, icon и т.д.
- **Кастомные парсеры** — регистрация своих виджетов через `StacParser`
- **Темизация** — динамическая смена темы
- **Кэширование** — встроенное с опциями networkFirst, cacheFirst
- **Навигация** — StacNavigator, диалоги, bottom sheets
- **Формы и валидация** — StacForm, StacFormValidate

## Пакеты Stac

| Пакет | Назначение |
|-------|-----------|
| `stac` | Основной фреймворк (всё включено) |
| `stac_core` | Чистый Dart — модели и интерфейсы |
| `stac_framework` | StacParser, StacActionParser для кастомных расширений |
| `stac_cli` | CLI (`stac init`, `stac build`, `stac deploy`) |
| `stac_webview` | WebView-виджет |
| `stac_logger` | Логирование |

## Инициализация Stac

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Stac.initialize(
    options: StacOptions(projectId: 'your-project-id'),
    parsers: [MyCustomWidgetParser()],        // Кастомные виджеты
    actionParsers: [MyCustomActionParser()],  // Кастомные действия
  );
  runApp(const MyApp());
}
```

## Рендеринг SDUI

### Из Stac Cloud (облако)
```dart
Stac(routeName: 'home_screen')
```

### Из JSON (локально/кастомно)
```dart
Stac.fromJson(jsonMap, context)
```

### Из сети (кастомный API)
```dart
Stac.fromNetwork(StacNetworkRequest(url: 'https://...', method: Method.get))
```

## Структура Stac DSL проекта

```
flutter_project/
├── lib/
│   ├── default_stac_options.dart   # StacOptions (projectId)
│   └── main.dart                   # Точка входа
├── stac/                           # Stac DSL виджеты
│   ├── screens/
│   │   └── home_screen.dart        # @StacScreen аннотации
│   └── hello_world.dart
├── stac/.build/                    # Сгенерированные JSON
└── pubspec.yaml
```

## Основные виджеты (type → StacWidget)

| JSON type | StacWidget | Описание |
|-----------|------------|----------|
| `scaffold` | `StacScaffold` | Материал-оболочка страницы |
| `container` | `StacContainer` | Контейнер с decoration |
| `text` | `StacText` | Текст |
| `row` | `StacRow` | Горизонтальный ряд |
| `column` | `StacColumn` | Вертикальная колонка |
| `stack` | `StacStack` | Наложение виджетов |
| `positioned` | `StacPositioned` | Позиционирование в Stack |
| `image` | `StacImage` | Изображение (network/asset/file) |
| `icon` | `StacIcon` | Material иконка |
| `padding` | `StacPadding` | Отступы |
| `sizedBox` | `StacSizedBox` | Фиксированный размер |
| `expanded` | `StacExpanded` | Расширение в Row/Column |
| `flexible` | `StacFlexible` | Гибкий размер |
| `center` | `StacCenter` | Центрирование |
| `listView` | `StacListView` | Прокручиваемый список |
| `appBar` | `StacAppBar` | Верхняя панель |
| `elevatedButton` | `StacElevatedButton` | Кнопка |
| `textField` | `StacTextField` | Поле ввода |
| `form` | `StacForm` | Форма |
| `divider` | `StacDivider` | Разделитель |
| `slider` | `StacSlider` | Слайдер |
| `switch` | `StacSwitch` | Переключатель |
| `customScrollView` | `StacCustomScrollView` | Кастомный скролл |
| `singleChildScrollView` | `StacSingleChildScrollView` | Скролл одного ребёнка |
| `backdropFilter` | `StacBackdropFilter` | Фильтр фона |
| `inkWell` | `StacInkWell` | Область с ripple-эффектом |
| `dynamicView` | `StacDynamicView` | Загрузка данных + шаблон |

## Кастомные виджеты

Модель расширяет `StacWidget`, парсер расширяет `StacParser<Model>`:

```dart
// 1. Модель
@JsonSerializable()
class StacCustomBadge extends StacWidget {
  const StacCustomBadge({required this.text, this.color});
  final String text;
  final StacColor? color;
  @override String get type => 'customBadge';
  factory StacCustomBadge.fromJson(Map<String, dynamic> json) => _$StacCustomBadgeFromJson(json);
  @override Map<String, dynamic> toJson() => _$StacCustomBadgeToJson(this);
}

// 2. Парсер
class StacCustomBadgeParser extends StacParser<StacCustomBadge> {
  const StacCustomBadgeParser();
  @override String get type => 'customBadge';
  @override StacCustomBadge getModel(Map<String, dynamic> json) => StacCustomBadge.fromJson(json);
  @override Widget parse(BuildContext context, StacCustomBadge model) {
    return Badge(label: Text(model.text), ...);
  }
}

// 3. Регистрация
await Stac.initialize(
  parsers: const [StacCustomBadgeParser()],
);
```

## Экшены (действия)

Поддерживаемые `actionType`:
- `navigate` — навигация (`routeName`, `navigationStyle`)
- `setValue` — установка значения
- `formValidate` — валидация формы
- `getFormValue` — получение значений формы
- `networkRequest` — HTTP запрос
- `multiAction` — последовательность действий
- `delayAction` — задержка

## Stac CLI

```bash
stac login                    # Авторизация в Stac Cloud
stac init                     # Инициализация проекта
stac build                    # Dart DSL → JSON
stac deploy                   # Деплой в Stac Cloud
stac project list             # Список проектов
stac skills add               # Установка скилов
```

## Рендеринг кастомный (как в odds_project)

Flutter-приложение может рендерить Stac JSON не только через Stac Cloud, но и через `Stac.fromJson()` — загружая JSON из локальных ассетов или своего сервера. Это именно то, как работает `odds_project`:
- JSON-ресурсы лежат в `app/assets/ui_resources/`
- Flutter-приложение загружает их как ассеты
- Рендерит через `Stac.fromJson(json, context)`

## Источники

- **Официальные скилы Stac:** `StacDev/stac/skills/`
- `stac-quickstart` — настройка Stac
- `stac-screen-builder` — создание экранов
- `stac-custom-extensions` — кастомные расширения
- `stac-troubleshooter` — диагностика
