;;; emacs.el --- Minimal Emacs configuration for functional web development -*- lexical-binding: t; -*-

;;; Commentary:
;; A minimal, functional Emacs configuration for Haskell, Elm, and Nix development
;; Configured to work with emacs-overlay and emacsWithPackagesFromUsePackage

;;; Code:

;; Basic settings
(setq-default
 indent-tabs-mode nil              ; Use spaces, not tabs
 tab-width 2                        ; 2-space indentation
 fill-column 80                     ; 80 character line width
 require-final-newline t            ; Ensure files end with newline
 custom-file (concat user-emacs-directory "custom.el")) ; Keep custom settings separate

;; Load custom file if it exists
(when (file-exists-p custom-file)
  (load custom-file))

;; UI improvements
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(column-number-mode 1)
(show-paren-mode 1)

;; Better defaults
(setq
 backup-by-copying t                ; Don't clobber symlinks
 delete-old-versions t              ; Clean up old backups
 kept-new-versions 6
 kept-old-versions 2
 version-control t                  ; Use version numbers for backups
 vc-follow-symlinks t)              ; Follow symlinks without asking

;;; Package Configuration

;; Theme
(use-package catppuccin-theme
  :init
  (setq catppuccin-flavor 'mocha)
  :config
  (load-theme 'catppuccin :co-confirm))

;; Eglot - LSP client (built-in Emacs 29+)
(use-package eglot
  :hook ((nix-mode . eglot-ensure)
         (elm-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (web-mode . eglot-ensure))
  :config
  (setq eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(elm-mode . ("elm-language-server")))
  (add-to-list 'eglot-server-programs '(haskell-mode . ("haskell-language-server-wrapper" "--lsp"))))

;; Company - completion framework
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-numbers t))

;; Flycheck - syntax checking
(use-package flycheck
  :hook (after-init . global-flycheck-mode))

;; Magit - Git interface
(use-package magit
  :bind ("C-x g" . magit-status))

;; Projectile - project management
(use-package projectile
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;;; Language Support

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;; Elm
(use-package elm-mode
  :mode "\\.elm\\'"
  :config
  (setq elm-format-on-save t))

;; Haskell
(use-package haskell-mode
  :mode "\\.hs\\'"
  :config
  (setq haskell-process-type 'cabal-repl
        haskell-interactive-popup-errors nil))

;; Web-mode for HTML
(use-package web-mode
  :mode ("\\.html?\\'" "\\.css\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-css-colorization t))

;; JavaScript
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js2-basic-offset 2
        js2-bounce-indent-p t))

;; JSON
(use-package json-mode
  :mode "\\.json\\'")

;; SQL
(use-package sql-indent
  :after sql
  :config
  (setq sql-indent-offset 2))

;; Org Mode
(use-package org
  :config
  (setq org-startup-indented t
        org-hide-leading-stars t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0))

;; Tree-sitter for better syntax highlighting
(use-package tree-sitter
  :config
  (global-tree-sitter-mode))

(use-package tree-sitter-langs
  :after tree-sitter
  :config
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; Markdown mode (often useful for documentation)
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq markdown-command "pandoc"))

;; YAML mode
(use-package yaml-mode
  :mode "\\.yaml\\'\\|\\.yml\\'")

;;; Keybindings

;; Better window navigation
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;;; Final setup
(provide 'emacs)
;;; emacs.el ends here
