# dotfilesv1

Repositório privado que guarda a configuração reproduzível do meu ambiente Linux.

**GitHub:** https://github.com/VGViana/dotfilesv1

O objetivo deste repositório é permitir que, se o computador quebrar ou o sistema for formatado, eu consiga reconstruir meu ambiente CachyOS + DMS + Hyprland com o mínimo de trabalho manual possível.

---

## 1. Visão geral

A estrutura funciona assim:

```text
GitHub
  │
  │ git clone / git pull
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
```

Os arquivos dentro de `~/dotfiles` são a fonte da verdade.

Quando uma configuração é gerenciada pelo Stow, não devo editar diretamente o arquivo em `~/.config` ou `~/.local`. Devo editar a cópia dentro de `~/dotfiles` e depois sincronizar.

---

# 2. Ambiente de referência

Este repositório foi criado para o meu ambiente atual:

- **Distribuição:** CachyOS
- **Compositor:** Hyprland
- **Shell/Desktop shell:** DankMaterialShell (DMS)
- **Terminal:** Kitty
- **Shell:** Zsh
- **Editor:** Neovim
- **Gerenciador de arquivos:** Yazi
- **PDF:** Sioyek
- **Música:** ncspot
- **Calendário:** khal
- **Gerenciamento de dotfiles:** GNU Stow
- **Versionamento:** Git
- **GitHub CLI:** `gh`

A configuração visual segue principalmente a estética **Gruvbox Material Dark Soft**, com foco em uma interface minimalista e confortável para estudos.

---

# 3. Estrutura do repositório

A estrutura principal é:

```text
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
│   ├── environment.d/
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
│   ├── user-dirs.dirs
│   ├── wireplumber/
│   ├── xarchiver/
│   ├── xdg-terminals.list
│   ├── xfce4/
│   └── yazi/
│
└── dot-local/
    └── bin/
        ├── dots
        ├── fzf-file
        └── update-system
```

Os arquivos que começam com `dot-` representam arquivos ocultos no `$HOME`.

Por exemplo:

```text
dot-zshrc
```

vira:

```text
~/.zshrc
```

---

# 4. O papel do GNU Stow

O Stow cria links simbólicos entre o repositório e o `$HOME`.

Exemplo:

```text
~/dotfiles/dot-config/kitty/kitty.conf
                │
                │ stow
                ▼
~/.config/kitty/kitty.conf
```

O segundo arquivo não é uma cópia independente.

Ele aponta para o repositório:

```text
~/.config/kitty/kitty.conf
        ↓
~/dotfiles/dot-config/kitty/kitty.conf
```

Isso é importante porque qualquer alteração feita no arquivo do repositório passa a ser a configuração usada pelo sistema.

Para confirmar:

```bash
readlink -f ~/.config/kitty/kitty.conf
```

---

# 5. Instalação em um PC novo

Esta é a seção mais importante deste README.

Se o computador quebrar, for formatado ou for necessário reconstruir o ambiente, seguir a ordem abaixo.

---

## 5.1. Instalar o CachyOS

Instalar o CachyOS normalmente.

Depois de entrar no sistema:

```bash
sudo pacman -Syu
```

Reiniciar se o sistema solicitar.

---

## 5.2. Conectar à internet

Antes de continuar, garantir que a máquina esteja conectada à internet.

Tudo a partir daqui depende do acesso ao GitHub e aos repositórios de pacotes.

---

## 5.3. Instalar Git

```bash
sudo pacman -S --needed git
```

Verificar:

```bash
git --version
```

---

## 5.4. Instalar GitHub CLI

```bash
sudo pacman -S --needed github-cli
```

Verificar:

```bash
gh --version
```

---

## 5.5. Autenticar no GitHub

```bash
gh auth login
```

Escolher:

```text
GitHub.com
HTTPS
Login with a web browser
```

Depois verificar:

```bash
gh auth status
```

A conta precisa ter acesso ao repositório privado:

```text
VGViana/dotfilesv1
```

---

# 6. Clonar os dotfiles

Clonar o repositório:

```bash
git clone https://github.com/VGViana/dotfilesv1.git ~/dotfiles
```

Entrar no diretório:

```bash
cd ~/dotfiles
```

Confirmar:

```bash
git remote -v
```

Deve aparecer:

```text
origin  https://github.com/VGViana/dotfilesv1.git
```

---

# 7. Instalar os pacotes oficiais

O arquivo:

```text
packages-pacman.txt
```

contém os pacotes oficiais instalados na máquina de referência.

Instalar:

```bash
sudo pacman -S --needed - < packages-pacman.txt
```

O `--needed` evita reinstalar pacotes que já estiverem instalados.

---

# 8. Instalar os pacotes AUR

O arquivo:

```text
packages-aur.txt
```

