#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# DOTFILESV1 — FEDORA BOOTSTRAP
# Fedora + Hyprland + DankMaterialShell
# ============================================================

REPO_URL="git@github.com:VGViana/dotfilesv1.git"
BRANCH="fedora"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_ROOT="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

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

trap 'echo; die "Bootstrap interrompido na linha $LINENO."' ERR

# ============================================================
# SISTEMA
# ============================================================

[[ -r /etc/os-release ]] || die "Não foi possível identificar o sistema."

source /etc/os-release

[[ "${ID:-}" == "fedora" ]] || \
    die "Este bootstrap é exclusivo para Fedora. Sistema: ${PRETTY_NAME:-desconhecido}"

command -v sudo >/dev/null 2>&1 || \
    die "sudo não está instalado."

sudo -v

if command -v dnf5 >/dev/null 2>&1; then
    DNF=(sudo dnf5)
else
    DNF=(sudo dnf)
fi

# ============================================================
# BASE
# ============================================================

info "Atualizando metadados do Fedora..."

"${DNF[@]}" upgrade --refresh -y

info "Instalando dependências básicas..."

"${DNF[@]}" install -y \
    git \
    git-lfs \
    openssh-clients \
    curl \
    wget \
    rsync \
    stow \
    zsh \
    ca-certificates \
    findutils \
    util-linux \
    sudo

git lfs install --skip-repo >/dev/null 2>&1 || true

# ============================================================
# DANKMATERIALSHELL
# ============================================================

info "Configurando DankMaterialShell..."

if ! "${DNF[@]}" repolist 2>/dev/null | grep -qi avengemedia; then
    sudo dnf copr enable -y avengemedia/dms || \
        warn "Não foi possível habilitar COPR avengemedia/dms."
fi

# ============================================================
# REPOSITÓRIO
# ============================================================

if [[ -d "$DOTFILES_DIR/.git" ]]; then

    info "Atualizando dotfiles..."

    git -C "$DOTFILES_DIR" fetch origin

    git -C "$DOTFILES_DIR" switch "$BRANCH" 2>/dev/null || \
        git -C "$DOTFILES_DIR" switch -c "$BRANCH" --track "origin/$BRANCH"

    git -C "$DOTFILES_DIR" reset --hard "origin/$BRANCH"

else

    info "Clonando dotfiles..."

    git clone \
        --branch "$BRANCH" \
        --single-branch \
        "$REPO_URL" \
        "$DOTFILES_DIR"

fi

cd "$DOTFILES_DIR"

success "Repositório Fedora pronto."

# ============================================================
# PACOTES
# ============================================================

[[ -f packages-fedora.txt ]] || \
    die "packages-fedora.txt não encontrado."

info "Instalando pacotes Fedora..."

mapfile -t PACKAGES < <(
    sed \
        -e '/^[[:space:]]*#/d' \
        -e '/^[[:space:]]*$/d' \
        packages-fedora.txt
)

FAILED_PACKAGES=()

for package in "${PACKAGES[@]}"; do

    if rpm -q "$package" >/dev/null 2>&1; then
        continue
    fi

    if ! "${DNF[@]}" install -y "$package"; then
        FAILED_PACKAGES+=("$package")
        warn "Pacote não disponível: $package"
    fi

done

