#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================
# DOTFILESV1 — BOOTSTRAP
# Restauração completa do ambiente CachyOS + DMS + Hyprland
# ============================================================

REPO_URL="https://github.com/VGViana/dotfilesv1.git"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_ROOT="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ------------------------------------------------------------
# CORES
# ------------------------------------------------------------

if [[ -t 1 ]]; then
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    RED='\033[1;31m'
    BLUE='\033[1;34m'
    RESET='\033[0m'
else
    GREEN=''
    YELLOW=''
    RED=''
    BLUE=''
    RESET=''
fi

info() {
    printf "${BLUE}==>${RESET} %s\n" "$*"
}

success() {
    printf "${GREEN}✓${RESET} %s\n" "$*"
}

warn() {
    printf "${YELLOW}⚠${RESET} %s\n" "$*"
}

die() {
    printf "${RED}✗${RESET} %s\n" "$*" >&2
    exit 1
}

# ------------------------------------------------------------
# ERROS
# ------------------------------------------------------------

trap 'echo; die "Bootstrap interrompido na linha $LINENO."' ERR

# ------------------------------------------------------------
# DETECTAR DISTRO
# ------------------------------------------------------------

if [[ ! -f /etc/os-release ]]; then
    die "Não foi possível identificar o sistema operacional."
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" != "cachyos" && "${ID_LIKE:-}" != *arch* ]]; then
    warn "Este bootstrap foi desenvolvido para CachyOS/Arch."
    warn "Sistema detectado: ${PRETTY_NAME:-desconhecido}"
    echo
    read -rp "Continuar mesmo assim? [s/N] " answer

    [[ "$answer" =~ ^[sS]$ ]] || exit 0
fi

# ------------------------------------------------------------
# SUDO
# ------------------------------------------------------------

if ! command -v sudo >/dev/null 2>&1; then
    die "sudo não está instalado. Instale-o antes de continuar."
fi

sudo -v

# ------------------------------------------------------------
# DEPENDÊNCIAS BÁSICAS
# ------------------------------------------------------------

info "Instalando dependências básicas..."

sudo pacman -Sy --needed --noconfirm \
    git \
    base-devel \
    stow \
    curl \
    wget

success "Dependências básicas prontas."

# ------------------------------------------------------------
# CLONAR / ATUALIZAR DOTFILES
# ------------------------------------------------------------

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Repositório já existe. Atualizando..."

    git -C "$DOTFILES_DIR" fetch origin
    git -C "$DOTFILES_DIR" reset --hard origin/main

else
    info "Clonando dotfilesv1..."

    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

success "dotfilesv1 disponível em $DOTFILES_DIR."

# ------------------------------------------------------------
# VALIDAR MANIFESTS
# ------------------------------------------------------------

[[ -f packages-pacman.txt ]] ||
    die "packages-pacman.txt não encontrado."

[[ -f packages-aur.txt ]] ||
    die "packages-aur.txt não encontrado."

# ------------------------------------------------------------
# PACMAN
# ------------------------------------------------------------

info "Atualizando bancos de pacotes..."

sudo pacman -Sy --needed --noconfirm

info "Instalando pacotes oficiais..."

mapfile -t PACMAN_PACKAGES < <(
    sed '/^[[:space:]]*#/d;/^[[:space:]]*$/d' packages-pacman.txt
)

