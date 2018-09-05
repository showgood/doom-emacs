;; -*- no-byte-compile: t; -*-
;;; lang/cc/packages.el

(package! cmake-mode)
(package! demangle-mode)
(package! disaster)
(package! modern-cpp-font-lock)
(package! clang-format)

(when (featurep! :feature syntax-checker)
  (package! flycheck-irony))
