# dotfilesv1

Meu ambiente Linux versionado e reproduzível.

**Repositório:** :contentReference[oaicite:0]{index=0}

---

## 1. O que é este repositório?

Este repositório contém minhas configurações pessoais do Linux, gerenciadas com **Git + GNU Stow**.

A ideia é que, em caso de formatação ou troca de computador, eu consiga reconstruir meu ambiente CachyOS + DMS de forma praticamente automática.

```text
GitHub
   │
   │ git clone
   ▼
~/dotfiles
   │
   │ GNU Stow
   ▼
$HOME
   │
   ├── ~/.config/...
   ├── ~/.local/...
   ├── ~/.zshrc
   ├── ~/.bashrc
   └── ...

   2. Estado atual

Ambiente de referência:

Distro: CachyOS
Desktop/compositor: DankMaterialShell (DMS) + Hyprland
Shell: Zsh
Terminal: Kitty
Editor: Neovim
Gerenciador de arquivos: Yazi
Gerenciador de dotfiles: GNU Stow
Versionamento: Git
Backup remoto: GitHub privado

Repositório:

https://github.com/VGViana/dotfilesv1
3. Estrutura do repositório
dotfiles/
├── README.md
├── bootstrap.sh
├── packages-pacman.txt
├── packages-aur.txt
│
├── dot-bash_profile
├── dot-bashrc
├── dot-zshrc
│
├── dot-config/
│   ├── DankMaterialShell/
│   ├── Thunar/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   ├── hypr/
│   ├── khal/
│   ├── kitty/
│   ├── ncspot/
│   ├── nvim/
│   ├── qt5ct/
│   ├── qt6ct/
│   ├── sioyek/
│   ├── systemd/
│   ├── wireplumber/
│   ├── xdg/
│   ├── xfce4/
│   └── yazi/
│
└── dot-local/
    └── bin/
        ├── dots
        ├── fzf-file
        └── update-system

Os prefixos dot- são usados pelo Stow para representar arquivos ocultos no $HOME.

4. RESTAURAÇÃO COMPLETA — PC NOVO / FORMATADO
4.1. Instalar o CachyOS

Instalar o CachyOS normalmente.

Depois:

Entrar no sistema.
Conectar à internet.
Atualizar o sistema.
Instalar o DMS/Hyprland.
Garantir que Git, Stow e GitHub CLI estejam disponíveis.

Exemplo:

sudo pacman -Syu
5. Autenticação no GitHub

Instalar o GitHub CLI:

sudo pacman -S github-cli

Autenticar:

gh auth login

Verificar:

gh auth status

A conta precisa ter acesso ao repositório privado:

VGViana/dotfilesv1
6. Restaurar os dotfiles

Clonar o repositório:

git clone https://github.com/VGViana/dotfilesv1.git ~/dotfiles

Entrar no diretório:

cd ~/dotfiles
7. Instalar os pacotes

Os pacotes atualmente registrados estão separados em:

packages-pacman.txt
packages-aur.txt
Pacotes oficiais
sudo pacman -S --needed - < packages-pacman.txt
Pacotes AUR

Primeiro garantir que o yay esteja disponível.

Depois:

yay -S --needed - < packages-aur.txt
8. Executar o bootstrap

O arquivo:

bootstrap.sh

é responsável pela restauração do ambiente.

Executar:

cd ~/dotfiles
./bootstrap.sh

Se necessário:

bash bootstrap.sh

O script:

verifica o sistema;
verifica dependências;
cria backups;
restaura configurações;
configura os links;
aplica os dotfiles;
verifica o resultado;
informa possíveis problemas.
9. GNU Stow

O gerenciamento das configurações utiliza GNU Stow.

A estrutura:

dot-config/
dot-local/
dot-zshrc
dot-bashrc
dot-bash_profile

é transformada em links no $HOME.

Exemplo:

~/.config/kitty/kitty.conf
        ↓
~/dotfiles/dot-config/kitty/kitty.conf

Verificar:

readlink -f ~/.config/kitty/kitty.conf

Deve apontar para:

/home/viana/dotfiles/dot-config/kitty/kitty.conf
10. Verificar a restauração

Executar:

cd ~/dotfiles


bash -n bootstrap.sh
shellcheck bootstrap.sh
git diff --check
git status

O resultado esperado:

nothing to commit, working tree clean

Também verificar os principais links:

readlink -f ~/.zshrc
readlink -f ~/.config/hypr/hyprland.lua
readlink -f ~/.config/hypr/dms/binds-user.lua
readlink -f ~/.config/nvim/init.lua
readlink -f ~/.config/kitty/kitty.conf
readlink -f ~/.config/DankMaterialShell/settings.json
readlink -f ~/.config/gtk-3.0/dank-colors.css
readlink -f ~/.config/sioyek/prefs_user.config
readlink -f ~/.config/yazi/yazi.toml
readlink -f ~/.config/starship.toml
readlink -f ~/.local/bin/dots

Todos devem apontar para ~/dotfiles.

11. Reiniciar

Depois da restauração:

systemctl reboot

Após o login, verificar:

DMS;
Hyprland;
Kitty;
Zsh;
Neovim;
Yazi;
Sioyek;
GTK;
temas;
fontes;
áudio;
WirePlumber;
atalhos;
scripts.
12. Fluxo normal de trabalho

Depois de modificar uma configuração:

dots

O comando dots verifica alterações, cria o commit e envia para o GitHub.

Fluxo:

editar configuração
       ↓
     dots
       ↓
     git
       ↓
   GitHub

Assim, o repositório permanece atualizado.

13. Atualizar manualmente

Caso seja necessário:

cd ~/dotfiles


git status
git add .
git commit -m "chore: update dotfiles"
git push
14. Restaurar em outro computador

Se o computador antigo ainda estiver funcionando:

git clone https://github.com/VGViana/dotfilesv1.git ~/dotfiles

Depois seguir:

1. instalar CachyOS
2. atualizar sistema
3. instalar DMS/Hyprland
4. instalar Git
5. autenticar GitHub
6. clonar ~/dotfiles
7. instalar pacotes-pacman.txt
8. instalar pacotes-aur.txt
9. executar bootstrap.sh
10. reiniciar
15. Backups

Antes de substituir configurações existentes, o bootstrap cria backups em:

~/.dotfiles-backup/

Cada execução possui seu próprio diretório baseado em data e hora.

Exemplo:

~/.dotfiles-backup/20260819-150000/

Isso permite recuperar configurações antigas caso alguma coisa dê errado.

16. Segurança

Este repositório é privado.

Nunca adicionar ao repositório:

senhas
tokens
chaves privadas
API keys
credenciais
cookies
arquivos .pem
arquivos .key

Antes de fazer push:

git status
git diff

Também é possível procurar nomes suspeitos:

find . -type f \
  \( -iname '*token*' \
  -o -iname '*secret*' \
  -o -iname '*credential*' \
  -o -iname '*.key' \
  -o -iname '*.pem' \
  -o -iname '*password*' \
  -o -iname '*passwd*' \) \
  -not -path './.git/*'
17. Atualização dos pacotes

Quando instalar ou remover pacotes do sistema, atualizar as listas:

cd ~/dotfiles


pacman -Qqen | sort -u > packages-pacman.txt
pacman -Qqem | sort -u > packages-aur.txt

Depois:

git add packages-pacman.txt packages-aur.txt
git commit -m "chore: update package lists"
git push
18. Filosofia deste setup

Este repositório deve ser tratado como a fonte da verdade das configurações pessoais.

O objetivo é evitar:

"Eu lembro como configurei isso?"

e substituir por:

"Está no GitHub."

A máquina pode ser perdida.

O SSD pode quebrar.

O sistema pode ser formatado.

O computador pode ser substituído.

Enquanto o repositório estiver disponível, o ambiente pode ser reconstruído.

19. Comando de emergência

Em uma máquina nova, depois de instalar o básico e autenticar no GitHub:

git clone https://github.com/VGViana/dotfilesv1.git ~/dotfiles && cd ~/dotfiles && ./bootstrap.sh

Se os pacotes ainda não estiverem instalados, instalar primeiro:

sudo pacman -S --needed - < ~/dotfiles/packages-pacman.txt

e:

yay -S --needed - < ~/dotfiles/packages-aur.txt

Depois:

cd ~/dotfiles
./bootstrap.sh
20. Estado de referência

O ambiente usado para criar esta versão do repositório foi validado com:

Git:             OK
Bootstrap:       OK
ShellCheck:      OK
git diff --check: OK
Stow dry-run:    OK
Symlinks:        OK
Segredos:        nenhum detectado por nome
GitHub:          OK
Repositório:     privado
Branch:          main
Working tree:    limpa

Repositório:

https://github.com/VGViana/dotfilesv1
Regra principal

Não editar diretamente os arquivos em ~/.config se eles forem gerenciados pelo Stow.

Editar sempre:

~/dotfiles/

Depois sincronizar:

dots

Assim o GitHub continua sendo a cópia de segurança do ambiente.