contém os pacotes que não pertencem aos repositórios oficiais.

Neste ambiente, a lista inclui atualmente pacotes como:

```text
bibata-cursor-theme
greetd-dms-greeter-git
gruvbox-plus-icon-theme
sioyek-appimage
```

O `yay` é necessário para instalar essa lista.

Se `yay` já estiver disponível:

```bash
yay -S --needed - < packages-aur.txt
```

Se `yay` não estiver instalado, instalar/configurar um AUR helper primeiro e então executar o comando acima.

---

# 9. Restaurar as configurações

Depois que as dependências principais estiverem instaladas:

```bash
cd ~/dotfiles
./bootstrap.sh
```

Se o arquivo não estiver executável:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

O bootstrap foi feito para automatizar a restauração e reduzir o número de etapas manuais.

---

# 10. O que o bootstrap faz

O `bootstrap.sh` é o principal script de restauração.

Ele foi criado para:

1. verificar o ambiente;
2. identificar a distribuição;
3. verificar dependências;
4. preparar diretórios;
5. criar backups de configurações existentes;
6. restaurar os dotfiles;
7. configurar os links simbólicos;
8. verificar arquivos importantes;
9. mostrar possíveis erros;
10. finalizar informando o estado da restauração.

Os backups ficam em:

```text
~/.dotfiles-backup/
```

Cada execução pode criar uma pasta própria com data e hora.

Exemplo:

```text
~/.dotfiles-backup/20260819-150000/
```

---

# 11. Não apagar configurações antigas antes do bootstrap

O bootstrap foi pensado para preservar configurações existentes através de backup.

Por isso, em uma instalação nova, não é necessário sair apagando manualmente:

```text
~/.config
~/.local
~/.zshrc
```

Antes de fazer qualquer limpeza manual, deixar o bootstrap trabalhar.

---

# 12. Verificar os links depois da restauração

Depois do bootstrap, verificar os principais arquivos:

```bash
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
```

O resultado esperado é que os arquivos apontem para:

```text
/home/viana/dotfiles/...
```

ou, em outra máquina, para:

```text
/home/USUARIO/dotfiles/...
```

---

# 13. Verificar o Stow

Para testar sem alterar nada:

```bash
cd ~/dotfiles
stow --dotfiles --no-folding --restow --simulate .
```

O resultado esperado inclui:

```text
WARNING: in simulation mode so not modifying filesystem.
```

Isso é normal.

O modo `--simulate` significa que o Stow apenas está testando o que faria.

---

# 14. Verificar o bootstrap

Executar:

```bash
cd ~/dotfiles

bash -n bootstrap.sh
shellcheck bootstrap.sh
git diff --check
```

Os três comandos devem terminar sem erros.

---

# 15. Reiniciar

Depois da restauração:

```bash
systemctl reboot
```

Após reiniciar, conferir:

- DMS;
- Hyprland;
- Kitty;
- Zsh;
- Neovim;
- Yazi;
- Sioyek;
- GTK;
- tema;
- fontes;
- áudio;
- WirePlumber;
- atalhos;
- scripts;
- aplicativos de estudo.

---

# 16. O comando de emergência

Depois de instalar o CachyOS, configurar a internet, instalar `git`, `github-cli`, autenticar no GitHub e ter um AUR helper disponível, o fluxo principal é:

```bash
git clone https://github.com/VGViana/dotfilesv1.git ~/dotfiles && \
cd ~/dotfiles && \
sudo pacman -S --needed - < packages-pacman.txt && \
yay -S --needed - < packages-aur.txt && \
./bootstrap.sh
```

Esse é o comando que representa a restauração automática.

Se algum pacote ou etapa exigir intervenção, resolver o erro e executar novamente a etapa correspondente.

---

# 17. Depois da restauração

A máquina nova deve ser considerada restaurada somente depois de:

```bash
git status
```

mostrar:

```text
nothing to commit, working tree clean
```

e os principais links apontarem para `~/dotfiles`.

Também verificar:

```bash
cd ~/dotfiles
bash -n bootstrap.sh
shellcheck bootstrap.sh
git diff --check
```

---

# 18. Como trabalhar normalmente

Depois que o sistema estiver funcionando, a regra é simples:

```text
editar
  ↓
~/dotfiles
  ↓
testar
  ↓
dots
  ↓
Git
  ↓
GitHub
```

---

# 19. Nunca editar diretamente o arquivo gerenciado

Por exemplo, se quiser alterar o Kitty, não editar:

```text
~/.config/kitty/kitty.conf
```

Editar:

```text
~/dotfiles/dot-config/kitty/kitty.conf
```

Se quiser alterar o Neovim:

```text
~/dotfiles/dot-config/nvim/
```

Se quiser alterar o Hyprland:

```text
~/dotfiles/dot-config/hypr/
```

