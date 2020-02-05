# TODO: needs to be tested
[[ $- != *i* ]] && return

# TODO: test this further
if [ "$0" = "zsh" ]; then
  export MYSHELL=zsh
elif [ "$0" = "bash" ]; then
  export MYSHELL=bash
else
  export MYSHELL=$(ps -o args= -p $$ | egrep -m 1 -o '\w{0,5}sh'| head -1)
fi

[ -z "$MYSHELL" ] && echo SHELL not found: dollar zero $0 and need to find a fix.
ln -sfn $HOME/.zshrc $HOME/.bashrc
#[[ -o interactive ]] || exit 0

if [ -f /etc/os-release ]; then
    . /etc/os-release
    export OS=$NAME
    export OS_VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    export OS=$(lsb_release -si)
    export OS_VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    export OS=$DISTRIB_ID
    export OS_VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    export OS=Debian
    export OS_VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    ...
elif [ -f /etc/redhat-release ]; then
    ...
else
  export OS=$(uname -s)
  export OS_VER=$(uname -r)
fi

export ZSH="$HOME/.oh-my-zsh"

#SPACESHIP_PROMPT_ORDER=(user host dir git)
SPACESHIP_PROMPT_ORDER=(exit_code host dir git jobs char)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL=❯
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_HG_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_ELM_SHOW=false
SPACESHIP_ELIXIR_SHOW=false
SPACESHIP_XCODE_SHOW_LOCAL=false
SPACESHIP_SWIFT_SHOW_LOCAL=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUST_SHOW=false
SPACESHIP_JULIA_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_DOCKER_CONTEXT_SHOW=false
SPACESHIP_AWS_SHOW=false
SPACESHIP_CONDA_SHOW=false
SPACESHIP_VENV_SHOW=false
SPACESHIP_PYENV_SHOW=false
SPACESHIP_DOTNET_SHOW=false
SPACESHIP_EMBER_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_JOBS_SHOW=false
SPACESHIP_DIR_PREFIX=""
#SPACESHIP_DIR_TRUNC_PREFIX=/home/
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_HOST_PREFIX="@"
SPACESHIP_HOST_SHOW=always
SPACESHIP_USER_SHOW=false
SPACESHIP_GIT_PREFIX=""

if [ "$OS" = "Darwin" ]; then
  ZSH_THEME="agnoster"
else
  ZSH_THEME="spaceship"
#  ZSH_THEME="dracula"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# ZSH_CUSTOM=/path/to/new-custom-folder

if [ ! -x "$(command -v unzip)" ]; then
  echo unzip not installed.
fi

if [ ! -x "$(command -v fc-cache)" ]; then
  echo fc-cache not installed.
fi

if [ "$MYSHELL" = "zsh" ]; then
  [ -f "$HOME/.autojump/etc/profile.d/autojump.sh" ] && source $HOME/.autojump/etc/profile.d/autojump.sh
  [ -f "$HOME/.autojump/etc/profile.d/autojump.sh" ] && autoload -U compinit && compinit -u
fi

plugins=(git zsh-autosuggestions docker zsh-syntax-highlighting autojump)

if [ "$MYSHELL" = "zsh" ]; then
  if [ -f $ZSH/oh-my-zsh.sh ]; then
    source $ZSH/oh-my-zsh.sh
  fi
fi

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# TODO: test this, not sure if/how this works
HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..)"


## TODO: do I need this?
#if [ "$OS" = "Linux Mint" ]; then
#  #export JAVA_HOME=/usr/lib/jvm/default-java/
#  [ -d "/usr/lib/jvm/java-8-openjdk-amd64" ] && export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
#fi

if [ "$OSTYPE" = "linux-gnu" ]; then
  #readlink $(readlink $(which javac)) || readlink $(which javac)
  if [ -x "$(command -v javac)" ]; then
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(readlink -f $(which javac)) || readlink -f $(which javac))))
  else
    echo install java
  fi
elif [ "$OSTYPE" = "linux-gnueabihf" ]; then
  echo JAVA_HOME
