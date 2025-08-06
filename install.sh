#!/bin/bash

PKG_DIR=$(dirname "$(realpath "$0")")
HOME_PATH=$(getent passwd "$SUDO_USER" | cut -d: -f6)
NO_INFO=false

# Function for displaying information
info() {
  if [ "$NO_INFO" = false ]; then
    echo "[INFO] $1"
  fi
}

# Function for install AUR packages
install_aur_pkgs() {
    local old_dir=$(pwd)

    for pkg_name in "$@"; do
        local pkg_dir="/tmp/$pkg_name"
        local pkg_file="$pkg_dir/$pkg_name.tar.gz"

        if [ ! -d "$pkg_dir" ]; then
            sudo -u $SUDO_USER git clone "https://aur.archlinux.org/$pkg_name.git" "$pkg_dir"
        fi

        cd "$pkg_dir"

        if [ ! -f "$pkg_file" ]; then
            if ! pacman -Sy --needed --noconfirm $(source PKGBUILD && echo "${depends[@]}"); then
                echo "Error: Failed to install dependencies for $pkg_name" >&2
                exit 1
            fi

            if ! sudo -u $SUDO_USER makepkg -f --noconfirm; then
                echo "Error: Failed to install $pkg_name" >&2
                exit 1
            fi

            if ! pacman -U --noconfirm "$(find "$pkg_dir" -maxdepth 1 -type f -name "*.pkg.tar.*" | head -n 1)"; then
                echo "Error: Failed to install $pkg_name" >&2
                exit 1
            fi
        fi

        rm -rf "$pkg_dir"
    done

    cd "$old_dir"
}

copy_config() {
    PKG_CONFIG_PATH=$1
    TARGET_CONFIG_PATH=$2

    if [ ! -d "$TARGET_CONFIG_PATH" ]; then
        if ! mkdir -p "$TARGET_CONFIG_PATH"; then
            echo "Error: Failed to create target directory $TARGET_CONFIG_PATH" >&2
            exit 1
        fi
    fi
    
    if ! rsync -av "$PKG_CONFIG_PATH/" "$TARGET_CONFIG_PATH/"; then
        echo "Error: Failed to copy configuration files" >&2
        exit 1
    fi
}

cd "$PKG_DIR"

# Step 1: Copying configuration files
info "Copying configuration files..."

copy_config "$PKG_DIR/dots/sway" "$HOME_PATH/.config/sway"
copy_config "$PKG_DIR/dots/kitty" "$HOME_PATH/.config/kitty"
copy_config "$PKG_DIR/dots/waybar" "$HOME_PATH/.config/waybar"
copy_config "$PKG_DIR/dots/ranger" "$HOME_PATH/.config/ranger"
copy_config "$PKG_DIR/dots/fastfetch" "$HOME_PATH/.config/fastfetch"
copy_config "$PKG_DIR/dots/fish" "$HOME_PATH/.config/fish"
copy_config "$PKG_DIR/dots/mosquitto" "/etc"

# Step 2: Installing programs
info "Installing programs..."
if ! pacman -S --noconfirm pacman-contrib papirus-icon-theme \
                   ttf-font-awesome otf-font-awesome ttf-cascadia-mono-nerd \
                   noto-fonts-emoji noto-fonts noto-fonts-cjk noto-fonts-extra terminus-font \
                   lightdm lightdm-gtk-greeter sway swaybg waybar mosquitto kitty; then
    echo "Error: Failed to install programs" >&2
    exit 1
fi

if ! install_aur_pkgs "arc-gtk-theme"; then
    echo "Error: Failed to install AUR packages" >&2
    exit 1
fi

# Developer tools
if ! pacman -S --noconfirm fish starship eza neovim fastfetch btop \
                   ranger python-pillow; then
    echo "Error: Failed to install developer tools" >&2
    exit 1
fi

# Step 3: Installing Kite
if ! pacman -Sy --needed --noconfirm $(source PKGBUILD && echo "${depends[@]}"); then
    echo "Error: Failed to install dependencies" >&2
    exit 1
fi

if ! sudo -u $SUDO_USER makepkg -f --noconfirm; then
    echo "Error: Failed to install Kite" >&2
    exit 1
fi

if ! pacman -U --noconfirm "$(find "$PKG_DIR" -maxdepth 1 -type f -name "*.pkg.tar.*" | head -n 1)"; then
    echo "Error: Failed to install Kite" >&2
    exit 1
fi

# Step 4: Setting up the system
info "Enabling services..."
if ! systemctl enable lightdm.service; then
    echo "Error: Failed to enable lightdm service" >&2
    exit 1
fi
if ! systemctl enable mosquitto.service; then
    echo "Error: Failed to enable mosquitto service" >&2
    exit 1
fi
# if ! systemctl enable sway.service; then
#     echo "Error: Failed to enable sway service" >&2
#     exit 1
# fi

info "Setting up the system..."
if ! chsh -s /bin/fish; then
    echo "Error: Failed to change shell" >&2
    exit 1
fi