Se quiser alterar o DMS:

```text
~/dotfiles/dot-config/DankMaterialShell/
```

---

# 20. Comando `dots`

O script:

```text
~/.local/bin/dots
```

é o comando utilizado para sincronizar alterações.

Uso:

```bash
dots
```

O fluxo esperado é:

```text
verificar alterações
       ↓
mostrar alterações
       ↓
criar commit
       ↓
push
       ↓
GitHub atualizado
```

Assim, depois de uma alteração importante:

```bash
dots
```

é suficiente para salvar a alteração no repositório.

---

# 21. Atualização manual

Se for necessário fazer o processo manualmente:

```bash
cd ~/dotfiles
git status
```

Ver alterações:

```bash
git diff
```

Adicionar:

```bash
git add .
```

Criar commit:

```bash
git commit -m "chore: update dotfiles"
```

Enviar:

```bash
git push
```

---

# 22. Atualizar os pacotes registrados

Se instalar ou remover pacotes do sistema, atualizar as listas.

Pacotes oficiais:

```bash
cd ~/dotfiles
pacman -Qqen | sort -u > packages-pacman.txt
```

Pacotes estrangeiros/AUR:

```bash
pacman -Qqem | sort -u > packages-aur.txt
```

Conferir:

```bash
wc -l packages-pacman.txt
wc -l packages-aur.txt
```

Depois sincronizar:

```bash
dots
```

---

# 23. Por que existem dois arquivos de pacotes?

`packages-pacman.txt`:

```text
pacman -Qqen
```

representa pacotes pertencentes aos repositórios oficiais.

`packages-aur.txt`:

```text
pacman -Qqem
```

representa pacotes instalados que não pertencem aos repositórios oficiais.

Isso permite separar:

```text
pacman
```

de:

```text
yay/AUR
```

durante a restauração.

---

# 24. Segurança

O repositório é privado.

Mesmo assim, nunca colocar nele:

- senhas;
- tokens;
- API keys;
- chaves privadas;
- certificados privados;
- cookies;
- credenciais;
- arquivos `.pem` privados;
- arquivos `.key` privados;
- arquivos contendo senhas.

Antes de sincronizar:

```bash
git status
git diff
```

Para procurar nomes suspeitos:

```bash
find . \
  -type f \
  -not -path './.git/*' \
  \( \
    -iname '*token*' \
    -o -iname '*secret*' \
    -o -iname '*credential*' \
    -o -iname '*.key' \
    -o -iname '*.pem' \
    -o -iname '*password*' \
    -o -iname '*passwd*' \
  \) \
  -print
```

Se aparecer um arquivo sensível, não fazer push até analisar.

---

# 25. O que não está necessariamente neste repositório

Este repositório contém configurações e listas de pacotes, mas não significa que todos os dados pessoais do computador estejam versionados.

Por exemplo, dados pessoais, documentos, biblioteca de estudos, banco de dados de aplicativos e outros arquivos de usuário podem estar fora do Git.

Portanto:

> **dotfiles não substituem backup pessoal.**

É necessário manter backups separados para:

- documentos;
- estudos;
- arquivos pessoais;
- bancos de dados importantes;
- arquivos de configuração que deliberadamente não devem ir para o Git;
- credenciais;
- arquivos armazenados exclusivamente na máquina.

---

# 26. O que fazer se um arquivo não puder ser restaurado

Primeiro verificar:

```bash
cd ~/dotfiles
git status
```

Depois:

```bash
ls
```

e:

```bash
find dot-config dot-local -maxdepth 3 -type f | sort
```

Verificar se o arquivo existe no repositório.

Se existir, verificar o link:

```bash
readlink -f /caminho/do/arquivo
```

Se não existir, verificar o histórico:

```bash
git log --all -- caminho/do/arquivo
```

Para restaurar uma versão anterior:

```bash
git log --all --oneline -- caminho/do/arquivo
```

---

# 27. Se o repositório estiver correto, mas o link estiver quebrado

Verificar:

```bash
ls -l /caminho/do/arquivo
```

Depois executar novamente:

```bash
cd ~/dotfiles
./bootstrap.sh
```

E testar o Stow:

```bash
stow --dotfiles --no-folding --restow --simulate .
```

---

# 28. Se houver conflito com um arquivo existente

Não apagar imediatamente.

Primeiro criar backup:

```bash
mkdir -p ~/.dotfiles-backup/manual
```

Mover o arquivo conflitante:

```bash
mv ~/.config/EXEMPLO ~/.dotfiles-backup/manual/
```

Depois executar novamente o bootstrap.

O procedimento exato depende do arquivo que estiver causando o conflito.

---

# 29. Atualizar o repositório de outra máquina

Se o repositório já estiver clonado:

