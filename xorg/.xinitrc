xset +fp /usr/share/fonts/misc
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/TTF
xset +fp /usr/share/fonts/wenquanyi
xset +fp /usr/share/fonts/noto-cjk
xset +fp ~/.local/share/fonts
xset +fp ~/.local/share/fonts/FF\ Din
xset +fp ~/.fonts/artwiz-latin1
xset +fp ~/.fonts/efont-unicode-bdf-0.4.2
xset +fp ~/.fonts/cjk
xset +fp ~/.dotfiles/fonts/
xset fp rehash

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx-autostart

xrdb ~/.Xresources2
urxvtd -q -o -f
picom -b -e .5
mpd & mpdscribble & 
exec bspwm -c ~/.dotfiles/bspwm/bspwmrc
