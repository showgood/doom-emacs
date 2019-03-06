;;; ui/window-select/config.el -*- lexical-binding: t; -*-

(def-package! switch-window
  :when (featurep! +switch-window)
  :defer t
  :init
  (global-set-key [remap other-window] #'switch-window)
  :config
  (setq switch-window-shortcut-style 'qwerty
        switch-window-qwerty-shortcuts '("a" "s" "d" "f" "g" "h" "j" "k" "l")))


(def-package! ace-window
  :unless (featurep! +switch-window)
  :defer t
  :init
  (global-set-key [remap other-window] #'ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        ;; I want to switch window across frame
        aw-scope 'global
        aw-background t))
