#!/bin/bash
# sync-to-project.sh — синхронизация скилов из odds-copilot-standards в проект
# Использование: bash scripts/sync-to-project.sh <project-name>
# Пример: bash scripts/sync-to-project.sh line-game

set -euo pipefail

PROJECT="${1:?Usage: $0 <project-name>}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STANDARDS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="${STANDARDS_DIR}/projects/${PROJECT}"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Ошибка: проект '$PROJECT' не найден в ${STANDARDS_DIR}/projects/"
    echo "Доступные проекты:"
    ls "${STANDARDS_DIR}/projects/"
    exit 1
fi

echo "=== Синхронизация скилов для проекта: ${PROJECT} ==="

# 1. Создать/обновить symlink на базовые инструкции
BASE_INSTRUCTIONS="${STANDARDS_DIR}/base/instructions/copilot-instructions.md"
if [ -f "$BASE_INSTRUCTIONS" ]; then
    echo "  Базовые инструкции: ${BASE_INSTRUCTIONS}"
fi

# 2. Показать какие скилы будут доступны
echo ""
echo "Базовые скилы:"
ls "${STANDARDS_DIR}/base/skills/" 2>/dev/null | sed 's/^/  /'

echo ""
echo "Проектные скилы (${PROJECT}):"
ls "${PROJECT_DIR}/skills/" 2>/dev/null | sed 's/^/  /'

echo ""
echo "=== Готово ==="
echo ""
echo "Для подключения в проекте выполните:"
echo "  git submodule add https://github.com/dlydedica/odds-copilot-standards.git .github/standards"
