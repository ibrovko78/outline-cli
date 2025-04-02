#!/bin/sh

zenity --info --title "Outline" --text "$(pkexec /usr/local/bin/__vpn_manager toggle)" --width 300 2> /dev/null
