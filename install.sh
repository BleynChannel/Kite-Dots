#!/bin/bash

# GITHUB_USER=BleynChannel
# GITHUB_REPO=qgroundcontrol
# BRANCH=dev

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
yay -S --noconfirm pacman-contrib lightdm lightdm-gtk-greeter sway swaybg waybar mosquitto kitty

# Developer инструменты
yay -S --noconfirm fish starship neovim fastfetch btop ranger

# Шаг 3: Установка главной программы
makepkg -si --noconfirm

#OLD: Установка Kite через сборку исходного кода
# git clone --depth 1 -b $BRANCH https://github.com/$GITHUB_USER/$GITHUB_REPO.git "$PKG_DIR/kite"
# (cd "$PKG_DIR/kite" && makepkg -si --noconfirm)

# Шаг 4: Запуск сервисов
info "Запуск сервисов..."
systemctl enable lightdm.service
systemctl enable mosquitto.service
systemctl enable sway.service