#!/bin/bash

PKG_DIR=$(dirname "$(realpath "$0")")

# Функция для вывода информации
info() {
  if [ "$NO_INFO" = false ]; then
    echo "[INFO] $1"
  fi
}

# Шаг 1: Копирование конфигурационных файлов
info "Копирование конфигурационных файлов..."
rsync -av "$PKG_DIR/config/" ~/.config/

# Шаг 2: Установка программ
info "Установка программ..."
yay -S --noconfirm foot sway

# Шаг 3: Установка главной программы
# TODO: Доделать
