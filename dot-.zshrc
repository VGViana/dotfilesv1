# ============================================================
# VINICIUS — ZSH
# Fedora / Arch + Hyprland + Kitty + Neovim + Yazi + FZF
# ============================================================


# ============================================================
# PROFILING
# ============================================================
#
# Para diagnosticar startup:
#
#   zmodload zsh/zprof
#   zprof
#
# Não deixe habilitado normalmente.
#

# zmodload zsh/zprof


# ============================================================
# PATH
# ============================================================

typeset -U path

path=(
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.local/lib/npm/bin"
    $path
)

export PATH


# ============================================================
# EDITORES / TERMINAL
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

# cd sem precisar escrever "cd"
setopt autocd

# Histórico de diretórios
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# Não gerar erro quando glob não encontrar nada
setopt no_nomatch

# Permitir substituições no prompt
setopt prompt_subst

# Comentários interativos
setopt interactive_comments

# Ctrl+D não encerra o shell acidentalmente
setopt ignore_eof


# ============================================================
# HISTÓRICO
# ============================================================

HISTFILE="$HOME/.zsh_history"

# Quantidade em memória
HISTSIZE=100000

# Quantidade salva no arquivo
SAVEHIST=50000

# Compartilhar histórico entre shells
setopt share_history

# Salvar comandos imediatamente
setopt inc_append_history

# Não salvar duplicados consecutivos
setopt hist_ignore_dups

# Remover duplicados antigos
setopt hist_ignore_all_dups

# Busca no histórico sem duplicação
setopt hist_find_no_dups

# Não salvar duplicados no arquivo
setopt hist_save_no_dups

# Expirar primeiro os duplicados
setopt hist_expire_dups_first

# Comandos precedidos por espaço não entram no histórico
setopt hist_ignore_space

# Reduzir espaços redundantes
setopt hist_reduce_blanks

# Mostrar comando expandido antes de executar
setopt hist_verify

# Lock seguro do arquivo de histórico
setopt hist_fcntl_lock


# ============================================================
# COMPLETION — CACHE
# ============================================================

ZCACHEDIR="$HOME/.cache/zsh"
ZCOMPDUMP="$ZCACHEDIR/.zcompdump"

mkdir -p "$ZCACHEDIR"

autoload -Uz compinit

compinit -d "$ZCOMPDUMP"

# Compilar o dump para acelerar carregamento
if [[ -r "$ZCOMPDUMP" &&
      ( ! -r "${ZCOMPDUMP}.zwc" ||
        "$ZCOMPDUMP" -nt "${ZCOMPDUMP}.zwc" ) ]]; then
    zcompile "$ZCOMPDUMP"
fi


# ============================================================
# COMPLETION — MÓDULO AVANÇADO
# ============================================================

zmodload -i zsh/complist


# ============================================================
# COMPLETION — APARÊNCIA
# ============================================================

zstyle ':completion:*' menu select

zstyle ':completion:*' group-name ''

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZCACHEDIR"

# Case insensitive
# Também trata . _ -
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*'

# Cores usando LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Melhor comportamento com paths
zstyle ':completion:*' squeeze-slashes true

# Atualizar command hash quando necessário
zstyle ':completion:*' rehash true

# Diretórios primeiro
zstyle ':completion:*' list-dirs-first true

# Prompt ao navegar por uma lista grande
zstyle ':completion:*' select-prompt '%SScrolling active: %p%s'


# ============================================================
# COMPLETION — MENU SELECTION
# ============================================================

bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char

bindkey -M menuselect '^P' up-line-or-history
bindkey -M menuselect '^N' down-line-or-history


# ============================================================
# ZLE — MODO EMACS
# ============================================================

bindkey -e


# ============================================================
# ZLE — PALAVRAS
# ============================================================

