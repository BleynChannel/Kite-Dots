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
yay -S --noconfirm pacman-contrib arc-gtk-theme papirus-icon-theme \
                   ttf-font-awesome otf-font-awesome \
                   noto-fonts-emoji noto-fonts noto-fonts-cjk noto-fonts-extra terminus-font \
                   lightdm lightdm-gtk-greeter sway swaybg waybar mosquitto kitty

# Developer инструменты
yay -S --noconfirm fish starship eza neovim fastfetch btop \
                   ranger python-pillow

# Шаг 3: Установка главной программы
makepkg -si --noconfirm

#OLD: Установка Kite через сборку исходного кода
# git clone --depth 1 -b $BRANCH https://github.com/$GITHUB_USER/$GITHUB_REPO.git "$PKG_DIR/kite"
# (cd "$PKG_DIR/kite" && makepkg -si --noconfirm)

# Шаг 4: Настройка системы
info "Запуск сервисов..."
sudo systemctl enable lightdm.service
sudo systemctl enable mosquitto.service
sudo systemctl enable sway.service

info "Настройка системы..."
sudo chsh -s /bin/fish # Developer