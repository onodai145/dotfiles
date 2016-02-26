# (d) is default on

# ------------------------------
# General Settings
# ------------------------------
export EDITOR=vim        # $B%(%G%#%?$r(Bvim$B$K@_Dj(B
export LANG=ja_JP.UTF-8  # $BJ8;z%3!<%I$r(BUTF-8$B$K@_Dj(B
export KCODE=u           # KCODE$B$K(BUTF-8$B$r@_Dj(B
export AUTOFEATURE=true  # autotest$B$G(Bfeature$B$rF0$+$9(B

#bindkey -e               # $B%-!<%P%$%s%I$r(Bemacs$B%b!<%I$K@_Dj(B
bindkey -v              # $B%-!<%P%$%s%I$r(Bvi$B%b!<%I$K@_Dj(B

setopt no_beep           # $B%S!<%W2;$rLD$i$5$J$$$h$&$K$9$k(B
setopt auto_cd           # $B%G%#%l%/%H%jL>$NF~NO$N$_$G0\F0$9$k(B 
setopt auto_pushd        # cd$B;~$K%G%#%l%/%H%j%9%?%C%/$K(Bpushd$B$9$k(B
setopt correct           # $B%3%^%s%I$N%9%Z%k$rD{@5$9$k(B
setopt magic_equal_subst # =$B0J9_$bJd40$9$k(B(--prefix=/usr$B$J$I(B)
setopt prompt_subst      # $B%W%m%s%W%HDj5AFb$GJQ?tCV49$d%3%^%s%ICV49$r07$&(B
setopt notify            # $B%P%C%/%0%i%&%s%I%8%g%V$N>uBVJQ2=$rB(;~Js9p$9$k(B
setopt equals            # =command$B$r(B`which command`$B$HF1$8=hM}$K$9$k(B

### Complement ###
autoload -Uz compinit; compinit -u # $BJd405!G=$rM-8z$K$9$k(B
setopt auto_list               # $BJd408uJd$r0lMw$GI=<($9$k(B(d)
setopt auto_menu               # $BJd40%-!<O"BG$GJd408uJd$r=g$KI=<($9$k(B(d)
setopt list_packed             # $BJd408uJd$r$G$-$k$@$15M$a$FI=<($9$k(B
setopt list_types              # $BJd408uJd$K%U%!%$%k$N<oN`$bI=<($9$k(B
bindkey "^[[Z" reverse-menu-complete  # Shift-Tab$B$GJd408uJd$r5U=g$9$k(B("\e[Z"$B$G$bF0:n$9$k(B)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # $BJd40;~$KBgJ8;z>.J8;z$r6hJL$7$J$$(B

### Glob ###
setopt extended_glob # $B%0%m%V5!G=$r3HD%$9$k(B
unsetopt caseglob    # $B%U%!%$%k%0%m%V$GBgJ8;z>.J8;z$r6hJL$7$J$$(B

### History ###
HISTFILE=~/.zsh_history   # $B%R%9%H%j$rJ]B8$9$k%U%!%$%k(B
HISTSIZE=10000            # $B%a%b%j$KJ]B8$5$l$k%R%9%H%j$N7o?t(B
SAVEHIST=10000            # $BJ]B8$5$l$k%R%9%H%j$N7o?t(B
setopt bang_hist          # !$B$r;H$C$?%R%9%H%jE83+$r9T$&(B(d)
setopt extended_history   # $B%R%9%H%j$K<B9T;~4V$bJ]B8$9$k(B
setopt hist_ignore_dups   # $BD>A0$HF1$8%3%^%s%I$O%R%9%H%j$KDI2C$7$J$$(B
setopt share_history      # $BB>$N%7%'%k$N%R%9%H%j$r%j%"%k%?%$%`$G6&M-$9$k(B
setopt hist_reduce_blanks # $BM>J,$J%9%Z!<%9$r:o=|$7$F%R%9%H%j$KJ]B8$9$k(B

# $B%^%C%A$7$?%3%^%s%I$N%R%9%H%j$rI=<($G$-$k$h$&$K$9$k(B
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# $B$9$Y$F$N%R%9%H%j$rI=<($9$k(B
function history-all { history -E 1 }


# ------------------------------
# Look And Feel Settings
# ------------------------------
### Ls Color ###
# $B?'$N@_Dj(B
export LSCOLORS=Exfxcxdxbxegedabagacad
# $BJd40;~$N?'$N@_Dj(B
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORS$B$H$O!)(B
export ZLS_COLORS=$LS_COLORS
# ls$B%3%^%s%I;~!"<+F0$G?'$,$D$/(B(ls -G$B$N$h$&$J$b$N!)(B)
export CLICOLOR=true
# $BJd408uJd$K?'$rIU$1$k(B
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### Prompt ###
# $B%W%m%s%W%H$K?'$rIU$1$k(B
autoload -U colors; colors
# $B0lHL%f!<%6;~(B
tmp_prompt="%{${fg[cyan]}%}%n%# %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

# root$B%f!<%6;~(B($BB@;z$K$7!"%"%s%@!<%P!<$r$D$1$k(B)
if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

PROMPT=$tmp_prompt    # $BDL>o$N%W%m%s%W%H(B
PROMPT2=$tmp_prompt2  # $B%;%+%s%@%j$N%W%m%s%W%H(B($B%3%^%s%I$,(B2$B9T0J>e$N;~$KI=<($5$l$k(B)
RPROMPT=$tmp_rprompt  # $B1&B&$N%W%m%s%W%H(B
SPROMPT=$tmp_sprompt  # $B%9%Z%kD{@5MQ%W%m%s%W%H(B
# SSH$B%m%0%$%s;~$N%W%m%s%W%H(B
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;

### Title (user@hostname) ###
case "${TERM}" in
(kterm*|xterm*|)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}\007"
  }
  ;;
esac

# ------------------------------
# Alias
# ------------------------------
alias ls='ls --color=auto'

# ------------------------------
# Windows Settings
# ------------------------------
function wincmd() {
    CMD=$1
    shift
    $CMD $* 2>&1 | iconv -f cp932 -t utf-8
}
 
alias ipconfig='wincmd ipconfig'
alias netstat='wincmd netstat'
alias netsh='wincmd netsh'
alias cscript='wincmd cscript'
alias ping='wincmd /c/Windows/system32/PING.EXE'

# ------------------------------
# tmux Settings
# ------------------------------
export TMUX_TMPDIR=/var/run/tmux
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session

