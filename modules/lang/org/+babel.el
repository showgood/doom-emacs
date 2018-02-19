;;; lang/org/+babel.el -*- lexical-binding: t; -*-

(defvar +org-babel-languages
  '(calc
    C
    css
    ditaa
    dot
    emacs-lisp
    haskell
    ipython
    js
    latex
    ledger
    ;lilypond
    lisp
    matlab
    plantuml
    python
    restclient ; ob-restclient
    ruby
    ;rust       ; ob-rust
    scheme
    shell
    sqlite
    sql-mode)   ; ob-sql-mode
    ;translate) ; ob-translate
  "A list of org-babel languages to load.")

(after! org
  (require 'ob-ipython)

  (setq org-src-fontify-natively t      ; make code pretty
        org-src-preserve-indentation t  ; use native major-mode indentation
        ;; https://2li.ch/home/discovering-emacs-in-2017-part-2
        ;; enable the correct intdentation for source code blocks
        org-edit-src-content-indentation 0
        org-src-tab-acts-natively t
        org-src-window-setup 'current-window
        org-confirm-babel-evaluate nil) ; you don't need my permission

  (org-babel-do-load-languages
   'org-babel-load-languages
   (cl-loop for sym in +org-babel-languages
            collect (cons sym t)))

  ;; I prefer C-c C-c for confirming over the default C-c '
  (map! :map org-src-mode-map "C-c C-c" #'org-edit-src-exit)

  ;;; display/update images in the buffer after I evaluate
  (add-hook 'org-babel-after-execute-hook
          'org-display-inline-images 'append)

  ;; In a recent update, `org-babel-get-header' was removed from org-mode, which
  ;; is something a fair number of babel plugins use. So until those plugins
  ;; update, this polyfill will do:
  (defun org-babel-get-header (params key &optional others)
    (cl-loop with fn = (if others #'not #'identity)
             for p in params
             if (funcall fn (eq (car p) key))
             collect p)))
