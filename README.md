# Fedora Dotfiles

Configuração completa e reproduzível do meu ambiente **Fedora + Hyprland + DankMaterialShell**.

Este repositório existe para uma finalidade simples:

> **Se eu precisar reinstalar o Fedora ou trocar de computador, quero conseguir reconstruir meu ambiente com o mínimo possível de configuração manual.**

A branch `fedora` é a fonte oficial das configurações do ambiente Fedora.

---

## ✨ O que este repositório faz

Este repositório centraliza:

* configurações do **Hyprland**
* **DankMaterialShell (DMS)**
* **Kitty**
* **Zsh**
* **Neovim**
* **Yazi**
* **Sioyek**
* **GTK / Qt**
* **PipeWire / WirePlumber**
* configurações de Wayland
* scripts pessoais
* configurações do terminal
* atalhos
* temas
* fontes
* ferramentas de produtividade
* lista de pacotes necessários
* restauração automática do ambiente

A ideia é transformar:

```text
Fedora recém-instalado
        ↓
internet
        ↓
Git + SSH
        ↓
bootstrap.sh
        ↓
pacotes
        ↓
configurações
        ↓
GNU Stow
        ↓
ambiente restaurado
```

---

# 🖥️ Ambiente

A configuração foi construída para um desktop Wayland utilizando:

| Componente    | Software               |
| ------------- | ---------------------- |
| Sistema       | Fedora Linux           |
| Compositor    | Hyprland               |
| Desktop shell | DankMaterialShell      |
| Terminal      | Kitty                  |
| Shell         | Zsh                    |
| Editor        | Neovim                 |
| File manager  | Yazi                   |
| PDF           | Sioyek                 |
| Áudio         | PipeWire + WirePlumber |
| Dotfiles      | GNU Stow               |
| Versionamento | Git                    |
| GitHub        | GitHub CLI             |
| Fontes        | JetBrains Mono / Noto  |

O ambiente utiliza uma estética inspirada em **Gruvbox Material**, priorizando uma interface minimalista, confortável e funcional.

---

# 📁 Estrutura

A estrutura principal do repositório é:

```text
dotfilesv1/
│
├── README.md
├── bootstrap.sh
├── init-github.sh
├── packages-fedora.txt
│
├── dot-.Xresources
├── dot-.bash_profile
├── dot-.bashrc
├── dot-.gtkrc-2.0
├── dot-.zshrc
│
├── dot-config/
│   ├── DankMaterialShell/
│   ├── btop/
│   ├── dankcal/
│   ├── dgop/
│   ├── environment.d/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   ├── hypr/
│   ├── kitty/
│   ├── nvim/
│   ├── qt5ct/
│   ├── qt6ct/
│   ├── sioyek/
│   ├── xsettingsd/
│   ├── yazi/
│   └── ...
│
└── dot-local/
    └── bin/
        ├── dots
        └── ...
```

---

# 🧠 Como os dotfiles funcionam

Os arquivos dentro de:

```text
~/dotfiles
```

são a **fonte da verdade**.

As configurações são vinculadas ao `$HOME` utilizando **GNU Stow**.

Por exemplo:

```text
~/dotfiles/dot-config/kitty/kitty.conf
                    │
                    │ GNU Stow
                    ▼
~/.config/kitty/kitty.conf
```

O arquivo em `~/.config` é um link para o arquivo dentro do repositório.

Isso significa que:

> **As configurações importantes devem ser alteradas dentro de `~/dotfiles`, e não diretamente no arquivo vinculado.**

Para confirmar:

```bash
readlink -f ~/.config/kitty/kitty.conf
```

O resultado deverá apontar para algo semelhante a:

```text
/home/SEU_USUARIO/dotfiles/dot-config/kitty/kitty.conf
```

---

# 🚀 Instalação em um PC novo

## ⚠️ Antes de começar

Este README assume que:

1. o Fedora já foi instalado;
2. você está logado no usuário que utilizará o ambiente;
3. a máquina possui conexão com a internet;
4. você possui acesso ao repositório no GitHub.

