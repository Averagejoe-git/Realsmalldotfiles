#!/bin/bash
WALL_DIR="$HOME/Pictures/wallpapers"
ROFI_THEME="$HOME/.config/rofi/themes/Subaru/chudbaru.rasi"

while true; do
    choice=$(ls "$WALL_DIR" | rofi -dmenu -theme "$ROFI_THEME" -p "Choose Your Wallpaper!")
    [ -z "$choice" ] && break

    img="$WALL_DIR/$choice"
    confirm=$(printf "Set\nCancel" | rofi -dmenu -theme "$ROFI_THEME" -p "Apply?")

    if [[ "$confirm" == "Set" ]]; then
        swww img "$img" --transition-duration 1 --transition-type fade
        break
    fi
done
