export PATH=${HOME}/.local/bin:${PATH}
export PATH=/usr/local/sbin:/usr/sbin:${PATH}

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=C
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export LC_ALL="en_US.UTF-8"

# export LC_ALL=C
# export LANG=C

export CM_SELECTION="primary clipboard"
export CM_DEBUG=0
export CM_OUTPUT_CLIP=1
export CM_MAX_CLIPS=25

# turn the capslock key to be an escape key
# turn right alt key becomes the compose key
setxkbmap -option "caps:escape,compose:ralt"

# swap the apt and windows keys on my K-63 keyboard
# turn the capslock key to be an escape key
setxkbmap -device 9 -option "altwin:swap_alt_win,caps:escape"

echo "$(date) start xsesson" | tee -a "$HOME/xsession.log"
if [ "${OS}" = "FreeBSD" ]; then
  setxkbmap -option
fi

if [ "$DISPLAY" != ":0" ]; then
    xclipsync &
fi