Não é necessário copiar manualmente cada configuração.

O `bootstrap.sh` foi criado justamente para automatizar isso.

---

# 1. Instale o Fedora

Instale o Fedora normalmente.

Depois de entrar no sistema, abra um terminal.

Atualize o sistema:

```bash
sudo dnf5 upgrade --refresh
```

Se o seu Fedora não possuir `dnf5`, o bootstrap utiliza `dnf` automaticamente.

---

# 2. Configure a internet

Certifique-se de que a máquina está conectada à internet.

Você pode testar com:

```bash
ping -c 3 github.com
```

Se funcionar, continue.

---

# 3. Configure o acesso ao GitHub

O repositório utiliza Git e SSH.

O bootstrap instala os componentes necessários, mas o acesso ao GitHub precisa estar funcionando.

Verifique se o Git está disponível:

```bash
git --version
```

Verifique o SSH:

```bash
ssh -V
```

---

# 4. Configure sua chave SSH

Se você ainda não possui uma chave SSH:

```bash
ssh-keygen -t ed25519 -C "seu-email"
```

Pressione `Enter` para aceitar o caminho padrão.

Depois inicie o agente:

```bash
eval "$(ssh-agent -s)"
```

Adicione a chave:

```bash
ssh-add ~/.ssh/id_ed25519
```

Mostre a chave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copie o conteúdo inteiro.

No GitHub:

```text
Settings
→ SSH and GPG keys
→ New SSH key
```

Cole a chave pública.

Teste:

```bash
ssh -T git@github.com
```

Se aparecer uma mensagem indicando que a autenticação foi realizada com sucesso, continue.

---

# 5. Clone o repositório

Clone especificamente a branch Fedora:

```bash
git clone \
  --branch fedora \
  --single-branch \
  git@github.com:VGViana/dotfilesv1.git \
  ~/dotfiles
```

Entre no diretório:

```bash
cd ~/dotfiles
```

Confirme:

```bash
git branch --show-current
```

O resultado esperado é:

```text
fedora
```

Confira o remote:

```bash
git remote -v
```

---

# 6. Execute o bootstrap

Agora vem a parte principal.

Execute:

```bash
cd ~/dotfiles
./bootstrap.sh
```

Se o arquivo não estiver executável:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

---

# 🤖 O que o `bootstrap.sh` faz?

O script automatiza a restauração do ambiente.

Ele:

1. verifica se o sistema é Fedora;
2. verifica o `sudo`;
3. escolhe `dnf5` ou `dnf`;
4. atualiza os metadados do sistema;
5. instala dependências básicas;
6. instala Git e ferramentas necessárias;
7. configura o repositório do DankMaterialShell;
8. clona ou atualiza os dotfiles;
9. instala os pacotes registrados em `packages-fedora.txt`;
10. instala o DankMaterialShell;
11. instala componentes opcionais do DMS;
12. cria backup das configurações existentes;
13. restaura `~/.config`;
14. restaura `~/.local`;
15. restaura arquivos do `$HOME`;
16. executa GNU Stow;
17. corrige permissões dos scripts;
18. recarrega serviços do usuário;
19. configura PipeWire/WirePlumber;
20. configura Zsh como shell padrão;
21. verifica arquivos importantes;
22. informa se a restauração foi concluída.

O script atualmente utiliza a branch:

```text
fedora
```

e o diretório padrão:

```text
~/dotfiles
```

---

# 📦 Pacotes

Os pacotes do ambiente Fedora ficam em:

```text
packages-fedora.txt
```

A lista inclui ferramentas de:

* sistema
* terminal
* Wayland
* Hyprland
* áudio
* Bluetooth
* rede
* hardware
* GTK
* Qt
* desenvolvimento
* GitHub
* produtividade
* fontes

Exemplos:

```text
hyprland
kitty
zsh
neovim
yazi
fzf
ripgrep
bat
eza
zoxide
starship
btop
pipewire
wireplumber
bluez
NetworkManager
jetbrains-mono-fonts
gh
```

A lista completa está no próprio arquivo.

---

