(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))

; Hide the menu and tool bars to force learning the keyboard shortcuts
(menu-bar-mode -1)
(tool-bar-mode -1)

; Highlight parens
(show-paren-mode 1)

(ido-mode 1)
   
; Setup extra package sources
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(evil-mode 1)
(yas-global-mode 1)

(require 'whitespace)

(defun set-80-column-width ()
  (setq fill-column 80)
  (fci-mode)
  (add-to-list 'default-frame-alist (cons 'width 81)))

; Don't use tabs for indention in JS mode
(setq-default indent-tabs-mode nil)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

; Configure js-mode to highlight whitespace problems
(add-hook 'js2-mode-hook
	  (function (lambda ()
		      ; Trailing whitespace only counts if it's not a completely blank line
		      (setq whitespace-trailing-regexp "[^\n\r[:blank:]]\\([[:blank:]]+?\\)$")
		      (setq whitespace-style '(face lines tabs trailing))
		      (whitespace-mode t))))

; Enable fill column indicator in Javascript mode
(add-hook 'js2-mode-hook 'set-80-column-width)

; Enable hide-show mode in Javascript
(add-hook 'js2-mode-hook 'hs-minor-mode)

; Set default tab width for Javascript files to be 4
(add-hook 'js2-mode-hook 
          (function (lambda () (setq default-tab-width 4))))

; Configure .json file to be edited in js-mode
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

; Configure .bats files to be treated as shell-scripts
(add-to-list 'auto-mode-alist '("\\.bats\\'" . sh-mode))


(defun coffee-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
	  '(lambda() (coffee-custom)))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; Configure markdown mode to highlight trailing whitespace and long lines
(add-hook 'markdown-mode-hook
	  (function (lambda ()
		      ; Trailing whitespace only counts if it's not a completely blank line
		      (setq whitespace-trailing-regexp "[^[:blank:]]\\([[:blank:]]+?\\)$")
		      (setq whitespace-style '(face lines tabs trailing))
		      (whitespace-mode t))))

; Enable fill column indicator in markdown mode
(add-hook 'markdown-mode-hook 'set-80-column-width)

; Enable fill column indicator in python
(add-hook 'python-mode-hook 'set-80-column-width)


; Change the tab behavior in js2-mode to play nicely with yasnippets
(defun js2-tab-properly ()
  (interactive)
  (let ((yas-fallback-behavior 'return-nil))
    (unless (yas-expand)
      (indent-for-tab-command)
      (if (looking-back "^\s*")
          (back-to-indentation)))))

(eval-after-load 'js2-mode
  '(progn
     (define-key js2-mode-map (kbd "TAB") 'js2-tab-properly)))

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

;; Make the Tab key indent correctly in normal mode of evil-mode
(define-key evil-normal-state-map (kbd "<tab>") 'indent-for-tab-command)

;; Make a 'jk' keystroke for existing out of insert mode in evil-mode
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)
