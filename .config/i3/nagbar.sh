#!/bin/sh
i3-nagbar -t warning -f "pango:Delugia Nerd Font,Font Awesome 11" -m "Do you really want to exit?" -B "    Exit " "i3-msg exit" -B "    Lock " "pkill i3-nagbar && i3lock-fancy -gf Delugia Nerd Font -- scrot" -B "   Reboot " "pkill i3-nagbar && reboot" -B "    Shutdown " "pkill i3-nagbar && shutdown -h now" 