# 🔄 Restaurar novamente

Se alguma configuração quebrar, você pode executar novamente:

```bash
cd ~/dotfiles
./bootstrap.sh
```

O script cria backups das configurações existentes antes de substituí-las.

Os backups ficam em:

```text
~/.dotfiles-backup/
```

Por exemplo:

```text
~/.dotfiles-backup/20260903-120000/
```

---

# ⚠️ Não apague `~/.config` manualmente

Não faça:

```bash
rm -rf ~/.config
```

nem:

```bash
rm -rf ~/.local
```

antes de tentar o bootstrap.

O objetivo do `bootstrap.sh` é justamente preservar configurações existentes através de backup.

---

# 🔗 GNU Stow

Depois da restauração, o GNU Stow cria os links necessários.

Você pode testar sem modificar nada:

```bash
cd ~/dotfiles

stow \
  --restow \
  --dotfiles \
  --no-folding \
  --simulate \
  .
```

O modo:

```text
--simulate
```

significa que nada será alterado.

---

# 🔍 Verificando os links

Depois do bootstrap, você pode verificar arquivos importantes:

```bash
readlink -f ~/.zshrc
readlink -f ~/.config/hypr/hyprland.lua
readlink -f ~/.config/kitty/kitty.conf
readlink -f ~/.config/nvim/init.lua
readlink -f ~/.config/yazi/yazi.toml
readlink -f ~/.config/sioyek/prefs_user.config
readlink -f ~/.config/DankMaterialShell/settings.json
```

Eles devem apontar para:

```text
~/dotfiles/...
```

---

# 🧪 Verificação do bootstrap

Antes de considerar o repositório saudável:

```bash
cd ~/dotfiles
```

Verifique a sintaxe:

```bash
bash -n bootstrap.sh
```

Verifique problemas comuns no shell:

```bash
shellcheck bootstrap.sh
```

Verifique problemas de whitespace no Git:

```bash
git diff --check
```

---

# 🔄 Depois da instalação

Quando tudo estiver restaurado:

```bash
systemctl reboot
```

Depois do login, verifique:

* Hyprland
* DankMaterialShell
* Kitty
* Zsh
* Neovim
* Yazi
* Sioyek
* GTK
* Qt
* áudio
* Bluetooth
* atalhos
* scripts
* temas
* fontes

Se tudo estiver funcionando, a máquina está essencialmente restaurada.

---

# 🛠️ Fluxo normal de trabalho

Depois que o ambiente estiver configurado, o fluxo é:

```text
alterar configuração
        ↓
~/dotfiles
        ↓
testar
        ↓
dots
        ↓
git commit
        ↓
GitHub
```

A regra principal é:

> **Edite a configuração e depois sincronize o repositório.**

---

# ⚡ Comando `dots`

O comando:

```bash
dots
```

é responsável por sincronizar as configurações atuais do sistema com o repositório.

Ele:

1. verifica se você está no repositório correto;
2. verifica se está na branch `fedora`;
3. copia configurações do `$HOME`;
4. copia configurações de `~/.config`;
5. copia scripts de `~/.local/bin`;
6. remove arquivos gerados automaticamente;
7. remove estados pessoais/sensíveis conhecidos;
8. atualiza o `.gitignore`;
9. mostra as alterações;
10. cria o commit;
11. envia a branch `fedora` para o GitHub.

Uso normal:

```bash
dots
```

---

# 🧪 Testar antes de enviar

Se você quiser apenas verificar o que seria sincronizado:

```bash
dots --dry-run
```

Esse modo **não cria commit e não faz push**.

É a opção recomendada antes de uma sincronização importante.

---

# 📤 Sincronização manual

Se por algum motivo o `dots` não puder ser utilizado:

```bash
cd ~/dotfiles
```

Verifique:

```bash
git status
```

Veja as alterações:

```bash
git diff
```

Adicione:

```bash
git add .
```

Faça o commit:

```bash
git commit -m "chore: update Fedora dotfiles"
```

Envie:

```bash
git push origin fedora
```

---

