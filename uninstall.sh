#!/bin/bash

# Функция для вывода справки
show_help() {
  cat <<EOF
Использование: $0 <категория> [опции]

Категории удаления:
  config - Удаление конфигурационных файлов
  apps - Удаление приложений
  full - Удаление системы

Опции:
  -h, --help     Показать эту справку
  --no-confirm   Пропустить подтверждение удаления
  --no-info      Отключить информационные сообщения

Примеры:
  $0 config
  $0 full --no-confirm
EOF
  exit 0
}

# Проверка аргументов
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Обработка аргументов
CATEGORY=""
NO_CONFIRM=false
NO_INFO=false

for arg in "$@"; do
  case $arg in
    -h|--help)
      show_help
      ;;
    --no-confirm)
      NO_CONFIRM=true
      ;;
    --no-info)
      NO_INFO=true
      ;;
    config|apps|full)
      CATEGORY=$arg
      ;;
    *)
      echo "Ошибка: Неизвестный аргумент '$arg'"
      show_help
      exit 1
      ;;
  esac
done

# Проверка категории
if [ -z "$CATEGORY" ]; then
  echo "Ошибка: Необходимо указать тип системы"
  show_help
  exit 1
fi

# Функция для вывода информации
info() {
  if [ "$NO_INFO" = false ]; then
    echo "[INFO] $1"
  fi
}

# Шаг 1: Проверка ID системы
info "Проверка системы..."
ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
if [[ "$ID" != *"kite"* ]]; then
  echo "Ошибка: Удаление системы Kite невозможно! Установлена другая система."
  exit 1
fi

# Шаг 2: Подтверждение удаления
if [ "$NO_CONFIRM" = false ]; then
  read -p "Вы уверены, что хотите удалить систему Kite? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Удаление отменено пользователем"
    exit 0
  fi
fi

# Функции удаления
remove_config() {
  info "Удаление конфигурационных файлов..."
  
  rm -rf ~/.config/sway
  rm -rf ~/.config/foot
  rm -rf ~/.config/kite

  info "Удаление конфигурационных файлов завершено успешно!"
}

remove_apps() {
  info "Удаление приложений..."
  
  yay -R --noconfirm sway foot
  
  info "Удаление приложений завершено успешно!"
}

remove_full() {
  info "Удаление системы..."
  remove_config
  remove_apps

  # Удаление главной программы
  # TODO: Доделать

  # Восстановление os-release
  info "Восстановление os-release..."
  sudo cp /etc/os-release.backup /etc/os-release

  info "Удаление системы Kite завершена успешно!"

  # Перезагрузка системы
  # info "Перезагрузка системы начнется через 5 секунд..."
  # sleep 5
  # sudo reboot
}

# Шаг 3: Выполнение удаления
case $CATEGORY in
  config)
    remove_config
    ;;
  apps)
    remove_apps
    ;;
  full)
    remove_full
    ;;
  *)
    echo "Ошибка: Неизвестная категория '$CATEGORY'"
    show_help
    exit 1
    ;;
esac