WORDCHARS=${WORDCHARS//\/}


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

# Fallback caso FZF não esteja disponível.
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
# ZLE — OUTROS WIDGETS ÚTEIS
# ============================================================

autoload -Uz expand-absolute-path
zle -N expand-absolute-path

bindkey '^[/' expand-absolute-path

bindkey '^[.' copy-prev-shell-word

bindkey '^[_' insert-last-word

bindkey '^_' undo
bindkey '^[u' undo
bindkey '^[U' redo


# ============================================================
# ZLE — BRACKETED PASTE
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
# Compatível com layouts Fedora / Arch
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
# Compatível com layouts Fedora / Arch
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
# Compatível com layouts Fedora / Arch
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
# ALIASES — EDITORES
# ============================================================

alias v='nvim'
alias sv='sudo nvim'


# ============================================================
# ALIASES — SISTEMA
# ============================================================

alias restart='systemctl --user restart'


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
alias ~='cd ~'


# ============================================================
# GERENCIADOR DE PACOTES
# Fedora + Arch
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
    alias po='pacman -Qtdq'

fi


# ============================================================
# AUR
# Arch somente — yay / paru
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
# ALIASES — SISTEMA
# ============================================================

alias psg='ps aux | grep -i'
alias k='pkill'

alias ip='ip -c'
alias ports='ss -tulpen'

alias ff='fastfetch'

alias vs='vdirsyncer sync'
alias ds='doom sync'


# ============================================================
# THEME TOGGLE — Alt+S
# ============================================================

toggle-theme() {

    if [[ -f ~/.config/theme/current ]]; then

        local current
        current=$(<~/.config/theme/current)

        if [[ "$current" == "dark" ]]; then
            light
        else
            dark
        fi

    else

        dark

    fi
}

toggle-theme-widget() {
    toggle-theme
    zle reset-prompt
}

zle -N toggle-theme-widget
bindkey '^[s' toggle-theme-widget


# ============================================================
# SISTEMA DE TEMAS — GRUVBOX MATERIAL
# ============================================================

theme_light() {

    mkdir -p ~/.config/theme

    # Estado global
    echo "light" > ~/.config/theme/current

    # Kitty — tema persistente
    if [[ -f ~/.config/kitty/gruvbox-light.conf ]]; then
        cp ~/.config/kitty/gruvbox-light.conf \
           ~/.config/kitty/current-theme.conf
    fi

    # Kitty — aplicar imediatamente
    if (( $+commands[kitty] )); then
        kitty @ set-colors \
            --all ~/.config/kitty/gruvbox-light.conf \
            2>/dev/null || true
    fi

    # btop
    if [[ -f ~/.config/btop/themes/gruvbox-material-light.theme ]]; then
        cp ~/.config/btop/themes/gruvbox-material-light.theme \
           ~/.config/btop/themes/current.theme
    fi

    echo "Tema LIGHT ativado."
}


theme_dark() {

    mkdir -p ~/.config/theme

    # Estado global
    echo "dark" > ~/.config/theme/current

    # Kitty — tema persistente
    if [[ -f ~/.config/kitty/gruvbox-dark.conf ]]; then
        cp ~/.config/kitty/gruvbox-dark.conf \
           ~/.config/kitty/current-theme.conf
    fi

    # Kitty — aplicar imediatamente
    if (( $+commands[kitty] )); then
        kitty @ set-colors \
            --all ~/.config/kitty/gruvbox-dark.conf \
            2>/dev/null || true
    fi

    # btop
    if [[ -f ~/.config/btop/themes/gruvbox-material-dark.theme ]]; then
        cp ~/.config/btop/themes/gruvbox-material-dark.theme \
           ~/.config/btop/themes/current.theme
    fi

    echo "Tema DARK ativado."
}


alias light='theme_light'
alias dark='theme_dark'


# ============================================================
# ALIASES — PRODUTIVIDADE
# ============================================================

alias z='nvim ~/.zshrc'
alias sz='source ~/.zshrc'
alias q='exit'


# ============================================================
# FUNÇÃO — CRIAR DIRETÓRIO E ENTRAR
# ============================================================

mkcd() {

    [[ -n "$1" ]] || return 1

    mkdir -p -- "$1" &&
        cd -- "$1"
}


# ============================================================
# FUNÇÃO — EXTRAIR ARQUIVOS
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
# FUNÇÃO — LIMPAR PACOTES NÃO UTILIZADOS
# Fedora + Arch
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
# FUNÇÃO — ZOXIDE + FZF
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
# FUNÇÃO — ENTRAR EM DIRETÓRIO E ABRIR YAZI
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
# FUNÇÃO — EDITAR ZSHRC
# ============================================================

zsh-edit() {
    nvim "$HOME/.zshrc"
}


# ============================================================
# FUNÇÃO — RECARREGAR ZSH
# ============================================================

zsh-reload() {
    source "$HOME/.zshrc"
}


# ============================================================
# FUNÇÃO — VER PATH
# ============================================================

path-show() {
    print -l -- $path
}


# ============================================================
# FUNÇÃO — PORTAS EM ESCUTA
# ============================================================

ports-listen() {
    ss -tulpen
}


# ============================================================
# FUNÇÃO — QUAL COMANDO ESTÁ SENDO EXECUTADO
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

hash -d estudos="$HOME/Estudos"
hash -d config="$HOME/.config"


# ============================================================
# END
# ============================================================

export PATH=$PATH:/home/viana/.spicetify
export PATH="$HOME/.spicetify:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