```bash
cd ~/dotfiles
git pull --ff-only
```

Depois, se forem alterações de configuração:

```bash
stow --dotfiles --no-folding --restow .
```

Ou executar novamente:

```bash
./bootstrap.sh
```

---

# 30. Regra para novas configurações

Quando eu adicionar uma nova configuração ao sistema:

1. instalar o programa;
2. configurar normalmente;
3. descobrir onde a configuração foi salva;
4. mover/copiar a configuração para `~/dotfiles`;
5. organizar a estrutura para o Stow;
6. criar o link simbólico;
7. testar;
8. atualizar o repositório;
9. atualizar o README se a restauração exigir uma nova etapa.

A pergunta principal deve ser:

> "Se eu formatar amanhã, o bootstrap consegue recriar isso?"

Se a resposta for não, a configuração ainda não está completamente documentada/reproduzida.

---

# 31. Checklist de restauração

## Sistema

- [ ] CachyOS instalado
- [ ] Internet funcionando
- [ ] Sistema atualizado
- [ ] DMS/Hyprland instalado

## GitHub

- [ ] Git instalado
- [ ] GitHub CLI instalado
- [ ] `gh auth status` funcionando
- [ ] acesso a `VGViana/dotfilesv1`

## Repositório

- [ ] `~/dotfiles` clonado
- [ ] `git remote -v` correto
- [ ] `packages-pacman.txt` presente
- [ ] `packages-aur.txt` presente
- [ ] `bootstrap.sh` presente

## Pacotes

- [ ] pacotes oficiais instalados
- [ ] AUR helper instalado
- [ ] pacotes AUR instalados

## Dotfiles

- [ ] bootstrap executado
- [ ] Stow sem erros
- [ ] links simbólicos corretos
- [ ] Zsh funcionando
- [ ] Kitty funcionando
- [ ] Hyprland funcionando
- [ ] DMS funcionando
- [ ] Neovim funcionando
- [ ] Yazi funcionando
- [ ] Sioyek funcionando

## Validação

- [ ] `bash -n bootstrap.sh`
- [ ] `shellcheck bootstrap.sh`
- [ ] `git diff --check`
- [ ] `git status`
- [ ] reinicialização realizada
- [ ] ambiente visual conferido

---

# 32. Estado de referência deste repositório

A validação realizada na máquina de referência apresentou:

```text
Git                         OK
Bootstrap                   OK
Shell syntax                OK
ShellCheck                  OK
git diff --check            OK
Stow dry-run                OK
Symlinks principais         OK
Segredos por nome           nenhum encontrado
GitHub                      OK
Repositório                 privado
Branch                      main
Working tree                limpa
```

O repositório contém atualmente as listas de pacotes:

```text
Pacotes oficiais: 198
Pacotes AUR/foreign: 4
```

Esses números podem mudar no futuro. As listas dentro do próprio repositório são sempre a referência atual.

---

# 33. Comandos essenciais para lembrar

### Ver estado

```bash
cd ~/dotfiles
git status
```

### Atualizar do GitHub

```bash
cd ~/dotfiles
git pull --ff-only
```

### Sincronizar alterações

```bash
dots
```

### Atualizar lista de pacotes

```bash
cd ~/dotfiles
pacman -Qqen | sort -u > packages-pacman.txt
pacman -Qqem | sort -u > packages-aur.txt
dots
```

### Testar bootstrap

```bash
cd ~/dotfiles
bash -n bootstrap.sh
shellcheck bootstrap.sh
git diff --check
```

### Restaurar

```bash
cd ~/dotfiles
./bootstrap.sh
```

---

# 34. Restauração resumida

Em uma máquina nova:

```text
1. Instalar CachyOS
2. Conectar à internet
3. Atualizar o sistema
4. Instalar DMS/Hyprland
5. Instalar Git
6. Instalar GitHub CLI
7. Fazer gh auth login
8. Clonar ~/dotfiles
9. Instalar packages-pacman.txt
10. Instalar yay/AUR
11. Instalar packages-aur.txt
12. Executar ./bootstrap.sh
13. Verificar links
14. Executar os testes
15. Reiniciar
16. Conferir o ambiente
```

---

# 35. Objetivo final

O objetivo deste projeto é simples:

```text
PC novo
   │
   ▼
CachyOS
   │
   ▼
GitHub
   │
   ▼
~/dotfiles
   │
   ├── pacotes
   ├── configurações
   ├── scripts
   ├── Hyprland
   ├── DMS
   ├── Kitty
   ├── Neovim
   └── demais dotfiles
   │
   ▼
bootstrap.sh
   │
   ▼
ambiente restaurado
```

O repositório deve permitir que o "eu do futuro" não precise lembrar manualmente como este computador foi configurado.

**Se precisar formatar, não improvisar: seguir este README.**
