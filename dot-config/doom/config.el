;;; config.el -*- lexical-binding: t; -*-

;; ============================================================
;; IDENTIDADE
;; ============================================================

(setq user-full-name "Viana"
      user-mail-address "viniciusgazel@gmail.com")


;; ============================================================
;; APARÊNCIA
;; ============================================================

(setq doom-theme 'doom-gruvbox
      doom-gruvbox-dark-variant "soft")

(setq doom-font
      (font-spec
       :family "JetBrainsMono Nerd Font"
       :size 15))

(setq doom-variable-pitch-font
      (font-spec
       :family "Iosevka Nerd Font"
       :size 15))

(setq display-line-numbers-type 'relative)


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

  ;; Mostrar 7 dias.
  (setq org-agenda-span 7)

  ;; Começar a agenda no dia atual.
  ;;
  ;; Exemplo:
  ;;
  ;; Domingo 23 → 23 até 29
  ;; Segunda 24 → 24 até 30
  ;;
  ;; Isso permite visualizar imediatamente
  ;; os eventos futuros da rotina.
  (setq org-agenda-start-on-weekday nil)

  ;; Mostrar dias mesmo quando não possuem eventos.
  (setq org-agenda-show-all-dates t)

  ;; Usar a janela atual.
  (setq org-agenda-window-setup 'current-window)

  ;; Remover tags da visualização.
  (setq org-agenda-remove-tags t)

  ;; Não herdar tags.
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

  ;; Exemplo:
  ;;
  ;; 05:20  📚 Estudo profundo
  ;; 08:00  🏃 TFM / corrida fácil
  ;; 13:00  💼 Trabalho
  ;;
  ;; Sem "Scheduled:".
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

;; Carregar credenciais.
(load "~/.config/org-gcal/credentials.el")


(after! org-gcal

  ;; ----------------------------------------------------------
  ;; CREDENCIAIS
  ;; ----------------------------------------------------------

  (org-gcal-reload-client-id-secret)


  ;; ----------------------------------------------------------
  ;; ARQUIVO DO GOOGLE CALENDAR
  ;; ----------------------------------------------------------

  ;; Google Calendar
  ;;       ↓
  ;;   org-gcal
  ;;       ↓
  ;; calendar-pessoal.org
  ;;       ↓
  ;;   Org Agenda
  ;;
  (setq org-gcal-file-alist
        '(("viniciusgazel@gmail.com"
           . "~/Org/calendar-pessoal.org")))


  ;; ----------------------------------------------------------
  ;; JANELA DE SINCRONIZAÇÃO
  ;; ----------------------------------------------------------

  ;; 30 dias para trás.
  (setq org-gcal-up-days 30)

  ;; 90 dias para frente.
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

  ;; Buscar eventos.
  (org-gcal-fetch)

  ;; Atualizar agenda caso esteja aberta.
  (when (derived-mode-p 'org-agenda-mode)
    (org-agenda-redo))

  ;; Caso a agenda esteja em outro buffer.
  (when (get-buffer "*Org Agenda*")
    (with-current-buffer "*Org Agenda*"
      (org-agenda-redo))))


;; ============================================================
;; AGENDA PERSONALIZADA
;; ============================================================

(after! org-agenda

  ;; ----------------------------------------------------------
  ;; AGENDA PRINCIPAL
  ;;
  ;; SPC a a
  ;;
  ;; Mostra:
  ;;
  ;; ROTINA
  ;; HÁBITOS
  ;; GOOGLE CALENDAR
  ;; TAREFAS
  ;; ----------------------------------------------------------

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

  ;; Segunda-feira como primeiro dia da semana.
  (setq calendar-week-start-day 1)

  ;; Português.
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

  ;; O Calfw utiliza `calendar-holidays` do Emacs.
  ;; Portanto, configuramos aqui a lista brasileira.

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
          ;; DATAS MÓVEIS IMPORTANTES NO CALENDÁRIO BRASILEIRO
          ;; ===================================================================

          ;; Carnaval
          ;; Domingo: 49 dias antes da Páscoa
          ;; Segunda: 48 dias antes da Páscoa
          ;; Terça: 47 dias antes da Páscoa

          (holiday-easter-etc
           -49
           "Domingo de Carnaval")

          (holiday-easter-etc
           -48
           "Segunda-feira de Carnaval")

          (holiday-easter-etc
           -47
           "Terça-feira de Carnaval")


          ;; Sexta-feira Santa
          ;; 2 dias antes da Páscoa.

          (holiday-easter-etc
           -2
           "Sexta-feira Santa")


          ;; Corpus Christi
          ;; 60 dias depois da Páscoa.

          (holiday-easter-etc
           60
           "Corpus Christi")))

  ;; Mostrar os feriados no calendário.
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

  ;; Mostrar:
  ;; - timestamps
  ;; - SCHEDULED
  ;; - DEADLINE

  (setq calfw-org-agenda-schedule-args
        '(:timestamp
          :scheduled
          :deadline)))


