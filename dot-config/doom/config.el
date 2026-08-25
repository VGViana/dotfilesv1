;;; config.el -*- lexical-binding: t; -*-

;; ============================================================
;; IDENTIDADE
;; ============================================================

(setq user-full-name "Viana"
      user-mail-address "viniciusgazel@gmail.com")

;; ============================================================
;; APARÊNCIA
;; ============================================================

;; ------------------------------------------------------------
;; FONTE
;; ------------------------------------------------------------

(setq doom-font
      (font-spec
       :family "JetBrainsMono Nerd Font"
       :size 20))

(setq doom-variable-pitch-font
      (font-spec
       :family "Iosevka Nerd Font"
       :size 20 ))

(setq display-line-numbers-type 'relative)


;; ------------------------------------------------------------
;; GRUVBOX — TEMA ADAPTATIVO
;; ------------------------------------------------------------

;; Variantes disponíveis:
;;
;;   claro  → doom-gruvbox-light
;;   escuro → doom-gruvbox
;;
;; A variante escura usa "soft", mantendo a estética
;; Gruvbox Material Dark Soft que você já utiliza.

(setq doom-theme 'doom-gruvbox
      doom-gruvbox-dark-variant "soft")


(defun my/system-dark-mode-p ()
  "Retorna t quando o sistema está configurado para modo escuro."
  (let ((scheme
         (string-trim
          (shell-command-to-string
           "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null"))))
    (string= scheme "'prefer-dark'")))


(defun my/apply-system-theme ()
  "Aplica o tema Gruvbox de acordo com o modo claro/escuro do sistema."
  (let ((theme
         (if (my/system-dark-mode-p)
             'doom-gruvbox
           'doom-gruvbox-light)))

    ;; Desativa os temas atualmente carregados.
    (mapc #'disable-theme custom-enabled-themes)

    ;; Carrega o tema correspondente.
    (load-theme theme t)

    ;; No modo escuro, mantém a variante Soft.
    (when (eq theme 'doom-gruvbox)
      (setq doom-gruvbox-dark-variant "soft"))))


;; Aplica o tema quando o Emacs inicia.
(add-hook 'after-init-hook #'my/apply-system-theme)

;; ============================================================
;; PLSTORE / OAUTH
;; ============================================================

(setq plstore-cache-passphrase-for-symmetric-encryption t)


;; ============================================================
;; DASHBOARD
;; ============================================================

(setq +doom-dashboard-name "Central de Planejamento")


;; ============================================================
;; EVIL ESCAPE
;; ============================================================

(after! evil-escape
  (setq evil-escape-key-sequence "jk"
        evil-escape-delay 0.1))


;; ============================================================
;; ORG
;; ============================================================

(after! org

  ;; ----------------------------------------------------------
  ;; DIRETÓRIO
  ;; ----------------------------------------------------------

  (setq org-directory "~/Org/")


  ;; ----------------------------------------------------------
  ;; ARQUIVOS DA AGENDA
  ;;
  ;; Tudo que deve aparecer na Org Agenda entra aqui.
  ;;
  ;; routines.org          → rotina
  ;; habits.org            → hábitos
  ;; calendar-pessoal.org  → Google Calendar
  ;; tasks.org              → tarefas
  ;; inbox.org              → captura
  ;; ----------------------------------------------------------

  (setq org-agenda-files
        '("~/Org/inbox.org"
          "~/Org/tasks.org"
          "~/Org/routines.org"
          "~/Org/habits.org"
          "~/Org/calendar-pessoal.org"))


  ;; ----------------------------------------------------------
  ;; HÁBITOS
  ;; ----------------------------------------------------------

  (add-to-list 'org-modules 'org-habit)

  (setq org-habit-following-days 1
        org-habit-preceding-days 14
        org-habit-show-habits-only-for-today t)


  ;; ----------------------------------------------------------
  ;; LOG DE TAREFAS
  ;; ----------------------------------------------------------

  (setq org-log-done 'time
        org-log-into-drawer t)


  ;; ----------------------------------------------------------
  ;; ORG AGENDA
  ;; ----------------------------------------------------------

  (setq org-agenda-span 7)

  (setq org-agenda-start-on-weekday nil)

  (setq org-agenda-show-all-dates t)

  (setq org-agenda-window-setup 'current-window)

  (setq org-agenda-remove-tags t)

  (setq org-agenda-use-tag-inheritance nil)


  ;; ----------------------------------------------------------
  ;; GRADE HORÁRIA
  ;; ----------------------------------------------------------

  (setq org-agenda-time-grid
        '((daily today require-timed)
          (500 600 700 800 900 1000 1100 1200
           1300 1400 1500 1600 1700 1800
           1900 2000 2100 2200)
          "      "
          "      "))


  ;; ----------------------------------------------------------
  ;; FORMATO DOS EVENTOS
  ;; ----------------------------------------------------------

  (setq org-agenda-prefix-format
        '((agenda . " %?-5t ")
          (todo . " ")
          (tags . " ")
          (search . " ")))


  ;; ----------------------------------------------------------
  ;; REMOVER "SCHEDULED:" / "DEADLINE:"
  ;; ----------------------------------------------------------

  (setq org-agenda-scheduled-leaders
        '("" ""))

  (setq org-agenda-deadline-leaders
        '("" ""))


  ;; ----------------------------------------------------------
  ;; LINHA DO HORÁRIO ATUAL
  ;; ----------------------------------------------------------

  (setq org-agenda-current-time-string
        "━━━━━━━━━━ AGORA ━━━━━━━━━━")


  ;; ----------------------------------------------------------
  ;; CAPTURA
  ;; ----------------------------------------------------------

  (setq org-capture-templates
        '(

          ;; --------------------------------------------------
          ;; TAREFA
          ;; --------------------------------------------------

          ("t"
           "Tarefa"
           entry
           (file "~/Org/inbox.org")
           "* TODO %?\n  Criado em: %U\n"
           :kill-buffer t)


          ;; --------------------------------------------------
          ;; HÁBITO
          ;; --------------------------------------------------

          ("h"
           "Hábito"
           entry
           (file "~/Org/habits.org")
           "* TODO %?\nSCHEDULED: %t\n:PROPERTIES:\n:STYLE: habit\n:END:\n"
           :kill-buffer t)


          ;; --------------------------------------------------
          ;; NOTA
          ;; --------------------------------------------------

          ("n"
           "Nota"
           entry
           (file "~/Org/inbox.org")
           "* %?\n  Criado em: %U\n"
           :kill-buffer t))))


;; ============================================================
;; GOOGLE CALENDAR — ORG-GCAL
;; ============================================================

(load "~/.config/org-gcal/credentials.el")


(after! org-gcal

  ;; ----------------------------------------------------------
  ;; CREDENCIAIS
  ;; ----------------------------------------------------------

  (org-gcal-reload-client-id-secret)


  ;; ----------------------------------------------------------
  ;; ARQUIVO DO GOOGLE CALENDAR
  ;; ----------------------------------------------------------

  (setq org-gcal-file-alist
        '(("viniciusgazel@gmail.com"
           . "~/Org/calendar-pessoal.org")))


  ;; ----------------------------------------------------------
  ;; JANELA DE SINCRONIZAÇÃO
  ;; ----------------------------------------------------------

  (setq org-gcal-up-days 30)

  (setq org-gcal-down-days 90)


  ;; ----------------------------------------------------------
  ;; NOTIFICAÇÕES
  ;; ----------------------------------------------------------

  (setq org-gcal-notify-p nil)


  ;; ----------------------------------------------------------
  ;; EVENTOS CANCELADOS
  ;; ----------------------------------------------------------

  (setq org-gcal-remove-api-cancelled-events t))


;; ============================================================
;; GOOGLE CALENDAR → ORG AGENDA
;; ============================================================

(defun my/org-gcal-fetch-and-refresh ()
  "Busca eventos do Google Calendar e atualiza a Org Agenda."

  (interactive)

  (org-gcal-fetch)

  (when (derived-mode-p 'org-agenda-mode)
    (org-agenda-redo))

  (when (get-buffer "*Org Agenda*")
    (with-current-buffer "*Org Agenda*"
      (org-agenda-redo))))


;; ============================================================
;; AGENDA PERSONALIZADA
;; ============================================================

(after! org-agenda

  (setq org-agenda-custom-commands
        '(("a"
           "Agenda principal"
           agenda
           ""))))


;; ============================================================
;; ATALHOS
;; ============================================================

(map!

 :leader

 ;; ==========================================================
 ;; AGENDA
 ;; ==========================================================

 (:prefix ("a" . "Agenda")

  :desc "Agenda principal"
  "a" #'org-agenda

  :desc "Agenda de hoje"
  "d" (lambda ()
        (interactive)
        (org-agenda nil "a"))

  :desc "Recarregar agenda"
  "r" #'org-agenda-redo)


 ;; ==========================================================
 ;; CAPTURA
 ;; ==========================================================

 :desc "Capturar tarefa"
 "x" #'org-capture


 ;; ==========================================================
 ;; GOOGLE CALENDAR
 ;; ==========================================================

 (:prefix ("g" . "Google Calendar")

  :desc "Buscar Google Calendar"
  "f" #'my/org-gcal-fetch-and-refresh

  :desc "Enviar evento para Google Calendar"
  "p" #'org-gcal-post-at-point

  :desc "Sincronizar Google Calendar"
  "s" #'org-gcal-sync)


 ;; ==========================================================
 ;; ARQUIVOS ORG
 ;; ==========================================================

 (:prefix ("o" . "Org")

  :desc "Inbox"
  "i" (lambda ()
        (interactive)
        (find-file "~/Org/inbox.org"))

  :desc "Tarefas"
  "t" (lambda ()
        (interactive)
        (find-file "~/Org/tasks.org"))

  :desc "Hábitos"
  "h" (lambda ()
        (interactive)
        (find-file "~/Org/habits.org"))

  :desc "Rotina"
  "r" (lambda ()
        (interactive)
        (find-file "~/Org/routines.org"))

  :desc "Google Calendar"
  "c" (lambda ()
        (interactive)
        (find-file "~/Org/calendar-pessoal.org"))))


;; =============================================================================
;; CALFW — CALENDÁRIO VISUAL
;; =============================================================================

(use-package! calfw
  :after org
  :commands (calfw-open-calendar-buffer)

  :config

  ;; ---------------------------------------------------------------------------
  ;; CALENDÁRIO
  ;; ---------------------------------------------------------------------------

  (setq calendar-week-start-day 1)

  (setq calendar-day-name-array
        ["Dom" "Seg" "Ter" "Qua" "Qui" "Sex" "Sáb"])

  (setq calendar-month-name-array
        ["Janeiro"
         "Fevereiro"
         "Março"
         "Abril"
         "Maio"
         "Junho"
         "Julho"
         "Agosto"
         "Setembro"
         "Outubro"
         "Novembro"
         "Dezembro"])


  ;; ---------------------------------------------------------------------------
  ;; FERIADOS BRASILEIROS
  ;; ---------------------------------------------------------------------------

  (setq calendar-holidays

        '(
          ;; ===================================================================
          ;; FERIADOS NACIONAIS FIXOS
          ;; ===================================================================

          (holiday-fixed
           1 1
           "Confraternização Universal")

          (holiday-fixed
           4 21
           "Tiradentes")

          (holiday-fixed
           5 1
           "Dia Mundial do Trabalho")

          (holiday-fixed
           9 7
           "Independência do Brasil")

          (holiday-fixed
           10 12
           "Nossa Senhora Aparecida")

          (holiday-fixed
           11 2
           "Finados")

          (holiday-fixed
           11 15
           "Proclamação da República")

          (holiday-fixed
           11 20
           "Dia Nacional de Zumbi e da Consciência Negra")

          (holiday-fixed
           12 25
           "Natal")


          ;; ===================================================================
          ;; DATAS MÓVEIS
          ;; ===================================================================

          (holiday-easter-etc
           -49
           "Domingo de Carnaval")

          (holiday-easter-etc
           -48
           "Segunda-feira de Carnaval")

          (holiday-easter-etc
           -47
           "Terça-feira de Carnaval")

          (holiday-easter-etc
           -2
           "Sexta-feira Santa")

          (holiday-easter-etc
           60
           "Corpus Christi")))

  (setq calendar-mark-holidays-flag t)


  ;; ---------------------------------------------------------------------------
  ;; GRADE UNICODE
  ;; ---------------------------------------------------------------------------

  (setq calfw-fchar-junction ?╋
        calfw-fchar-vertical-line ?┃
        calfw-fchar-horizontal-line ?━
        calfw-fchar-left-junction ?┣
        calfw-fchar-right-junction ?┫
        calfw-fchar-top-junction ?┯
        calfw-fchar-top-left-corner ?┏
        calfw-fchar-top-right-corner ?┓)


  ;; ---------------------------------------------------------------------------
  ;; QUEBRA DE LINHAS
  ;; ---------------------------------------------------------------------------

  (setq calfw-render-line-breaker
        #'calfw-render-line-breaker-wordwrap)


  ;; ---------------------------------------------------------------------------
  ;; KEYBINDINGS ESTILO ORG
  ;; ---------------------------------------------------------------------------

  (setq calfw-org-overwrite-default-keybinding t))


;; =============================================================================
;; CALFW — ORG MODE
;; =============================================================================

(use-package! calfw-org
  :after (calfw org)

  :commands
  (calfw-org-open-calendar)

  :config

  (setq calfw-org-agenda-schedule-args
        '(:timestamp
          :scheduled
          :deadline)))


;; =============================================================================
;; CALFW — GRUVBOX MATERIAL DARK SOFT
;; =============================================================================

(after! calfw

  (custom-set-faces

   '(calfw-face-title
     ((t (:foreground "#d4be98"
          :weight bold
          :height 1.5
          :inherit variable-pitch))))

   '(calfw-face-header
     ((t (:foreground "#a9b665"
          :weight bold))))

   '(calfw-face-sunday
     ((t (:foreground "#ea6962"
          :weight bold))))

   '(calfw-face-saturday
     ((t (:foreground "#7daea3"
          :weight bold))))

   '(calfw-face-holiday
     ((t (:foreground "#ea6962"
          :weight bold))))

   '(calfw-face-grid
     ((t (:foreground "#504945"))))

   '(calfw-face-default-content
     ((t (:foreground "#d4be98"))))

   '(calfw-face-periods
     ((t (:foreground "#d8a657"
          :weight bold))))

   '(calfw-face-day-title
     ((t (:foreground "#d4be98"))))

   '(calfw-face-default-day
     ((t (:foreground "#d4be98"
          :weight bold))))

   '(calfw-face-today-title
     ((t (:background "#3c3836"
          :foreground "#a9b665"
          :weight bold))))

   '(calfw-face-today
     ((t (:background "#32302f"
          :weight bold))))

   '(calfw-face-select
     ((t (:background "#45403d"))))

   '(calfw-face-annotation
     ((t (:foreground "#928374"))))

   '(calfw-face-disable
     ((t (:foreground "#665c54"))))))


