;;; config.el -*- lexical-binding: t; -*-

;; ============================================================================
;; Viana 2.0 — Doom Emacs
;; Sistema pessoal de estudo, planejamento e produtividade
;; ============================================================================


;; ============================================================================
;; IDENTIDADE
;; ============================================================================

(setq user-full-name "Viana"
      user-mail-address "viniciusgazel@gmail.com")


;; ============================================================================
;; APARÊNCIA
;; ============================================================================

;; ----------------------------------------------------------------------------
;; Fonte principal
;; ----------------------------------------------------------------------------

(setq doom-font
      (font-spec
       :family "JetBrainsMono Nerd Font"
       :size 20)

      doom-variable-pitch-font
      (font-spec
       :family "Iosevka Nerd Font"
       :size 20)

      display-line-numbers-type 'relative)


;; ----------------------------------------------------------------------------
;; Tema Gruvbox adaptativo por horário
;;
;; 08:00 → 16:59   Gruvbox Light
;; 17:00 → 07:59   Gruvbox Dark Soft
;;
;; Não depende do GNOME/gsettings.
;; ----------------------------------------------------------------------------

(setq doom-theme 'doom-gruvbox
      doom-gruvbox-dark-variant "soft")

(defvar my/theme-timer nil
  "Timer responsável pela troca automática de tema.")

(defun my/theme-for-current-time ()
  "Retorna o tema adequado ao horário atual."
  (let ((hour (string-to-number (format-time-string "%H"))))
    (if (and (>= hour 8)
             (< hour 17))
        'doom-gruvbox-light
      'doom-gruvbox)))

(defun my/apply-time-based-theme ()
  "Aplica o tema correspondente ao horário atual."
  (interactive)

  (let ((desired-theme (my/theme-for-current-time))
        (current-theme (car custom-enabled-themes)))

    ;; Evita recarregar o tema desnecessariamente.
    (unless (eq current-theme desired-theme)

      ;; Mantém a variante Soft no tema escuro.
      (when (eq desired-theme 'doom-gruvbox)
        (setq doom-gruvbox-dark-variant "soft"))

      ;; Desativa temas anteriores.
      (mapc #'disable-theme custom-enabled-themes)

      ;; Carrega o novo tema.
      (load-theme desired-theme t))))

(defun my/start-theme-timer ()
  "Inicia o relógio de troca automática de tema."
  (when (timerp my/theme-timer)
    (cancel-timer my/theme-timer))

  ;; Verifica a cada 15 minutos.
  (setq my/theme-timer
        (run-at-time 0 900 #'my/apply-time-based-theme)))

(add-hook 'after-init-hook
          #'my/apply-time-based-theme)

(add-hook 'after-init-hook
          #'my/start-theme-timer)


;; ============================================================================
;; PLSTORE / OAUTH
;; ============================================================================

(setq plstore-cache-passphrase-for-symmetric-encryption t)


;; ============================================================================
;; DASHBOARD
;; ============================================================================

(setq +doom-dashboard-name "Central de Planejamento")


;; ============================================================================
;; EVIL
;; ============================================================================

(after! evil-escape
  (setq evil-escape-key-sequence "jk"
        evil-escape-delay 0.1))


;; ============================================================================
;; ORG MODE
;; ============================================================================

(after! org

  ;; --------------------------------------------------------------------------
  ;; Diretório principal
  ;; --------------------------------------------------------------------------

  (setq org-directory "~/Org/"
        org-default-notes-file "~/Org/inbox.org")


  ;; --------------------------------------------------------------------------
  ;; Arquivos da agenda
  ;;
  ;; Mantemos explícitos os arquivos estruturais do sistema.
  ;; Isso evita que notas comuns apareçam acidentalmente na agenda.
  ;; --------------------------------------------------------------------------

  (setq org-agenda-files
        '("~/Org/inbox.org"
          "~/Org/tasks.org"
          "~/Org/routines.org"
          "~/Org/habits.org"
          "~/Org/calendar-pessoal.org"))


  ;; --------------------------------------------------------------------------
  ;; Aparência / comportamento
  ;; --------------------------------------------------------------------------

  (setq org-hide-emphasis-markers t
        org-pretty-entities t
        org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-cycle-separator-lines 1
        org-ellipsis " 󰅂"
        org-startup-indented t
        org-startup-folded 'content
        org-use-speed-commands t)


  ;; --------------------------------------------------------------------------
  ;; TODO
  ;; --------------------------------------------------------------------------

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "NEXT(n)"
           "WAIT(w)"
           "|"
           "DONE(d)"
           "CANCELLED(c)")))

  (setq org-use-fast-todo-selection 'expert
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t)


  ;; --------------------------------------------------------------------------
  ;; Logging
  ;; --------------------------------------------------------------------------

  (setq org-log-done 'time
        org-log-into-drawer t)


  ;; --------------------------------------------------------------------------
  ;; Prioridades
  ;; --------------------------------------------------------------------------

  (setq org-priority-faces
        '((?A . (:foreground "#e78a4e" :weight bold))
          (?B . (:foreground "#d8a657" :weight bold))
          (?C . (:foreground "#7daea3" :weight bold))))


  ;; --------------------------------------------------------------------------
  ;; Links
  ;; --------------------------------------------------------------------------

  (setq org-return-follows-link t
        org-link-descriptive t)


  ;; --------------------------------------------------------------------------
  ;; Agenda
  ;; --------------------------------------------------------------------------

  (setq org-agenda-span 7
        org-agenda-start-on-weekday nil
        org-agenda-show-all-dates t
        org-agenda-window-setup 'current-window
        org-agenda-remove-tags t
        org-agenda-use-tag-inheritance nil
        org-agenda-compact-blocks nil
        org-agenda-block-separator ?─
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t)


  ;; --------------------------------------------------------------------------
  ;; Ordenação da agenda
  ;; --------------------------------------------------------------------------

  (setq org-agenda-sorting-strategy
        '((agenda time-up priority-down category-keep)
          (todo priority-down category-keep)
          (tags priority-down category-keep)
          (search category-keep)))


  ;; --------------------------------------------------------------------------
  ;; Grade horária
  ;; --------------------------------------------------------------------------

  (setq org-agenda-time-grid
        '((daily today require-timed)
          (600 700 800 900 1000 1100 1200
           1300 1400 1500 1600 1700 1800
           1900 2000 2100 2200 2300)
          "      "
          "      "))


  ;; --------------------------------------------------------------------------
  ;; Prefixos
  ;; --------------------------------------------------------------------------

  (setq org-agenda-prefix-format
        '((agenda . " %?-5t ")
          (todo . " ")
          (tags . " ")
          (search . " ")))


  ;; --------------------------------------------------------------------------
  ;; Remover SCHEDULED / DEADLINE visualmente
  ;; --------------------------------------------------------------------------

  (setq org-agenda-scheduled-leaders
        '("" "")

        org-agenda-deadline-leaders
        '("" ""))


  ;; --------------------------------------------------------------------------
  ;; Indicador do horário atual
  ;; --------------------------------------------------------------------------

  (setq org-agenda-current-time-string
        "━━━━━━━━━━ AGORA ━━━━━━━━━━")


  ;; --------------------------------------------------------------------------
  ;; Agenda semanal começa no dia atual
  ;; --------------------------------------------------------------------------

  (setq org-agenda-start-day nil)


  ;; --------------------------------------------------------------------------
  ;; Hábitos
  ;; --------------------------------------------------------------------------

  (add-to-list 'org-modules 'org-habit)

  (setq org-habit-following-days 1
        org-habit-preceding-days 14
        org-habit-show-habits-only-for-today t)


  ;; --------------------------------------------------------------------------
  ;; Captura
  ;; --------------------------------------------------------------------------

  (setq org-capture-templates

        '(

          ;; ---------------------------------------------------------------
          ;; Tarefa
          ;; ---------------------------------------------------------------

          ("t"
           "Tarefa"
           entry
           (file "~/Org/inbox.org")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
           :empty-lines 1
           :kill-buffer t)


          ;; ---------------------------------------------------------------
          ;; Hábito
          ;; ---------------------------------------------------------------

          ("h"
           "Hábito"
           entry
           (file "~/Org/habits.org")
           "* TODO %?\nSCHEDULED: %t\n:PROPERTIES:\n:STYLE: habit\n:END:\n"
           :empty-lines 1
           :kill-buffer t)


          ;; ---------------------------------------------------------------
          ;; Nota
          ;; ---------------------------------------------------------------

          ("n"
           "Nota"
           entry
           (file "~/Org/inbox.org")
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
           :empty-lines 1
           :kill-buffer t))))


;; ============================================================================
;; ORG-MODERN
;; ============================================================================

(after! org

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
          "────────────────────────")))


;; ============================================================================
;; ORG — TIPOGRAFIA
;; ============================================================================

(defun my/org-visual-setup ()
  "Configuração visual de leitura para Org."
  (variable-pitch-mode 1))

(add-hook 'org-mode-hook #'my/org-visual-setup)


;; ============================================================================
;; ORG — FACES
;; ============================================================================

(after! org

  (custom-set-faces!

    ;; ------------------------------------------------------------------------
    ;; Documento
    ;; ------------------------------------------------------------------------

    '(org-document-title
      :foreground "#d4be98"
      :weight bold
      :height 1.35)


    ;; ------------------------------------------------------------------------
    ;; Headings
    ;; ------------------------------------------------------------------------

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


    ;; ------------------------------------------------------------------------
    ;; TODO
    ;; ------------------------------------------------------------------------

    '(org-todo
      :foreground "#e78a4e"
      :weight bold)

    '(org-done
      :foreground "#a9b665"
      :weight bold)


    ;; ------------------------------------------------------------------------
    ;; Links
    ;; ------------------------------------------------------------------------

    '(org-link
      :foreground "#d8a657"
      :underline nil)


    ;; ------------------------------------------------------------------------
    ;; Metadados
    ;; ------------------------------------------------------------------------

    '(org-tag
      :foreground "#928374"
      :weight normal)

    '(org-meta-line
      :foreground "#928374")

    '(org-drawer
      :foreground "#7c6f64")


    ;; ------------------------------------------------------------------------
    ;; Datas
    ;; ------------------------------------------------------------------------

    '(org-date
      :foreground "#7daea3"
      :underline nil)

    '(org-scheduled
      :foreground "#a9b665")

    '(org-deadline
      :foreground "#e78a4e")


    ;; ------------------------------------------------------------------------
    ;; Código
    ;; ------------------------------------------------------------------------

    '(org-code
      :foreground "#89b482")

    '(org-verbatim
      :foreground "#d3869b")


    ;; ------------------------------------------------------------------------
    ;; Blocos
    ;; ------------------------------------------------------------------------

    '(org-block
      :background "#292827"
      :extend t)

    '(org-block-begin-line
      :foreground "#665c54"
      :background "#292827")

    '(org-block-end-line
      :foreground "#665c54"
      :background "#292827")


    ;; ------------------------------------------------------------------------
    ;; Checkbox
    ;; ------------------------------------------------------------------------

    '(org-checkbox
      :foreground "#d8a657"
      :weight bold)


    ;; ------------------------------------------------------------------------
    ;; Propriedades
    ;; ------------------------------------------------------------------------

    '(org-special-keyword
      :foreground "#7daea3")

    '(org-property-value
      :foreground "#b8bb26")))