;; =============================================================================
;; CALFW — GRUVBOX MATERIAL DARK SOFT
;; =============================================================================

(after! calfw

  (custom-set-faces

   ;; -------------------------------------------------------------------------
   ;; TÍTULO
   ;; -------------------------------------------------------------------------

   '(calfw-face-title
     ((t (:foreground "#d4be98"
          :weight bold
          :height 1.5
          :inherit variable-pitch))))

   ;; -------------------------------------------------------------------------
   ;; CABEÇALHO
   ;; -------------------------------------------------------------------------

   '(calfw-face-header
     ((t (:foreground "#a9b665"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; DOMINGO
   ;; -------------------------------------------------------------------------

   '(calfw-face-sunday
     ((t (:foreground "#ea6962"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; SÁBADO
   ;; -------------------------------------------------------------------------

   '(calfw-face-saturday
     ((t (:foreground "#7daea3"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; FERIADOS
   ;; -------------------------------------------------------------------------

   '(calfw-face-holiday
     ((t (:foreground "#ea6962"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; GRADE
   ;; -------------------------------------------------------------------------

   '(calfw-face-grid
     ((t (:foreground "#504945"))))

   ;; -------------------------------------------------------------------------
   ;; EVENTOS
   ;; -------------------------------------------------------------------------

   '(calfw-face-default-content
     ((t (:foreground "#d4be98"))))

   ;; -------------------------------------------------------------------------
   ;; EVENTOS DE PERÍODO
   ;; -------------------------------------------------------------------------

   '(calfw-face-periods
     ((t (:foreground "#d8a657"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; CABEÇALHO DOS DIAS
   ;; -------------------------------------------------------------------------

   '(calfw-face-day-title
     ((t (:foreground "#d4be98"))))

   '(calfw-face-default-day
     ((t (:foreground "#d4be98"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; HOJE
   ;; -------------------------------------------------------------------------

   '(calfw-face-today-title
     ((t (:background "#3c3836"
          :foreground "#a9b665"
          :weight bold))))

   '(calfw-face-today
     ((t (:background "#32302f"
          :weight bold))))

   ;; -------------------------------------------------------------------------
   ;; SELEÇÃO
   ;; -------------------------------------------------------------------------

   '(calfw-face-select
     ((t (:background "#45403d"))))

   ;; -------------------------------------------------------------------------
   ;; ANOTAÇÕES
   ;; -------------------------------------------------------------------------

   '(calfw-face-annotation
     ((t (:foreground "#928374"))))

   ;; -------------------------------------------------------------------------
   ;; DIAS FORA DO MÊS
   ;; -------------------------------------------------------------------------

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
    ;; Usa os arquivos definidos em `org-agenda-files`.
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

    ;; -------------------------------------------------------------------------
    ;; VISUALIZAÇÕES
    ;; -------------------------------------------------------------------------

    (kbd "M") #'calfw-change-view-month
    (kbd "W") #'calfw-change-view-week
    (kbd "T") #'calfw-change-view-two-weeks
    (kbd "D") #'calfw-change-view-day

    ;; -------------------------------------------------------------------------
    ;; OPERAÇÕES
    ;; -------------------------------------------------------------------------

    ;; Evil normalmente captura `r` como replace.
    (kbd "r") #'calfw-refresh-calendar-buffer

    ;; Evil normalmente captura `q`.
    (kbd "q") #'bury-buffer))

;; ============================================================
;; CONFIGURAÇÃO FINAL
;; ============================================================

;; Agenda sempre utiliza a janela atual.
(setq org-agenda-window-setup 'current-window)

;; Não pedir confirmação ao sair do Emacs.
(setq confirm-kill-emacs nil)
