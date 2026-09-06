# ============================================================
# VINICIUS — ZSH
# ============================================================


# ============================================================
# PATH
# ============================================================

typeset -U path

path=(
    "$HOME/.local/bin"
    "$HOME/.local/lib/npm/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.spicetify"
    $path
)

export PATH


# ============================================================
# EDITOR / TERMINAL
# ============================================================

export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'

export GIT_EDITOR='nvim'
export GIT_SEQUENCE_EDITOR='nvim'

export TERMINAL='kitty'


# ============================================================
# WAYLAND
# ============================================================

export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT='wayland'
export SDL_VIDEODRIVER='wayland'
export _JAVA_AWT_WM_NONREPARENTING=1


# ============================================================
# ZSH — COMPORTAMENTO
# ============================================================

setopt autocd

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

setopt no_nomatch

setopt prompt_subst
setopt interactive_comments
setopt ignore_eof


# ============================================================
# HISTÓRICO
# ============================================================

HISTFILE="$HOME/.zsh_history"

HISTSIZE=100000
SAVEHIST=50000

# Compartilha histórico entre todas as sessões.
setopt share_history

# IMPORTANTE:
# SHARE_HISTORY já cuida da gravação incremental.
# Não usamos INC_APPEND_HISTORY junto dele.

setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_fcntl_lock


# ============================================================
# COMPLETION
# ============================================================

ZCACHEDIR="$HOME/.cache/zsh"
ZCOMPDUMP="$ZCACHEDIR/.zcompdump"

mkdir -p "$ZCACHEDIR"

autoload -Uz compinit
compinit -d "$ZCOMPDUMP"

if [[ -r "$ZCOMPDUMP" &&
      ( ! -r "${ZCOMPDUMP}.zwc" ||
        "$ZCOMPDUMP" -nt "${ZCOMPDUMP}.zwc" ) ]]; then
    zcompile "$ZCOMPDUMP"
fi


# ============================================================
# COMPLETION — MÓDULO
# ============================================================

zmodload -i zsh/complist


# ============================================================
# COMPLETION — APARÊNCIA
# ============================================================

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZCACHEDIR"

zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-dirs-first true

zstyle ':completion:*' select-prompt '%SScrolling active: %p%s'


# ============================================================
# ZLE — MODO EMACS
# ============================================================
#
# Usamos o modo Emacs porque ele é a melhor base para o
# conjunto de atalhos Ctrl/Alt que estamos criando.
#

bindkey -e


# ============================================================
# ZLE — DEFINIÇÃO DE PALAVRA
# ============================================================
#
# "/" é considerado separador.
#
# Exemplo:
#
# ~/Documentos/projeto/teste.txt
#
# Ctrl+B / Ctrl+W conseguem navegar por cada componente.
#