else
  echo JAVA_HOME
fi

export EDITOR=nvim
export PAGER=less

# Tells 'less' not to paginate if less than a page
export LESS="-F -X $LESS"
# TODO: will this continue to function?
export GIT_PAGER=cat git diff

# for rust
[ -s "$HOME/.cargo/env" ] && source $HOME/.cargo/env

[ -s "$HOME/.alias.env" ] && source $HOME/.alias.env

export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source $HOME/.sdkman/bin/sdkman-init.sh

if [ ! "$OS" = "FreeBSD" ]; then
  if [ -x "$(command -v chef)" ]; then
    if [ "$MYSHELL" = "zsh" ]; then
      eval "$(chef shell-init zsh)"
    else
      eval "$(chef shell-init bash)"
    fi
  fi
fi
export CHEF_USER=$(whoami)

mkdir -p ~/.fonts
ls -l ~/.fonts/{Monofur_Bold_for_Powerline.ttf,Monofur_Italic_for_Powerline.ttf,Monofur_for_Powerline.ttf} > /dev/null 2>&1
if [ $? -ne 0 ]; then
  cd ~/.fonts
  unzip ../monofur-fonts.zip
  fc-cache -vf ~/.fonts/
  cd -
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source $NVM_DIR/nvm.sh

[ ! -f "$HOME/.ssh/id_rsa.pub" ] && ssh-keygen -y -f $HOME/.ssh/id_rsa > $HOME/.ssh/id_rsa.pub

[ ! -d "$HOME/.pyenv" ] && git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
[ ! -d "$HOME/.oh-my-zsh" ] && git clone git@github.com:ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

grep -A 3 '\[branch "master"\]' $HOME/.git/config | grep 'remote = origin' > /dev/null
if [ $? -ne 0 ]; then
  git branch --set-upstream-to=origin/master master
fi

# workaround for font colors
# sed -i 's/blue $CURRENT_FG/39d $CURRENT_FG/' ~/.oh-my-zsh/themes/agnoster.zsh-theme

export TMOUT=0
export GPG_TTY=$(tty)
export PYENV_ROOT="$HOME/.pyenv"
export VAGRANT_DEFAULT_PROVIDER=kvm

# turn this on to display x on mac or windows
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  if [ -x "$(command -v neofetch)" ]; then
    neofetch
  fi
#  export DISPLAY=localhost:10.0
fi

mkdir -p $HOME/.config/compton

[ -f $HOME/.config/nvim/init.vim ] && ln -sfn $HOME/.config/nvim/init.vim $HOME/.vimrc
[ -f $HOME/.config/picom/picom.conf ] && ln -sfn $HOME/.config/picom/picom.conf $HOME/.config/compton/compton.conf
[ -f $HOME/.xinitrc ] && ln -sfn $HOME/.xinitrc $HOME/.xsession
[ -f /opt/arduino/arduino ] && ln -sfn /opt/arduino/arduino $HOME/.local/bin/arduino
[ -f /opt/intellij/bin/idea.sh ] && ln -sfn /opt/intellij/bin/idea.sh $HOME/.local/bin/idea.sh
[ -f /opt/intellij/bin/idea.sh ] && ln -sfn /opt/intellij/bin/idea.sh $HOME/.local/bin/intellij
[ -f /opt/firefox/firefox ] && ln -sfn /opt/firefox/firefox $HOME/.local/bin/firefox
[ -f /opt/vscode/bin/code ] && ln -sfn /opt/vscode/bin/code $HOME/.local/bin/code
[ -f $HOME/.tmux-rice.conf ] && ln -sfn $HOME/.tmux-rice.conf $HOME/.tmux.conf
#ln -sfn $HOME/.config/polybar/config-default $HOME/.config/polybar/config
[ -f $HOME/.config/polybar/config-master ] && ln -sfn $HOME/.config/polybar/config-master $HOME/.config/polybar/config
[ -f $HOME/.ssh/config ] && chmod 600 $HOME/.ssh/config
[ -f $HOME/.ssh/authorized_keys ] && chmod 600 $HOME/.ssh/authorized_keys
[ -f $HOME/.ssh/config ] && chmod 600 $HOME/.ssh/config
[ -f $HOME/.ssh/id_rsa ] && chmod 600 $HOME/.ssh/id_rsa
[ -d $HOME/.ssh ] && chmod 700 $HOME/.ssh
chmod 700 $HOME
[ -d $HOME/.gnupg ] && chmod 700 $HOME/.gnupg
[ -f $HOME/.ghci ] && chmod 644 $HOME/.ghci

