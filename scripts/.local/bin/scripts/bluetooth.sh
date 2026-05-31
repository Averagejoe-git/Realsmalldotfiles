#!/bin/bash

Discover=$(bluetoothctl show | awk '/Discoverable:/ {print $2}')
Pear=$(bluetoothctl show | awk '/Pairable:/ {print $2}')

WOFI=(rofi -dmenu -theme ~/.config/rofi/themes/Subaru/chudbaru.rasi --cache-file=/dev/null) 
ICON=~/Pictures/icons/surskit.png

#------------------------------

show_menu() {
	local -n _menu=$1
	local -n _order=$2
	local prompt=$3

	local choice
	choice=$(printf '%s\n' "${_order[@]}" | "${WOFI[@]}" --prompt "$prompt")
	[[ -z "$choice" ]] && return
	${_menu["$choice"]}
}

#------------------------------

info() {
	local host dvc percent
	host="$(bluetoothctl show | awk '/Name/ {print $2}')@$USER  Arch Linux"
	dvc=$(bluetoothctl devices Connected | awk '{print $3, $4, $5}')
	percent=$(bluetoothctl info | awk '/Battery Percentage/ {print $4}')

	local order=("System: $host" "Device: $dvc  $percent%" "Pairable: $Pear" "Discoverable: $Discover" "Back")
	declare -A check=(
		["System: $host"]="do_nothing"
		["Device: $dvc  $percent%"]="do_nothing"
		["Pairable: $Pear"]="do_nothing"
		["Discoverable: $Discover"]="do_nothing"
		["Back"]="main_menu"
	)
	show_menu check order "Info"
}

#------------------------------

adapter_settings() {
	Power=$(bluetoothctl show | awk '/Powered:/ {print $2}')

	local order=("Power: $Power" "Pairable: $Pear" "Discoverable: $Discover" "Back")
	declare -A adapter=(
		["Power: $Power"]="toggle_power"
		["Pairable: $Pear"]="toggle_pairable"
		["Discoverable: $Discover"]="toggle_discover"
		["Back"]="main_menu"
	)
	show_menu adapter order "Adapter"
}

toggle_power()    { [[ "$Power"    == "yes" ]] && bluetoothctl power off        || bluetoothctl power on;        }
toggle_pairable() { [[ "$Pear"     == "yes" ]] && bluetoothctl pairable off     || bluetoothctl pairable on;     }
toggle_discover() { [[ "$Discover" == "yes" ]] && bluetoothctl discoverable off || bluetoothctl discoverable on; }
do_nothing()      { :; }

#------------------------------

device_actions() {
	local order=("Scan" "Disconnect" "Pair" "Trust" "Untrust" "Back")
	declare -A actions=(
		["Scan"]="short_scan"
		["Disconnect"]="device_disconnect"
		["Pair"]="device_pair"
		["Trust"]="trust"
		["Untrust"]="untrust"
		["Back"]="main_menu"
	)
	show_menu actions order "Devices"
}

short_scan() {
	bluetoothctl --timeout 5 scan on

	local choice mac
	choice=$(bluetoothctl devices | "${WOFI[@]}" --prompt "Connect To:")
	mac=$(awk '{print $2}' <<< "$choice")

	if bluetoothctl connect "$mac"; then
		notify-send -i "$ICON" "Bluetooth" "Successfully Connected!"
	else
		notify-send -i "$ICON" "Bluetooth" "Failed to Connect"
	fi
}

device_disconnect() {
	local confirm
	confirm=$(printf "Yes\nNo" | "${WOFI[@]}" --prompt "Are You Sure?")
	[[ "$confirm" == "Yes" ]] && bluetoothctl --timeout 1 disconnect
}

#------------------------------

main_menu() {
	local order=("Info" "Adapter Settings" "Device Actions" "Exit")
	declare -A menu=(
		["Info"]="info"
		["Adapter Settings"]="adapter_settings"
		["Device Actions"]="device_actions"
		["Exit"]="exit 0"
	)
	show_menu menu order "Bluetooth"
}

main_menu