;; ============================================================================
;; GOOGLE CALENDAR — ORG-GCAL
;; ============================================================================

(load "~/.config/org-gcal/credentials.el")


(after! org-gcal

  ;; --------------------------------------------------------------------------
  ;; Credenciais
  ;; --------------------------------------------------------------------------

  (org-gcal-reload-client-id-secret)


  ;; --------------------------------------------------------------------------
  ;; Calendário
  ;; --------------------------------------------------------------------------

  (setq org-gcal-file-alist
        '(("viniciusgazel@gmail.com"
           . "~/Org/calendar-pessoal.org")))


  ;; --------------------------------------------------------------------------
  ;; Janela de sincronização
  ;; --------------------------------------------------------------------------

  (setq org-gcal-up-days 30
        org-gcal-down-days 90)


  ;; --------------------------------------------------------------------------
  ;; Notificações
  ;; --------------------------------------------------------------------------

  (setq org-gcal-notify-p nil)


  ;; --------------------------------------------------------------------------
  ;; Eventos cancelados
  ;; --------------------------------------------------------------------------

  (setq org-gcal-remove-api-cancelled-events t))


;; ============================================================================
;; GOOGLE CALENDAR — FUNÇÕES
;; ============================================================================

(defun my/org-gcal-fetch-and-refresh ()
  "Buscar eventos do Google Calendar e atualizar a agenda."
  (interactive)

  (org-gcal-fetch)

  (when (get-buffer "*Org Agenda*")
    (with-current-buffer "*Org Agenda*"
      (org-agenda-redo))))