if (( ${#FAILED_PACKAGES[@]} > 0 )); then

    echo
    warn "Alguns pacotes não foram encontrados:"

    printf '  %s\n' "${FAILED_PACKAGES[@]}"

    echo
    warn "Isso não interrompe o bootstrap."

fi

# ============================================================
# DMS
# ============================================================

info "Instalando DankMaterialShell..."

if ! rpm -q dms >/dev/null 2>&1; then

    if ! "${DNF[@]}" install -y dms; then
        warn "dms não pôde ser instalado pelo repositório atual."
    fi

fi

# Componentes opcionais do DMS.
for package in \
    quickshell \
    dankcalendar \
    dgop \
    matugen \
    cava \
    cliphist
do

    if rpm -q "$package" >/dev/null 2>&1; then
        continue
    fi

    "${DNF[@]}" install -y "$package" 2>/dev/null || \
        warn "Opcional não disponível: $package"

done

# ============================================================
# BACKUP
# ============================================================

info "Preparando backup das configurações existentes..."

mkdir -p "$BACKUP_ROOT"

backup_target() {

    local target="$1"

    [[ -e "$target" || -L "$target" ]] || return 0

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

    warn "Backup: $target"

}

# ============================================================
# CONFIG
# ============================================================

info "Restaurando ~/.config..."

while IFS= read -r -d '' source; do

    relative="${source#"$DOTFILES_DIR/dot-config/"}"
    target="$HOME/.config/$relative"

    backup_target "$target"

done < <(
    find "$DOTFILES_DIR/dot-config" \
        \( -type f -o -type l \) \
        -print0
)

# ============================================================
# LOCAL
# ============================================================

info "Restaurando ~/.local..."

while IFS= read -r -d '' source; do

    relative="${source#"$DOTFILES_DIR/dot-local/"}"
    target="$HOME/.local/$relative"

    backup_target "$target"

done < <(
    find "$DOTFILES_DIR/dot-local" \
        \( -type f -o -type l \) \
        -print0
)

# ============================================================
# HOME
# ============================================================

for source in "$DOTFILES_DIR"/dot-*; do

    [[ -f "$source" ]] || continue

    name="${source##*/}"
    name="${name#dot-}"

    target="$HOME/.$name"

    backup_target "$target"

done

# ============================================================
# STOW
# ============================================================

info "Executando GNU Stow..."

mkdir -p \
    "$HOME/.config" \
    "$HOME/.local/bin"

cd "$DOTFILES_DIR"

stow \
    --restow \
    --dotfiles \
    --target="$HOME" \
    .

success "Dotfiles vinculados."

# ============================================================
# LIMPEZA DE ARQUIVOS GERADOS
# ============================================================

rm -f \
    "$HOME/.config/DankMaterialShell/.firstlaunch"

rm -rf \
    "$HOME/.config/qt5ct/colors" \
    "$HOME/.config/qt6ct/colors"

# ============================================================
# PERMISSÕES
# ============================================================

if [[ -d "$DOTFILES_DIR/dot-local/bin" ]]; then

    find "$DOTFILES_DIR/dot-local/bin" \
        -type f \
        -exec chmod +x {} +

fi

chmod +x "$DOTFILES_DIR/bootstrap.sh" 2>/dev/null || true

# ============================================================
# SYSTEMD USER
# ============================================================

systemctl --user daemon-reload 2>/dev/null || true

for service in \
    pipewire.service \
    pipewire-pulse.service \
    wireplumber.service
do

    systemctl --user enable --now "$service" \
        2>/dev/null || true

done

# ============================================================
# SHELL
# ============================================================

if command -v zsh >/dev/null 2>&1; then

    ZSH_PATH="$(command -v zsh)"

    CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

    if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then

        info "Configurando Zsh como shell padrão..."

        chsh -s "$ZSH_PATH" "$USER" || \
            warn "Não foi possível alterar o shell padrão."

    fi

fi

# ============================================================
# VERIFICAÇÃO
# ============================================================

info "Executando verificação final..."

ERRORS=0

check_path() {

    if [[ ! -e "$1" && ! -L "$1" ]]; then

        printf "${RED}✗${RESET} Ausente: %s\n" "$1"

        ERRORS=$((ERRORS + 1))

    fi

}

check_path "$HOME/.config/hypr/hyprland.lua"
check_path "$HOME/.config/kitty/kitty.conf"
check_path "$HOME/.config/nvim/init.lua"
check_path "$HOME/.config/yazi/yazi.toml"
check_path "$HOME/.config/sioyek/prefs_user.config"
check_path "$HOME/.config/DankMaterialShell/settings.json"
check_path "$HOME/.zshrc"

echo

if (( ERRORS > 0 )); then

    warn "$ERRORS configurações importantes estão ausentes."
    warn "Backup disponível em:"
    echo "  $BACKUP_ROOT"

    exit 2

fi

success "RESTORE COMPLETO."

echo
echo "╭────────────────────────────────────────────╮"
echo "│                                            │"
echo "│       DOTFILESV1 FEDORA RESTORE            │"
echo "│                                            │"
echo "╰────────────────────────────────────────────╯"
echo
echo "Repositório:"
echo "  $DOTFILES_DIR"
echo
echo "Backup:"
echo "  $BACKUP_ROOT"
echo
echo "Reinicie a sessão para carregar completamente o ambiente."