;; =============================================================================
;; CALFW — COMANDO PRINCIPAL
;; =============================================================================

(defun my/calfw-calendar ()
  "Abrir o calendário visual da rotina baseada na Org Agenda."

  (interactive)

  (require 'calfw)
  (require 'calfw-org)

  (calfw-open-calendar-buffer
   :contents-sources
   (list
    (calfw-org-create-source
     nil
     "Agenda"
     "#a9b665"))))


;; =============================================================================
;; CALFW — ATALHO PRINCIPAL
;; =============================================================================

(map! :leader
      :prefix ("o" . "organização")

      :desc "Calendário visual"
      "a" #'my/calfw-calendar)


;; =============================================================================
;; CALFW — EVIL KEYBINDINGS
;; =============================================================================

(after! calfw
  (evil-define-key 'normal calfw-calendar-mode-map

    (kbd "M") #'calfw-change-view-month
    (kbd "W") #'calfw-change-view-week
    (kbd "T") #'calfw-change-view-two-weeks
    (kbd "D") #'calfw-change-view-day

    (kbd "r") #'calfw-refresh-calendar-buffer

    (kbd "q") #'bury-buffer))


;; ============================================================
;; ORG MODE — GRUVBOX MATERIAL DARK SOFT
;; ============================================================

(after! org

  ;; ----------------------------------------------------------
  ;; TIPOGRAFIA E ESTRUTURA VISUAL
  ;; ----------------------------------------------------------

  (setq org-hide-emphasis-markers t
        org-pretty-entities t
        org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-cycle-separator-lines 1
        org-ellipsis " 󰅂")


  ;; ----------------------------------------------------------
  ;; ORG MODERN
  ;; ----------------------------------------------------------

  (use-package! org-modern
    :hook (org-mode . org-modern-mode)

    :config

    (setq org-modern-star 'replace

          org-modern-list
          '((?+ . "•")
            (?- . "•")
            (?* . "•"))

          org-modern-checkbox
          '((?X . "󰄲")
            (?- . "󰡖")
            (?\s . "󰄱"))

          org-modern-block-name
          '((t . t))

          org-modern-keyword
          '((t . t))

          org-modern-table nil

          org-modern-tag nil
          org-modern-priority nil
          org-modern-todo nil
          org-modern-time nil
          org-modern-date nil

          org-modern-horizontal-rule
          "────────────────────────"))


  ;; ----------------------------------------------------------
  ;; FACES — GRUVBOX MATERIAL DARK SOFT
  ;; ----------------------------------------------------------

  (custom-set-faces!

    ;; --------------------------------------------------------
    ;; TÍTULO
    ;; --------------------------------------------------------

    '(org-document-title
      :foreground "#d4be98"
      :weight bold
      :height 1.35)


    ;; --------------------------------------------------------
    ;; HEADINGS
    ;; --------------------------------------------------------

    '(org-level-1
      :foreground "#d8a657"
      :weight bold
      :height 1.20)

    '(org-level-2
      :foreground "#a9b665"
      :weight bold
      :height 1.12)

    '(org-level-3
      :foreground "#7daea3"
      :weight bold
      :height 1.07)

    '(org-level-4
      :foreground "#d3869b"
      :weight bold
      :height 1.04)

    '(org-level-5
      :foreground "#89b482"
      :weight bold)

    '(org-level-6
      :foreground "#d8a657"
      :weight bold)


    ;; --------------------------------------------------------
    ;; TODO / DONE
    ;; --------------------------------------------------------

    '(org-todo
      :foreground "#e78a4e"
      :weight bold)

    '(org-done
      :foreground "#a9b665"
      :weight bold)


    ;; --------------------------------------------------------
    ;; LINKS
    ;; --------------------------------------------------------

    '(org-link
      :foreground "#d8a657"
      :underline nil)


    ;; --------------------------------------------------------
    ;; TAGS / METADATA
    ;; --------------------------------------------------------

    '(org-tag
      :foreground "#928374"
      :weight normal)

    '(org-meta-line
      :foreground "#928374")

    '(org-drawer
      :foreground "#7c6f64")


    ;; --------------------------------------------------------
    ;; DATAS
    ;; --------------------------------------------------------

    '(org-date
      :foreground "#7daea3"
      :underline nil)

    '(org-scheduled
      :foreground "#a9b665")

    '(org-deadline
      :foreground "#e78a4e")


    ;; --------------------------------------------------------
    ;; CODE / VERBATIM
    ;; --------------------------------------------------------

    '(org-code
      :foreground "#89b482")

    '(org-verbatim
      :foreground "#d3869b")


    ;; --------------------------------------------------------
    ;; BLOCOS DE CÓDIGO
    ;; --------------------------------------------------------

    '(org-block
      :background "#292827"
      :extend t)

    '(org-block-begin-line
      :foreground "#665c54"
      :background "#292827")

    '(org-block-end-line
      :foreground "#665c54"
      :background "#292827")


    ;; --------------------------------------------------------
    ;; CHECKBOX
    ;; --------------------------------------------------------

    '(org-checkbox
      :foreground "#d8a657"
      :weight bold)


    ;; --------------------------------------------------------
    ;; PROPRIEDADES
    ;; --------------------------------------------------------

    '(org-special-keyword
      :foreground "#7daea3")

    '(org-property-value
      :foreground "#b8bb26")))


;; ============================================================
;; ORG MODE — LEITURA
;; ============================================================

(defun my/org-visual-setup ()
  "Aplicar refinamentos visuais de leitura ao Org."
  (variable-pitch-mode 1))

(add-hook 'org-mode-hook #'my/org-visual-setup)


;; ============================================================
;; CONFIGURAÇÃO FINAL
;; ============================================================

(setq org-agenda-window-setup 'current-window)

(setq confirm-kill-emacs nil)
