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
rsync -av "$PKG_DIR/dots/.config/" "$HOME/.config/"
rsync -av "$PKG_DIR/dots/mosquitto.conf" "/etc/mosquitto.conf"

# Шаг 2: Установка программ
info "Установка программ..."
yay -S --noconfirm sway swaybg waybar mosquitto kitty

# Developer инструменты
yay -S --noconfirm fish starship neovim fastfetch btop ranger

# Шаг 3: Установка главной программы
makepkg -si --noconfirm