# 📥 Atualizar os dotfiles

Se o GitHub tiver uma versão mais recente:

```bash
cd ~/dotfiles
git pull --ff-only origin fedora
```

Se for necessário restaurar as configurações após a atualização:

```bash
./bootstrap.sh
```

---

# 📦 Atualizando a lista de pacotes

Sempre que instalar ou remover pacotes importantes do sistema, a lista deve ser atualizada.

Para gerar novamente:

```bash
rpm -qa --qf '%{NAME}\n' | sort -u > packages-fedora.txt
```

⚠️ Antes de substituir a lista oficial, revise o resultado.

Nem todo pacote instalado pelo Fedora necessariamente deve ser tratado como uma dependência direta dos dotfiles.

Depois:

```bash
git diff -- packages-fedora.txt
```

E, se estiver correto:

```bash
dots
```

---

# 🧹 Arquivos que não devem ser versionados

O script `dots` remove automaticamente diversos tipos de estado pessoal ou gerado antes da sincronização.

Entre eles:

```text
*.bak
*.backup*
*.old
*.db
*.db-shm
*.db-wal
cookie
privateKey.pem
certificate.pem
session/
akonadi/
dconf/
pulse/
.cache/
.firstlaunch
```

Também são removidos dados pessoais específicos de aplicativos quando encontrados.

---

# 🔐 Segurança

Mesmo sendo um repositório de configurações, **nunca coloque secrets aqui**.

Nunca versionar:

```text
senhas
tokens
API keys
SSH private keys
certificados privados
cookies
credenciais
arquivos .pem privados
arquivos .key privados
bancos de dados contendo informações pessoais
```

Antes de executar:

```bash
dots
```

é recomendado verificar:

```bash
git status
```

e:

```bash
git diff
```

Se algo suspeito aparecer, **não faça push**.

---

# 🆘 Troubleshooting

## `bootstrap.sh` não executa

Execute:

```bash
chmod +x bootstrap.sh
```

Depois:

```bash
./bootstrap.sh
```

---

## O sistema não é reconhecido como Fedora

O bootstrap verifica:

```text
/etc/os-release
```

Ele só continua quando:

```text
ID=fedora
```

Isso é proposital.

Este bootstrap **não é um instalador genérico para outras distribuições**.

---

## O GitHub rejeita o clone

Teste:

```bash
ssh -T git@github.com
```

Se não funcionar, configure sua chave SSH e adicione a chave pública à sua conta do GitHub.

---

## O arquivo existe no repositório, mas não aparece no sistema

Verifique:

```bash
readlink -f /caminho/do/arquivo
```

Depois:

```bash
cd ~/dotfiles
```

Teste o Stow:

```bash
stow \
  --restow \
  --dotfiles \
  --no-folding \
  --simulate \
  .
```

Se estiver correto, execute novamente:

```bash
./bootstrap.sh
```

---

## Existe conflito com uma configuração existente

Não apague imediatamente.

Faça backup manual:

```bash
mkdir -p ~/.dotfiles-backup/manual
```

Depois mova o arquivo:

```bash
mv ~/.config/ARQUIVO ~/.dotfiles-backup/manual/
```

Execute novamente:

```bash
cd ~/dotfiles
./bootstrap.sh
```

---

## O `dots` não funciona

Verifique:

```bash
command -v dots
```

Se não aparecer:

```bash
ls -l ~/.local/bin/dots
```

E:

```bash
echo "$PATH"
```

O diretório:

```text
~/.local/bin
```

precisa estar no `PATH`.

---

# 🧯 Recuperação de emergência

Em uma máquina Fedora nova, depois de configurar o acesso SSH ao GitHub, o fluxo principal é:

```bash
git clone \
  --branch fedora \
  --single-branch \
  git@github.com:VGViana/dotfilesv1.git \
  ~/dotfiles && \
cd ~/dotfiles && \
./bootstrap.sh
```

Esse é o **comando de restauração principal**.

Se algo falhar:

1. leia a mensagem de erro;
2. corrija o problema indicado;
3. execute novamente o comando correspondente;
4. não apague configurações aleatoriamente.

