#!/bin/bash
# A script to select Hyprlock themes using rofi and apply to hyprlock.conf
# Backup is created only once, when the script is executed for the first time

THEME_DIR="$HOME/.config/hypr/hyprlock/themes"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"
BACKUP_FILE="$HYPRLOCK_CONF.bak"
ICON_DIR="$HOME/.config/hypr/scripts/icons/hyprlock.png"

# Ensure theme directory exists
if [ ! -d "$THEME_DIR" ]; then
    echo "Theme directory not found: $THEME_DIR"
    exit 1
fi

# Create a backup only if it doesn't already exist
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$HYPRLOCK_CONF" "$BACKUP_FILE"
    echo "Backup created at $BACKUP_FILE"
else
    echo "Backup already exists. Skipping backup creation."
fi

# Get list of theme files
themes=$(find "$THEME_DIR" -maxdepth 1 -type f -exec basename {} \;)

if [ -z "$themes" ]; then
    echo "No themes found in $THEME_DIR"
    exit 1
fi

# Use rofi to select a theme
selected_theme=$(echo "$themes" | rofi -dmenu -p "Select Hyprlock Theme")

# Exit if no theme was selected
if [ -z "$selected_theme" ]; then
    echo "No theme selected. Exiting."
    exit 0
fi

# Show notification with the selected theme
notify-send -i $ICON_DIR "Hyprlock Theme Selected" "Selected theme: $selected_theme"

# Build the source path to include in hyprlock.conf
theme_path="$THEME_DIR/$selected_theme"
source_line="source=$theme_path"

# Remove any previous source line referring to the theme directory
sed -i "/^source=.*hyprlock\/themes\//d" "$HYPRLOCK_CONF"

# Append the new source line to the end
echo "$source_line" >> "$HYPRLOCK_CONF"

echo "Theme '$selected_theme' has been applied to hyprlock."

