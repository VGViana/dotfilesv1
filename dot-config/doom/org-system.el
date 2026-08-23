;;; org-system.el -*- lexical-binding: t; -*-

;; ============================================================
;; VIANA 2.0 — SISTEMA ORG
;; ============================================================

(after! org

  ;; ----------------------------------------------------------
  ;; DIRETÓRIO PRINCIPAL
  ;; ----------------------------------------------------------

  (setq org-directory "~/Org/")


  ;; ----------------------------------------------------------
  ;; ARQUIVOS DA AGENDA
  ;;
  ;; Tudo que tiver SCHEDULED/DEADLINE nesses arquivos
  ;; aparecerá no org-agenda.
  ;; ----------------------------------------------------------

  (setq org-agenda-files
        '("~/Org/inbox.org"
          "~/Org/tasks.org"
          "~/Org/calendar-pessoal.org"
          "~/Org/rotina.org"
          "~/Org/habitos.org"))


  ;; ----------------------------------------------------------
  ;; HÁBITOS
  ;; ----------------------------------------------------------

  (add-to-list 'org-modules 'org-habit)

  (setq org-habit-following-days 1
        org-habit-preceding-days 14
        org-habit-show-habits-only-for-today t)


  ;; ----------------------------------------------------------
  ;; TODO
  ;; ----------------------------------------------------------

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "NEXT(n)"
           "PROJ(p)"
           "WAIT(w)"
           "|"
           "DONE(d)"
           "CANCELLED(c)")))


  ;; ----------------------------------------------------------
  ;; LOG
  ;; ----------------------------------------------------------

  (setq org-log-done 'time
        org-log-into-drawer t)


  ;; ----------------------------------------------------------
  ;; AGENDA
  ;; ----------------------------------------------------------

  ;; Mostrar eventos agendados mesmo quando não possuem TODO.
  (setq org-agenda-include-diary nil)

  ;; Mostrar todos os horários.
  (setq org-agenda-span 'day
        org-agenda-start-on-weekday nil
        org-agenda-start-day nil)

  ;; Não esconder itens agendados.
  (setq org-agenda-skip-scheduled-if-done nil
        org-agenda-skip-deadline-if-done nil)


  ;; ----------------------------------------------------------
  ;; CAPTURE
  ;; ----------------------------------------------------------

  (setq org-capture-templates
        '(

          ;; Tarefa rápida
          ("t"
           "Tarefa"
           entry
           (file "~/Org/inbox.org")
           "* TODO %?\n  Criado em: %U\n")

          ;; Hábito
          ("h"
           "Hábito"
           entry
           (file "~/Org/habitos.org")
           "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a %H:%M> +1w>\n:PROPERTIES:\n:STYLE: habit\n:END:\n")

          ;; Nota
          ("n"
           "Nota"
           entry
           (file "~/Org/inbox.org")
           "* %?\n  Criado em: %U\n")

          ;; Compromisso
          ("c"
           "Compromisso"
           entry
           (file "~/Org/calendar-pessoal.org")
           "* %?\nSCHEDULED: %^{Data e hora}t\n")

          ))


  ;; ----------------------------------------------------------
  ;; APARÊNCIA DA AGENDA
  ;; ----------------------------------------------------------

  (setq org-agenda-current-time-string "← agora"
        org-agenda-time-grid
        '((daily today require-timed)
          (0900 1100 1300 1500 1700 1900 2100)
          "      "
          "────────────────"))

  ;; ----------------------------------------------------------
  ;; REBUILD DA AGENDA
  ;; ----------------------------------------------------------

  (setq org-agenda-window-setup 'current-window))


;; ============================================================
;; FUNÇÕES ÚTEIS
;; ============================================================

(defun my/org-agenda-hoje ()
  "Abre a agenda de hoje."
  (interactive)
  (org-agenda nil "a"))


(defun my/org-agenda-semana ()
  "Abre a agenda da semana."
  (interactive)
  (org-agenda-list nil nil 7))


;; ============================================================
;; FIM
;; ============================================================