WORDCHARS=${WORDCHARS//\/}


# ============================================================
# ZLE — NAVEGAÇÃO PRINCIPAL
# ============================================================
#
# CTRL+B
#   início da palavra anterior
#
# CTRL+W
#   início da próxima palavra
#
# CTRL+E
#   final da próxima palavra
#
# CTRL+A
#   início absoluto do comando
#
# CTRL+I
#   fim absoluto do comando
#
# CTRL+F
#   um caractere para a direita
#
# ============================================================

bindkey '^B' backward-word
bindkey '^W' forward-word
bindkey '^E' emacs-forward-word

bindkey '^A' beginning-of-line
bindkey '^I' end-of-line

bindkey '^F' forward-char


# ============================================================
# ZLE — SETAS CTRL
# ============================================================
#
# Ctrl+←
#   início da palavra anterior
#
# Ctrl+→
#   início da próxima palavra
#

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey '^[[1;5A' up-line-or-history
bindkey '^[[1;5B' down-line-or-history


# ============================================================
# ZLE — BACKSPACE / DELETE
# ============================================================
#
# BACKSPACE
#   somente 1 caractere
#
# CTRL+BACKSPACE
#   palavra anterior
#
# DELETE
#   somente 1 caractere à frente
#
# CTRL+DELETE
#   palavra seguinte
#

bindkey '^H' backward-delete-char
bindkey '^?' backward-delete-char

bindkey '^D' delete-char

bindkey '^[[127;5u' backward-kill-word
bindkey '^[[3;5~' kill-word


# ============================================================
# ZLE — APAGAR TRECHOS
# ============================================================
#
# Ctrl+U
#   apaga do cursor até o início
#
# Ctrl+K
#   apaga do cursor até o fim
#

bindkey '^U' backward-kill-line
bindkey '^K' kill-line


# ============================================================
# ZLE — OUTROS ATALHOS
# ============================================================

# Ctrl+Y
# cola o último texto apagado
bindkey '^Y' yank

# Ctrl+T
# troca os dois caracteres anteriores
bindkey '^T' transpose-chars

# Alt+Backspace
# apaga palavra anterior
bindkey '^[^?' backward-kill-word
bindkey '^[^H' backward-kill-word


# ============================================================
# ZLE — HISTÓRICO POR PREFIXO
# ============================================================

autoload -Uz \
    up-line-or-beginning-search \
    down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search


# ============================================================
# ZLE — EDITAR COMANDO NO NEOVIM
# ============================================================

autoload -Uz edit-command-line

zle -N edit-command-line

bindkey '^[e' edit-command-line


# ============================================================
# ZLE — HISTÓRICO INTERATIVO
# ============================================================

autoload -Uz history-incremental-pattern-search-backward

zle -N history-incremental-pattern-search-backward

bindkey '^R' history-incremental-pattern-search-backward


# ============================================================
# ZLE — LIMPAR TERMINAL
# ============================================================

zle_clear_screen() {
    clear
    printf '\e[3J'
    zle redisplay
}

zle -N zle_clear_screen

bindkey '^L' zle_clear_screen
bindkey '^[l' zle_clear_screen


# ============================================================
# ZLE — OUTROS
# ============================================================

autoload -Uz expand-absolute-path
zle -N expand-absolute-path

bindkey '^[/ ' expand-absolute-path 2>/dev/null || true
bindkey '^[/' expand-absolute-path

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey '^[.' copy-prev-shell-word

bindkey '^_' undo
bindkey '^[u' undo
bindkey '^[U' redo


# ============================================================
# BRACKETED PASTE
# ============================================================

autoload -Uz bracketed-paste-magic

if (( $+functions[bracketed-paste-magic] )); then
    zle -N bracketed-paste bracketed-paste-magic
    bindkey '^[[200~' bracketed-paste
fi


# ============================================================
# RUN-HELP
# ============================================================

autoload -Uz run-help

unalias run-help 2>/dev/null
alias run-help=run-help


# ============================================================
# FZF
# ============================================================

if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS='
--height=70%
--layout=reverse
--border=rounded
--info=inline
--cycle
--ansi
--pointer=▶
--marker=✓
--prompt=❯
--color=bg+:#3c3836,bg:#282828
--color=spinner:#8ec07c,hl:#83a598
--color=fg:#ebdbb2,header:#83a598
--color=info:#b8bb26,pointer:#fe8019
--color=marker:#fe8019,fg+:#fbf1c7
--color=prompt:#d79921,hl+:#83a598
'


# ============================================================
# FZF — INTEGRAÇÃO ZSH
# ============================================================

for fzf_bindings in \
    /usr/share/fzf/key-bindings.zsh \
    /usr/share/fzf/shell/key-bindings.zsh
do
    if [[ -r "$fzf_bindings" ]]; then
        source "$fzf_bindings"
        break
    fi
done

for fzf_completion in \
    /usr/share/fzf/completion.zsh \
    /usr/share/fzf/shell/completion.zsh
do
    if [[ -r "$fzf_completion" ]]; then
        source "$fzf_completion"
        break
    fi
done


# ============================================================
# FZF — HISTÓRICO
# ============================================================

if (( $+widgets[fzf-history-widget] )); then
    bindkey '^R' fzf-history-widget
fi


# ============================================================
# ZSH AUTOSUGGESTIONS
# ============================================================

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#665c54'

export ZSH_AUTOSUGGEST_STRATEGY=(
    history
    completion
)

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=80

for zsh_autosuggestions in \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
    if [[ -r "$zsh_autosuggestions" ]]; then
        source "$zsh_autosuggestions"
        break
    fi
done


# ============================================================
# ZSH SYNTAX HIGHLIGHTING
# ============================================================

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(
    main
    brackets
    pattern
)

for zsh_syntax in \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
    if [[ -r "$zsh_syntax" ]]; then
        source "$zsh_syntax"
        break
    fi
done


# ============================================================
# STARSHIP
# ============================================================

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

ZLE_RPROMPT_INDENT=0


# ============================================================
# ZOXIDE
# ============================================================

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi


# ============================================================
# ALIASES — EDITOR
# ============================================================

alias v='nvim'
alias sv='sudo nvim'


# ============================================================
# ALIASES — PRODUTIVIDADE
# ============================================================

alias z='nvim ~/.zshrc'
alias sz='source ~/.zshrc'
alias q='exit'


# ============================================================
# ALIASES — SISTEMA
# ============================================================

alias restart='systemctl --user restart'

alias psg='ps aux | grep -i'
alias k='pkill'

alias ip='ip -c'
alias ports='ss -tulpen'

alias ff='fastfetch'

alias vs='vdirsyncer sync'


# ============================================================
# ALIASES — CLIPBOARD
# ============================================================

alias cpout='wl-copy'
alias paste='wl-paste'


# ============================================================
# ALIASES — ARQUIVOS
# ============================================================

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons --group-directories-first'

alias cat='bat --style=plain'
alias ccat='bat --style=numbers'

alias grep='grep --color=auto'
alias rg='rg --smart-case'


# ============================================================
# ALIASES — NAVEGAÇÃO
# ============================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


# ============================================================
# GERENCIADOR DE PACOTES
# ============================================================

if (( $+commands[dnf5] )); then

    alias p='sudo dnf5 install'
    alias pu='sudo dnf5 upgrade'
    alias pr='sudo dnf5 remove'
    alias po='sudo dnf5 autoremove'

elif (( $+commands[dnf] )); then

    alias p='sudo dnf install'
    alias pu='sudo dnf upgrade --refresh'
    alias pr='sudo dnf remove'
    alias po='sudo dnf autoremove'

elif (( $+commands[pacman] )); then

    alias p='sudo pacman -S'
    alias pu='sudo pacman -Syu'
    alias pr='sudo pacman -Rns'

fi


# ============================================================
# AUR — YAY / PARU
# ============================================================

if (( $+commands[yay] )); then

    alias y='yay -S'
    alias yu='yay -Syu'
    alias yr='yay -Rns'

elif (( $+commands[paru] )); then

    alias y='paru -S'
    alias yu='paru -Syu'
    alias yr='paru -Rns'

fi


# ============================================================
# MKCD
# ============================================================

mkcd() {

    [[ -n "$1" ]] || return 1

    mkdir -p -- "$1" &&
        cd -- "$1"
}


# ============================================================
# EXTRACT
# ============================================================

extract() {

    if [[ ! -f "$1" ]]; then
        print -u2 "Arquivo inválido: $1"
        return 1
    fi

    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.tar.zst) tar --zstd -xf "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.xz)      xz -d "$1" ;;
        *.zst)     unzstd "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *.rar)     unrar x "$1" ;;
        *)
            print -u2 "Formato não suportado: $1"
            return 1
            ;;
    esac
}


