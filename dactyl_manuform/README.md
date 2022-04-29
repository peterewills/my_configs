# Flashing firmware

## Instructions

1. Open QMK Configurator in browser. Upload the current JSON from the my_configs repo. Make any changes you want. Hit compile.
3. Download the firmware, as well as the updated JSON, and a PDF printout of the keymap (for convenience)
4. Ensure the keyboard is plugged into the computer, and working normally.
5. Open QMK Toolbox. Hit “Open” and locate your hex file (the firmware).
6. Make sure the “MCU” is set to “atmega32u4”
7. Press the reset button twice for the keyboard to enter boot loader mode. If things are working, QMK Toolbox will tell you it’s recognized the device, and the “Flash” button will become available.
8. Press flash to get the firmware onto the keyboard.
9. Unplug and replug the keyboard, test to make sure it worked. NOTE: It will only have flashed the one half of the keyboard.
10. Repeat these steps for the other half of the keyboard. NOTE: When you plug in the right half of the keyboard to the computer directly, the keymap will be all weird. This is OK. Just flash as you did before.
11. Plug in the left half (with the halves connected by the TRS cable). Test the keyboard in QMK Configurator to ensure things are working as expected.
12. Update the JSON in the my_configs repo, and print out the new keymap (or whatever).
13. TADA! Now you’ve got a new keymap on your keeb.

## Notes

More on boot loader mode:

The reset button is small, and on the inside edge of the keyboard. You can use a
mini-screwdriver or a paperclip to hit it. When you’re in boot loader mode, the light on
the controller will show red and green. (Just green indicates “regular” mode). In boot
loader mode, keystrokes will not register. You can’t really see the controller lights
when the case is closed up, but you can always open the bottom of the case if you want
to be sure. To exit boot loader mode, unplug and replug the keyboard.

I sometimes have trouble getting QMK toolbox to recognize the keyboard once it goes into
bootloader mode. I've found that if I hit "Open", load the `.hex` file again, and
_then_ put the keyboard into bootloader mode, it will be recognized.

Example of the avrdude command that gets run by QMK Toolbox:

```
avrdude -p atmega32u4 -c avr109 -U flash:w:/Users/peterewills/Desktop/handwired_dactyl_manuform_4x6_handwired_dactyl_manuform_4x6_layout_mine.hex:i -P /dev/cu.usbmodem2131101 -C avrdude.conf
```

So I guess the controller is an `avr109`. I don’t know what this configuration file is
they’re using. Probably best to just use QMK toolbox to run it.
