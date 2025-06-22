#!/bin/sh

zenity --info --title "Outline" --text "$(pkexec /usr/local/bin/__vpn_manager connect)" --width 300 2> /dev/null
pkexec /usr/local/bin/__vpn_manager disconnect > /dev/null 2>& 1
