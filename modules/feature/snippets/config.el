;;; feature/snippets/config.el -*- lexical-binding: t; -*-

;; Snippets! I've thrown together a few hacks to make `yasnippet' and `evil'
;; behave together.

(def-package! yasnippet
  :commands (yas-minor-mode yas-minor-mode-on yas-expand yas-expand-snippet
             yas-lookup-snippet yas-insert-snippet yas-new-snippet
             yas-visit-snippet-file snippet-mode)
  :preface
  (defvar yas-minor-mode-map (make-sparse-keymap))

  ;; this doesn't work, needs to put in (after! yasnippet)
  ;; :general
  ;; (general-iemap :keymaps 'yas-minor-mode-map "<tab>" yas-maybe-expand)
  ;; (general-vmap :keymaps 'yas-minor-mode-map "<tab>" '+snippets/expand-on-region)

  :init
  ;; Ensure `yas-reload-all' is called as late as possible. Other modules could
  ;; have additional configuration for yasnippet. For example, file-templates.
  (add-transient-hook! 'yas-minor-mode-hook (yas-reload-all))

  (add-hook! (text-mode prog-mode snippet-mode)
    #'yas-minor-mode-on)

  :config
  (setq yas-verbosity (if doom-debug-mode 3 0)
        ;; to avoid weird indentation after expansion
        ;; https://www.reddit.com/r/emacs/comments/6ogn6c/indentation_in_yasnippet/
        yas-indent-line 'fixed
        yas-also-auto-indent-first-line t
        yas-prompt-functions (delq 'yas-dropdown-prompt yas-prompt-functions)
        ;; Allow nested snippets
        yas-triggers-in-field t)

  ;; Allows project-specific snippets
  (defun +snippets|enable-project-modes (mode &rest _)
    "Enable snippets for project modes."
    (if (symbol-value mode)
        (yas-activate-extra-mode mode)
      (yas-deactivate-extra-mode mode)))
  (add-hook 'doom-project-hook #'+snippets|enable-project-modes)

  ;; fix an error caused by smartparens interfering with yasnippet bindings
  (advice-add #'yas-expand :before #'sp-remove-active-pair-overlay)

  ;; Exit snippets on ESC from normal mode
  (add-hook '+evil-esc-hook #'yas-exit-all-snippets))


(def-package! auto-yasnippet
  :commands (aya-create aya-expand aya-open-line aya-persist-snippet)
  :general
  (general-nvmap "C-<tab>" 'aya-create)
  (general-iemap "C-<tab>" 'aya-expand)

  :config
  (setq aya-persist-snippets-dir (concat doom-local-dir "auto-snippets/")))

(after! yasnippet
  (general-iemap :keymaps 'yas-minor-mode-map "<tab>" yas-maybe-expand)
  (general-vmap :keymaps 'yas-minor-mode-map "<tab>" '+snippets/expand-on-region)
)
