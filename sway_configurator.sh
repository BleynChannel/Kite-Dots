#!/bin/bash

# Simplified script for configuring touchscreens

set -e

CONFIG_DIR="$HOME/.config/sway"
CONFIG_FILE="$CONFIG_DIR/inputs.conf"

# Create the directory
mkdir -p "$CONFIG_DIR"

# Backup
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
fi

echo "# Touchscreen configuration" > "$CONFIG_FILE"
echo "# Generated: $(date)" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

echo "Searching for touchscreens..."

# Find all touchscreens via /dev/input/by-path/
touchscreen_count=0

if [ -d "/dev/input/by-path/" ]; then
    for device in /dev/input/by-path/*-event; do
        if [ -e "$device" ]; then
            # Check device type via udevadm
            if udevadm info --query=all --name="$device" 2>/dev/null | grep -q "ID_INPUT_TOUCHSCREEN=1"; then
                echo "Found touchscreen: $device"
                
                # Get basic info
                device_info=$(udevadm info --query=all --name="$device" 2>/dev/null)
                device_name=$(echo "$device_info" | grep "NAME=" | head -1 | cut -d'=' -f2 | tr -d '"' | sed 's/ /_/g' || echo "Touchscreen")
                
                # Build an identifier
                sway_identifier="$device_name:name:$device"
                
                # Determine output
                output_name="HDMI-A-$((touchscreen_count + 1))"
                
                echo "input \"$sway_identifier\" {" >> "$CONFIG_FILE"
                echo "    map_to_output \"$output_name\"" >> "$CONFIG_FILE"
                echo "}" >> "$CONFIG_FILE"
                echo "" >> "$CONFIG_FILE"
                
                ((touchscreen_count++))
            fi
        fi
    done
fi

if [ $touchscreen_count -eq 0 ]; then
    echo "# No touchscreens found" >> "$CONFIG_FILE"
    echo "No touchscreens found"
else
    echo "Found and configured touchscreens: $touchscreen_count"
fi

echo ""
echo "Config saved to: $CONFIG_FILE"