(defun my/org-gcal-sync-and-refresh ()
  "Sincronizar Google Calendar e atualizar a agenda."
  (interactive)

  (org-gcal-sync)

  (when (get-buffer "*Org Agenda*")
    (with-current-buffer "*Org Agenda*"
      (org-agenda-redo))))


;; ============================================================================
;; AGENDA PERSONALIZADA
;; ============================================================================

(after! org-agenda

  (setq org-agenda-custom-commands

        '(

          ;; ------------------------------------------------------------------
          ;; Agenda principal
          ;; ------------------------------------------------------------------

          ("a"
           "Agenda principal"
           agenda
           "")


          ;; ------------------------------------------------------------------
          ;; Hoje
          ;; ------------------------------------------------------------------

          ("d"
           "Hoje"
           agenda
           ""
           ((org-agenda-span 1)
            (org-agenda-start-day "today")))


          ;; ------------------------------------------------------------------
          ;; Semana
          ;; ------------------------------------------------------------------

          ("w"
           "Semana"
           agenda
           ""
           ((org-agenda-span 7)))


          ;; ------------------------------------------------------------------
          ;; Tarefas
          ;; ------------------------------------------------------------------

          ("t"
           "Tarefas"
           alltodo
           ""))))


;; ============================================================================
;; CALFW — CALENDÁRIO VISUAL
;; ============================================================================