# ============================================================
# CLEAN
# ============================================================

clean() {

    if (( $+commands[dnf5] )); then

        sudo dnf5 autoremove

    elif (( $+commands[dnf] )); then

        sudo dnf autoremove

    elif (( $+commands[pacman] )); then

        local -a pkgs

        pkgs=("${(@f)$(pacman -Qtdq 2>/dev/null)}")

        if (( ${#pkgs} )); then
            sudo pacman -Rns -- "${pkgs[@]}"
        else
            print "Nenhum pacote órfão encontrado."
        fi

    else

        print -u2 "Nenhum gerenciador de pacotes suportado encontrado."
        return 1

    fi
}


# ============================================================
# ZOXIDE + FZF
# ============================================================

j() {

    (( $+commands[zoxide] && $+commands[fzf] )) || return 1

    local dir

    dir=$(
        zoxide query -l 2>/dev/null |
        fzf \
            --height=40% \
            --layout=reverse \
            --border=rounded \
            --preview='eza --icons --tree --level=2 --color=always {}'
    ) || return 0

    [[ -n "$dir" ]] && cd -- "$dir"
}


# ============================================================
# YAZI
# ============================================================

yazi-here() {

    if (( $+commands[yazi] )); then
        yazi
    else
        print -u2 "yazi não encontrado."
        return 127
    fi
}


# ============================================================
# EDITAR ZSHRC
# ============================================================

zsh-edit() {
    nvim "$HOME/.zshrc"
}


# ============================================================
# RECARREGAR ZSH
# ============================================================

zsh-reload() {
    source "$HOME/.zshrc"
}


# ============================================================
# MOSTRAR PATH
# ============================================================

path-show() {
    print -l -- $path
}


# ============================================================
# PORTAS
# ============================================================

ports-listen() {
    ss -tulpen
}


# ============================================================
# WHERE
# ============================================================

where() {

    (( $# )) || return 1

    for cmd in "$@"; do

        print -n "$cmd: "

        if (( $+commands[$cmd] )); then
            print -r -- "$commands[$cmd]"

        elif (( $+builtins[$cmd] )); then
            print -r -- "zsh builtin"

        elif (( $+functions[$cmd] )); then
            print -r -- "zsh function"

        else
            print -r -- "not found"
        fi

    done
}


# ============================================================
# DIRETÓRIOS NOMEADOS
# ============================================================

hash -d estudos="$HOME/Documentos/Estudos/"
hash -d config="$HOME/.config"
hash -d obsidian="$HOME/Obsidian/Auditor/"


# ============================================================
# FIM
# ============================================================
