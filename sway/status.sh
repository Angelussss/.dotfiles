#!/bin/bash
# Enhanced status script for Swaybar with rounded boxes.
# Dependencies: pamixer, light, wireless_tools (for iwgetid), acpi, jq, swaymsg

# Output the i3bar protocol header
echo '{"version":1, "click_events":true}'
echo '['
first=1

# Helper function to wrap text in round-box glyphs using Powerline symbols.
round_box() {
    # Output the label with left/right rounded glyphs.
    # Adjust these symbols if needed.
    echo "$1"
}

while true; do
    # Volume info (requires pamixer)
    vol=$(pamixer --get-volume 2>/dev/null)
    mute=$(pamixer --get-mute 2>/dev/null)
    if [ "$mute" = "true" ]; then
        vol_label=$(round_box "Vol")
        vol_text="$vol_label Muted"
    else
        vol_label=$(round_box "Vol")
        vol_text="$vol_label ${vol}%"
    fi

    # Brightness (requires light)
    bright=$(light -G 2>/dev/null | cut -d'.' -f1)
    bright_label=$(round_box "Brt")
    bright_text="$bright_label ${bright}%"

    # Time and Day
    time_val=$(date '+%H:%M')
    day_val=$(date '+%a, %d %b')
    time_label=$(round_box "Time")
    day_label=$(round_box "Date")
    time_text="$time_label $time_val"
    day_text="$day_label $day_val"

    # Wi-Fi status and IP (requires iwgetid from wireless_tools)
    ssid=$(iwgetid -r 2>/dev/null)
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    wifi_label=$(round_box "WiFi")
    if [ -z "$ssid" ]; then
        wifi_text="$wifi_label Off"
    else
        wifi_text="$wifi_label $ssid ($ip)"
    fi

    # Battery (requires acpi)
    bat=$(acpi 2>/dev/null | grep -o '[0-9]*%' | head -1)
    bat_label=$(round_box "Bat")
    bat_text="$bat_label $bat"

    # Workspaces (using swaymsg)
    workspaces=$(swaymsg -t get_workspaces 2>/dev/null | jq -r '.[].name' | tr '\n' ' ')
    ws_label=$(round_box "WS")
    ws_text="$ws_label $workspaces"

    # Open program list (using swaymsg to get window titles)
    progs=$(swaymsg -t get_tree 2>/dev/null | jq -r '.. | objects | select(.type? == "con" and .window? != null) | .name' | sort | uniq | tr '\n' ' ')
    prog_label=$(round_box "Progs")
    prog_text="$prog_label $progs"

    # Build JSON output using jq to ensure proper escaping.
    segments=$(jq -n \
      --arg vol "$vol_text" \
      --arg bright "$bright_text" \
      --arg time "$time_text" \
      --arg day "$day_text" \
      --arg wifi "$wifi_text" \
      --arg bat "$bat_text" \
      --arg ws "$ws_text" \
      --arg prog "$prog_text" \
      '[
        {"full_text": $vol, "name": "volume"},
        {"full_text": $bright, "name": "brightness"},
        {"full_text": $time, "name": "time"},
        {"full_text": $day, "name": "day"},
        {"full_text": $wifi, "name": "wifi"},
        {"full_text": $bat, "name": "battery"},
        {"full_text": $ws, "name": "workspaces"},
        {"full_text": $prog, "name": "programs"}
      ]'
    )

    if [ $first -eq 1 ]; then
        echo "$segments"
        first=0
    else
        # Prepend a comma on subsequent iterations as required by the i3bar protocol.
        echo ",$segments"
    fi

    sleep 1
done