if (( ${#PACMAN_PACKAGES[@]} > 0 )); then
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
fi

success "Pacotes oficiais instalados."

# ------------------------------------------------------------
# YAY
# ------------------------------------------------------------

if ! command -v yay >/dev/null 2>&1; then
    info "yay não encontrado. Instalando..."

    tmpdir="$(mktemp -d)"

    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"

    (
        cd "$tmpdir/yay"
        makepkg -si --noconfirm
    )

    rm -rf "$tmpdir"
fi

success "yay disponível."

# ------------------------------------------------------------
# AUR
# ------------------------------------------------------------

info "Instalando pacotes AUR..."

mapfile -t AUR_PACKAGES < <(
    sed '/^[[:space:]]*#/d;/^[[:space:]]*$/d' packages-aur.txt
)

if (( ${#AUR_PACKAGES[@]} > 0 )); then
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
fi

success "Pacotes AUR instalados."

# ------------------------------------------------------------
# BACKUP DE CONFIGURAÇÕES EXISTENTES
# ------------------------------------------------------------

info "Preparando configurações..."

mkdir -p "$BACKUP_ROOT"

backup_target() {
    local target="$1"

    [[ -e "$target" || -L "$target" ]] || return 0

    # Já é um symlink apontando para nosso repositório.
    if [[ -L "$target" ]]; then
        local resolved
        resolved="$(readlink -f "$target" 2>/dev/null || true)"

        if [[ "$resolved" == "$DOTFILES_DIR/"* ]]; then
            return 0
        fi
    fi

    local relative="${target#"$HOME"/}"
    local destination="$BACKUP_ROOT/$relative"

    mkdir -p "$(dirname "$destination")"

    mv "$target" "$destination"

    warn "Backup: $target → $destination"
}

# ------------------------------------------------------------
# MAPEAR DOT-CONFIG
# ------------------------------------------------------------

info "Criando links das configurações..."

while IFS= read -r -d '' source; do

    relative="${source#"$DOTFILES_DIR"/dot-config/}"
    target="$HOME/.config/$relative"

    mkdir -p "$(dirname "$target")"

    backup_target "$target"

done < <(
    find "$DOTFILES_DIR/dot-config" \
        \( -type f -o -type l \) \
        -print0
)

# ------------------------------------------------------------
# MAPEAR DOT-LOCAL
# ------------------------------------------------------------

while IFS= read -r -d '' source; do

    relative="${source#"$DOTFILES_DIR"/dot-local/}"
    target="$HOME/.local/$relative"

    mkdir -p "$(dirname "$target")"

    backup_target "$target"

done < <(
    find "$DOTFILES_DIR/dot-local" \
        \( -type f -o -type l \) \
        -print0
)

# ------------------------------------------------------------
# DOTFILES DA HOME
# ------------------------------------------------------------

for source in "$DOTFILES_DIR"/dot-*; do

    [[ -f "$source" ]] || continue

    name="${source##*/}"
    name="${name#dot-}"

    target="$HOME/.$name"

    backup_target "$target"

done

# ------------------------------------------------------------
# STOW
# ------------------------------------------------------------

info "Executando GNU Stow..."

cd "$DOTFILES_DIR"

stow --restow --dotfiles \
    --target="$HOME" \
    .

success "Symlinks restaurados."

# ------------------------------------------------------------
# PERMISSÕES
# ------------------------------------------------------------

info "Restaurando permissões..."

find "$DOTFILES_DIR/dot-local/bin" \
    -type f \
    -exec chmod +x {} \; \
    2>/dev/null || true

[[ -f "$DOTFILES_DIR/bootstrap.sh" ]] &&
    chmod +x "$DOTFILES_DIR/bootstrap.sh"

[[ -f "$DOTFILES_DIR/init-github.sh" ]] &&
    chmod +x "$DOTFILES_DIR/init-github.sh"

success "Permissões restauradas."

# ------------------------------------------------------------
# SYSTEMD USER
# ------------------------------------------------------------

info "Recarregando serviços do usuário..."

systemctl --user daemon-reload 2>/dev/null || true

# ------------------------------------------------------------
# SERVIÇOS IMPORTANTES
# ------------------------------------------------------------

info "Verificando serviços..."

for service in \
    pipewire.service \
    pipewire-pulse.service \
    wireplumber.service
do
    if systemctl --user list-unit-files "$service" \
        >/dev/null 2>&1; then

        systemctl --user enable --now "$service" \
            2>/dev/null || true
    fi
done

# ------------------------------------------------------------
# CACHE / DIRETÓRIOS
# ------------------------------------------------------------

mkdir -p \
    "$HOME/.config" \
    "$HOME/.local/bin" \
    "$HOME/.cache"

# ------------------------------------------------------------
# VERIFICAÇÃO
# ------------------------------------------------------------

echo
info "Executando verificação final..."

ERRORS=0

check_link() {
    local target="$1"

    if [[ ! -e "$target" && ! -L "$target" ]]; then
        printf "${RED}✗${RESET} Ausente: %s\n" "$target"
        ERRORS=$((ERRORS + 1))
    fi
}

check_link "$HOME/.config/hypr/hyprland.lua"
check_link "$HOME/.config/kitty/kitty.conf"
check_link "$HOME/.config/nvim/init.lua"
check_link "$HOME/.config/yazi/yazi.toml"
check_link "$HOME/.config/sioyek/prefs_user.config"
check_link "$HOME/.config/DankMaterialShell/settings.json"
check_link "$HOME/.zshrc"

echo

# ------------------------------------------------------------
# RESULTADO
# ------------------------------------------------------------

if (( ERRORS > 0 )); then

    warn "$ERRORS configurações importantes não foram encontradas."

    echo
    echo "Backup das configurações antigas:"
    echo "  $BACKUP_ROOT"

    echo
    warn "A restauração terminou, mas requer revisão."

else

    success "RESTORE COMPLETO."

    echo
    echo "╭────────────────────────────────────────────╮"
    echo "│                                            │"
    echo "│       DOTFILESV1 RESTORE CONCLUÍDO         │"
    echo "│                                            │"
    echo "╰────────────────────────────────────────────╯"

    echo
    echo "Repositório:"
    echo "  $DOTFILES_DIR"

    echo
    echo "Backup:"
    echo "  $BACKUP_ROOT"

    echo
    echo "Próximo passo:"
    echo "  reinicie o computador."
fi
