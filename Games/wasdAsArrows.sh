#!/bin/sh
xmodmap -e "keycode 44 = z"
xmodmap -e "keycode 45 = x"
xmodmap -e "keycode 25 = Up"
xmodmap -e "keycode 38 = Left"
xmodmap -e "keycode 39 = Down"
xmodmap -e "keycode 40 = Right"
cd '/home/hakuya/Games And Apps/Touhou 10 - Mountain of Faith'
wine64 ./Touhou10.exe
