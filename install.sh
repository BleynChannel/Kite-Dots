#!/bin/bash

PKG_DIR=$(dirname "$(realpath "$0")")
NO_INFO=false

# Функция для вывода информации
info() {
  if [ "$NO_INFO" = false ]; then
    echo "[INFO] $1"
  fi
}

cd "$PKG_DIR"

# Шаг 1: Копирование конфигурационных файлов
info "Копирование конфигурационных файлов..."
rsync -av "$PKG_DIR/config/" ~/.config/

# Шаг 2: Установка программ
info "Установка программ..."
yay -S --noconfirm sway waybar

# Developer инструменты
yay -S --noconfirm fish starship kitty neovim fastfetch btop ranger

# Шаг 3: Установка главной программы
makepkg -si --noconfirm