(use-package! calfw
  :after org
  :commands (calfw-open-calendar-buffer)

  :config

  ;; --------------------------------------------------------------------------
  ;; Semana começa segunda-feira
  ;; --------------------------------------------------------------------------

  (setq calendar-week-start-day 1)


  ;; --------------------------------------------------------------------------
  ;; Português
  ;; --------------------------------------------------------------------------

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


  ;; --------------------------------------------------------------------------
  ;; Feriados brasileiros
  ;; --------------------------------------------------------------------------

  (setq calendar-holidays

        '(

          ;; -------------------------------------------------------------------
          ;; Feriados fixos
          ;; -------------------------------------------------------------------

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


          ;; -------------------------------------------------------------------
          ;; Datas móveis
          ;; -------------------------------------------------------------------

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


  ;; --------------------------------------------------------------------------
  ;; Grade Unicode
  ;; --------------------------------------------------------------------------

  (setq calfw-fchar-junction ?╋
        calfw-fchar-vertical-line ?┃
        calfw-fchar-horizontal-line ?━
        calfw-fchar-left-junction ?┣
        calfw-fchar-right-junction ?┫
        calfw-fchar-top-junction ?┯
        calfw-fchar-top-left-corner ?┏
        calfw-fchar-top-right-corner ?┓)


  ;; --------------------------------------------------------------------------
  ;; Quebra de linha
  ;; --------------------------------------------------------------------------

  (setq calfw-render-line-breaker
        #'calfw-render-line-breaker-wordwrap)


  ;; --------------------------------------------------------------------------
  ;; Teclas padrão
  ;; --------------------------------------------------------------------------

  (setq calfw-org-overwrite-default-keybinding t))


;; ============================================================================
;; CALFW — ORG
;; ============================================================================

(use-package! calfw-org
  :after (calfw org)

  :commands
  (calfw-org-open-calendar)

  :config

  (setq calfw-org-agenda-schedule-args
        '(:timestamp
          :scheduled
          :deadline)))


;; ============================================================================
;; CALFW — GRUVBOX MATERIAL
;; ============================================================================

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


;; ============================================================================
;; CALFW — COMANDO PRINCIPAL
;; ============================================================================

(defun my/calfw-calendar ()
  "Abrir calendário visual baseado na Org Agenda."
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


;; ============================================================================
;; EVIL — CALFW
;; ============================================================================

(after! calfw

  (evil-define-key
      'normal
      calfw-calendar-mode-map

    (kbd "M") #'calfw-change-view-month
    (kbd "W") #'calfw-change-view-week
    (kbd "T") #'calfw-change-view-two-weeks
    (kbd "D") #'calfw-change-view-day

    (kbd "r") #'calfw-refresh-calendar-buffer
    (kbd "q") #'bury-buffer))


;; ============================================================================
;; ATALHOS — DOOM LEADER
;; ============================================================================

(map!

 :leader

 ;; ===========================================================================
 ;; AGENDA
 ;; ===========================================================================

 (:prefix ("a" . "Agenda")

  :desc "Agenda principal"
  "a" #'org-agenda

  :desc "Agenda de hoje"
  "d" (lambda ()
        (interactive)
        (org-agenda nil "d"))

  :desc "Agenda semanal"
  "w" (lambda ()
        (interactive)
        (org-agenda nil "w"))

  :desc "Tarefas"
  "t" (lambda ()
        (interactive)
        (org-agenda nil "t"))

  :desc "Atualizar agenda"
  "r" #'org-agenda-redo)


 ;; ===========================================================================
 ;; CAPTURA
 ;; ===========================================================================

 :desc "Capturar"
 "x" #'org-capture


 ;; ===========================================================================
 ;; GOOGLE CALENDAR
 ;; ===========================================================================

 (:prefix ("g" . "Google Calendar")

  :desc "Buscar eventos"
  "f" #'my/org-gcal-fetch-and-refresh

  :desc "Sincronizar"
  "s" #'my/org-gcal-sync-and-refresh

  :desc "Enviar evento"
  "p" #'org-gcal-post-at-point)


 ;; ===========================================================================
 ;; ORG
 ;; ===========================================================================

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
        (find-file "~/Org/calendar-pessoal.org"))

  :desc "Calendário visual"
  "a" #'my/calfw-calendar))


;; ============================================================================
;; COMPORTAMENTO GERAL
;; ============================================================================

(setq confirm-kill-emacs nil)


;; ============================================================================
;; FIM
;; ============================================================================