[ -f $HOME/.zsh_history ] && sort -t ";" -k 2 -u $HOME/.zsh_history | sort -o $HOME/.zsh_history

#ln -sfn $(find /usr/local/bin/ -type f -name "perl5*" | tail -1) $HOME/.local/bin/perl

export GOPATH=$HOME/.local
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
#export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/node_modules/.bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
#export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export PATH=$HOME/.rvm/bin:$PATH
export PATH=/opt/kafka/bin:$PATH
export PATH=/opt/kotlinc/bin:$PATH
export PATH=/opt/oracle-instantclient:$PATH
export PATH="$HOME/.dynamic-colors/bin:$PATH"
[ -s "$HOME/.rvm/scripts/rvm" ] && source $HOME/.rvm/scripts/rvm
[ -s "/etc/profile.d/rvm.sh" ] && source /etc/profile.d/rvm.sh
#echo "stty -tostop"
# if [ \( "$OS" = "Linux Mint" \) -o \(  "$OS" = "Ubuntu" \) -o \(  "$OS" = "Raspbian GNU/Linux" \) ]; then
#   if [ -x "$(command -v inxi)" ]; then
#     # inxi -Sxxx #causes xmonad to hang
#     inxi
#   else
#     sudo apt install -y inxi
#     inxi -Sxxx
#   fi
# fi

if [ "$OS" = "Gentoo" ]; then
  grep $(hostname) /etc/hosts > /dev/null
  if [ $? -ne 0 ]; then
    echo "Action required: add a hostname entry to /etc/hosts to prevent issues with xauth."
  fi
fi

if [ "$MYSHELL" = "zsh" ]; then
  if [ "$OS" = "Darwin" ]; then
    #control arrow
    # bindkey "^[^[[D" backward-word
    # bindkey "^[^[[C" forward-word
    # option arrow
    bindkey "[D" backward-word
    bindkey "[C" forward-word
  else
    #control arraws trigger forward and backward by word
    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word
  fi
fi

touch $HOME/.xmonad/.active
touch $HOME/.active-wm
touch $HOME/.zshrc-work-custom
source $HOME/.zshrc-work-custom

if [ "$MYSHELL" = "bash" ]; then
  if [ "$(uname -s)" = "Darwin" ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
  elif [ "$(uname -s)" = "Linux" ]; then
    if [ -f "$HOME/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh" ]; then
      powerline-daemon -q
      POWERLINE_BASH_CONTINUATION=1
      POWERLINE_BASH_SELECT=1
      source $HOME/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
    elif [ -f "$HOME/.local/lib64/python3.6/site-packages/powerline/bindings/bash/powerline.sh" ]; then
      powerline-daemon -q
      source $HOME/.local/lib64/python3.6/site-packages/powerline/bindings/bash/powerline.sh
    elif [ -f "$HOME/.local/lib/python3.7/site-packages/powerline/bindings/shell/powerline.sh" ]; then
      powerline-daemon -q
      source $HOME/.local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
    else
      pip3 install powerline-status --user
      #source $HOME/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
    fi
  else
    echo "OS not found"
  fi
fi

#echo export W3MIMGDISPLAY_PATH=/usr/lib/python2.7/dist-packages/ranger/ext/img_display.py
#/usr/lib/w3m/w3mimgdisplay

#export XAUTHORITY=/home/henninb/.Xauthority

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

source /home/henninb/.config/broot/launcher/bash/br
