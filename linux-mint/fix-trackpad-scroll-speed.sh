#!/usr/bin/env bash
# Slows down trackpad scrolling on the Apple internal trackpad (bcm5974 driver)
# by increasing the libinput "Scrolling Pixel Distance" property (default 15;
# higher = more physical movement needed per scroll tick = slower scrolling).
# Run automatically at login via ~/.config/autostart/trackpad-scroll-speed.desktop.

id=$(xinput list --id-only "bcm5974")
if [ -n "$id" ]; then
  xinput set-prop "$id" "libinput Scrolling Pixel Distance" 50
fi