---

# 🧭 Filosofia do repositório

Este repositório segue algumas regras simples:

### 1. O Git é a fonte da verdade

```text
GitHub
  ↓
~/dotfiles
  ↓
$HOME
```

### 2. Configuração deve ser reproduzível

Se uma configuração for importante para o funcionamento do ambiente, ela deve estar versionada.

### 3. Estado pessoal não pertence aos dotfiles

Configurações pessoais, bancos de dados, caches e credenciais devem permanecer fora do Git.

### 4. Automatize o que puder

O objetivo não é memorizar dezenas de comandos.

O objetivo é:

```text
instalar Fedora
      ↓
configurar acesso ao GitHub
      ↓
executar bootstrap
      ↓
reiniciar
      ↓
trabalhar
```

### 5. Backup continua sendo necessário

Dotfiles **não são backup de dados pessoais**.

Este repositório não substitui backups de:

* documentos;
* fotos;
* arquivos pessoais;
* biblioteca de estudos;
* bancos de dados importantes;
* arquivos que não estão versionados;
* credenciais;
* dados armazenados exclusivamente na máquina.

---

# 📋 Checklist — PC novo

Use esta sequência:

```text
[ ] Instalar Fedora
[ ] Conectar à internet
[ ] Atualizar Fedora
[ ] Configurar chave SSH
[ ] Testar acesso ao GitHub
[ ] Clonar branch fedora
[ ] Executar bootstrap.sh
[ ] Conferir mensagens do bootstrap
[ ] Reiniciar
[ ] Testar Hyprland
[ ] Testar DMS
[ ] Testar Kitty
[ ] Testar Zsh
[ ] Testar Neovim
[ ] Testar Yazi
[ ] Testar Sioyek
[ ] Testar áudio
[ ] Testar atalhos
[ ] Testar scripts
[ ] Conferir links do Stow
[ ] Conferir git status
```

---

# ✅ Quando considerar a restauração concluída?

A restauração pode ser considerada concluída quando:

```bash
cd ~/dotfiles
```

e:

```bash
git status
```

não apresentar alterações inesperadas.

Além disso:

```bash
readlink -f ~/.zshrc
```

e os principais arquivos de configuração devem apontar para:

```text
~/dotfiles/...
```

Por fim:

```bash
bash -n bootstrap.sh
shellcheck bootstrap.sh
git diff --check
```

devem terminar sem erros relevantes.

---

# 📌 Resumo rápido

### Instalar do zero

```bash
git clone \
  --branch fedora \
  --single-branch \
  git@github.com:VGViana/dotfilesv1.git \
  ~/dotfiles

cd ~/dotfiles

./bootstrap.sh
```

### Sincronizar alterações

```bash
dots
```

### Testar sem enviar

```bash
dots --dry-run
```

### Atualizar do GitHub

```bash
cd ~/dotfiles
git pull --ff-only origin fedora
```

### Testar o bootstrap

```bash
bash -n bootstrap.sh
shellcheck bootstrap.sh
git diff --check
```

---

# 📜 Licença / Uso

Este repositório é, прежде de tudo, uma configuração pessoal.

Os arquivos podem conter decisões específicas do meu hardware, preferências pessoais e escolhas feitas para o meu ambiente.

Se você utilizar este repositório como base para outro computador:

> **Revise as configurações antes de assumir que tudo é adequado para seu hardware.**

Especialmente:

* Hyprland;
* monitores;
* atalhos;
* áudio;
* energia;
* scripts;
* dispositivos;
* caminhos de arquivos;
* configurações específicas do Fedora.

---

## 🐧 Fedora + Hyprland

```text
╭────────────────────────────────────────────╮
│                                            │
│          FEDORA DOTFILES                   │
│                                            │
│          Hyprland + DMS                    │
│                                            │
│       Reproducible Linux Setup             │
│                                            │
╰────────────────────────────────────────────╯
```

**Objetivo:** instalar uma vez, configurar corretamente e conseguir reconstruir tudo novamente quando necessário.
