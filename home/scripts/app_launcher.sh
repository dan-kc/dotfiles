#!/bin/sh

# List of applications as a string with newline separation
apps="vivaldi\nslack\nwezterm\nanki\ndiscord\npostman\nthunderbird\nvlc\nzen\nalacritty"

# Use printf for better compatibility
selected_app=$(printf "$apps" | bemenu -i -p "Launch Application:")

# Execute if a valid selection is made
if [ -n "$selected_app" ]; then
    $selected_app &
fi
