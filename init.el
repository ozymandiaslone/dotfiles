;; --- Package Management ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/elisp")
(require 'flash-drill)

;; --- Evil ---
(setq evil-want-C-u-scroll t)
(require 'evil)
(evil-mode 1)

(with-eval-after-load 'evil
  (define-key evil-insert-state-map (kbd "TAB") #'tab-to-tab-stop))

;; --- Basic UI ---
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(setq x-super-keysym 'meta)

;; --- Indentation ---
(setq-default tab-width 2)
(setq-default standard-indent 2)

;; --- Scrolling ---
(setq scroll-conservatively 101
      scroll-margin 8
      scroll-step 1)

;; --- Theme ---
(load-theme 'modus-vivendi t)

;; --- Clipboard (terminal only) ---
(when (executable-find "xclip")
  (defun xclip-cut-handler (text)
    (let ((process-connection-type nil))
      (let ((proc (start-process "xclip" nil "xclip" "-selection" "clipboard")))
        (process-send-string proc text)
        (process-send-eof proc))))
  (defun xclip-paste-handler ()
    (shell-command-to-string "xclip -selection clipboard -o"))
  (setq interprogram-cut-function 'xclip-cut-handler)
  (setq interprogram-paste-function 'xclip-paste-handler))

;; --- Pairs ---
(electric-pair-mode 1)
(setq electric-pair-preserve-newline nil)

;; --- Syntax Highlighting ---
(use-package treesit-auto
  :config
  (setq treesit-auto-langs '(rust typescript tsx))
  (global-treesit-auto-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; --- Language Support ---
(use-package rust-mode
  :init (setq rust-indent-offset 2)
  :hook (rust-mode . subword-mode))

(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config (setq typescript-ts-mode-indent-offset 2))

(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))

;; --- LSP (eglot) ---
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)

(with-eval-after-load 'eglot
  (evil-define-key 'normal eglot-mode-map (kbd "K") 'eldoc-doc-buffer))

;; --- Custom (managed by Emacs, do not edit) ---
(custom-set-variables)
(custom-set-faces)
