#!/usr/bin/env bash

THEME="$HOME/.config/rofi/themes/Subaru/chudbaru.rasi"

rofi \
    -show drun \
    -theme "$THEME" \
    -show-icons \
    -drun-icon-theme "Papirus-Dark" \
    -display-drun "  Apps" \
    -display-run "  Run" \
    -display-filebrowser "  Files" \
    -sidebar-mode \
    -kb-mode-next "ctrl+Tab" \
    -kb-mode-previous "ctrl+shift+Tab"
