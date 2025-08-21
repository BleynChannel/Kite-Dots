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

# Array to track processed device paths
declare -A processed_devices

# Find all touchscreens via /dev/input/by-path/
touchscreen_count=0

if [ -d "/dev/input/by-path/" ]; then
    for device in /dev/input/by-path/*-event; do
        if [ -e "$device" ]; then
            # Get the real device path to avoid duplicates
            real_path=$(readlink -f "$device")
            
            # Skip if we've already processed this device
            if [ -n "${processed_devices[$real_path]}" ]; then
                echo "Skipping duplicate device path: $device (points to $real_path)"
                continue
            fi
            
            # Check device type via udevadm
            device_info=$(udevadm info --query=all --name="$device" 2>/dev/null)
            if echo "$device_info" | grep -q "ID_INPUT_TOUCHSCREEN=1"; then
                echo "Found touchscreen: $device"
                
                # Mark this device as processed
                processed_devices["$real_path"]=1
                
                # Get basic info
                device_name=$(echo "$device_info" | grep "NAME=" | head -1 | cut -d'=' -f2 | tr -d '"' | sed 's/ /_/g' || echo "Touchscreen")
                
                # Use the most stable identifier available
                if [ -e "/dev/input/by-id/" ]; then
                    id_link=$(find /dev/input/by-id/ -lname "*$(basename $real_path)" | head -1)
                    if [ -n "$id_link" ]; then
                        identifier="$device_name:$(basename $id_link)"
                    else
                        identifier="$device_name:$(basename $device)"
                    fi
                else
                    identifier="$device_name:$(basename $device)"
                fi
                
                # Determine output
                output_name="HDMI-A-$((touchscreen_count + 1))"
                
                echo "input \"$identifier\" {" >> "$CONFIG_FILE"
                echo "    map_to_output \"$output_name\"" >> "$CONFIG_FILE"
                echo "}" >> "$CONFIG_FILE"
                echo "" >> "$CONFIG_FILE"
                
                touchscreen_count=$((touchscreen_count + 1))
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