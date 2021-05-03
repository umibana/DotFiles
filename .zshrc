# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.emacs.d/bin:$HOME/.local/bin:$HOME/.local/bin/statusbar:$HOME/.local/bin/custom:/usr/local/bin:$PATH

## Path to your oh-my-zsh installation.
export ZSH="/home/hakuya/.oh-my-zsh"
#Uncomment for pywal
#(cat ~/.cache/wal/sequences &)
#
## To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="avit"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode zsh-syntax-highlighting zsh-autosuggestions bgnotify fzf sudo)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim ~/.zshrc"
#alias ohmyzsh="nvim ~/.oh-my-zsh"
alias yt='youtube-dl --add-metadata -i'
alias yta='youtube-dl -x -f bestaudio/best' 
alias c='clear'
alias ..='cd ..'
alias ls='ls -CF --color=auto'
alias ll='ls -lisa --color=auto'
alias mkdir='mkdir -pv'
alias free='free -mt'
alias ps='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias wget='wget -c'
alias histg='history | grep'
alias myip='curl ipv4.icanhazip.com'
alias grep='grep --color=auto'
alias v='nvim'
alias syu='sudo pacman -Syu'
alias ys='yay -S'
alias ka='killall'
alias aw='anime watch'
alias sound='pavucontrol'
alias photos='sxiv -r -t -a Pictures *'
alias conf='v $HOME/.config'
alias neo='clear; neofetch'
alias laptop='ssh -X -YC4 hakuya@t480'
alias lapfiles='sshfs hakuya@t480:/home/hakuya/Music ~/T480Files/Music'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias rmp='xmodmap ~/.Xmodmap'
alias sudo='doas'
alias music='ncmpcpp-ueberzug'
alias iphone='idevicepair pair;sudo ifuse -o allow_other /mnt'
alias normify='nitrogen --set-zoom-fill /home/hakuya/Pictures/Wallpapers/y2GRLVk.jpeg'
alias tabletlap='xsetwacom --set "Wacom Intuos PT S Pen stylus" MapToOutput eDP1'
