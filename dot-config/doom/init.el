;;; init.el -*- lexical-binding: t; -*-

(doom!
 :input

 :completion
 vertico
 company

 :ui
 doom
 doom-dashboard
 doom-quit
 hl-todo
 modeline
 ophints
 (popup +defaults)
 vc-gutter
 vi-tilde-fringe
 workspaces
 zen

 :editor
 (evil +everywhere)
 file-templates
 fold
 multiple-cursors
 snippets

 :emacs
 dired
 electric
 undo
 vc

 :checkers
 syntax

 :tools
 magit

 :lang
 emacs-lisp
 (org +pretty)

 :config
 (default +bindings +smartparens))
