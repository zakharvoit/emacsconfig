(setq-default package-enable-at-startup nil)

(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 3))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Evil mode config
(straight-use-package 'evil)
(straight-use-package 'evil-leader)
(evil-mode 1)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")

;; Powerline config
(straight-use-package 'powerline)
(straight-use-package 'airline-themes)
(require 'powerline)
(require 'airline-themes)
(load-theme 'airline-badwolf t)

;; Themes and colors config
(load-theme 'peacock-contrast t)

;; Some common global configs
(setq-default visible-bell nil)
(global-linum-mode)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(set-frame-font "Source Code Pro-11" t)

;; Emacs dashboard config
(straight-use-package 'dashboard)
(setq-default dashboard-startup-banner nil)
(dashboard-setup-startup-hook)

;; General autocomplete config
(straight-use-package 'company)
(straight-use-package 'company-quickhelp)
(global-company-mode)
(company-quickhelp-mode)
(setq-default company-idle-delay 0.1)

;; Workaround way to add company completion keybindings, see https://github.com/syl20bnr/spacemacs/issues/2974
(add-hook
 'company-completion-started-hook
 (lambda (&rest ignore)
   (when evil-mode
     (when (evil-insert-state-p)
       (define-key evil-insert-state-map (kbd "C-k") nil)))))
(global-set-key (kbd "C-j") 'company-select-next)
(global-set-key (kbd "C-k") 'company-select-previous)

;; Ivy config

(straight-use-package 'ivy)
(ivy-mode 1)

(define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
(define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)

;; Flycheck config

(straight-use-package 'flycheck)
(global-flycheck-mode)
(defun toggle-flycheck-error-buffer ()
  "toggle a flycheck error buffer."
  (interactive)
  (if (string-match-p "Flycheck errors" (format "%s" (window-list)))
      (dolist (w (window-list))
	(when (string-match-p "*Flycheck errors*" (buffer-name (window-buffer w)))
	  (delete-window w)
	  ))
    (flycheck-list-errors)
    )
  )
(global-set-key (kbd "M-4") 'toggle-flycheck-error-buffer)

;; Projectile config
(straight-use-package 'projectile)
(straight-use-package 'counsel-projectile)
(projectile-global-mode)
(evil-leader/set-key "pf" 'counsel-projectile-find-file)
(evil-leader/set-key "pp" 'counsel-projectile-switch-project)
(evil-leader/set-key "ph" 'projectile--find-other-file)

;; Neotree config
(straight-use-package 'neotree)
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)

(defun neotree-open-project-dir ()
  "Open NeoTree using the projectile root."
  (interactive)
  (let ((project-dir (projectile-project-root))
	(file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
	(if (neo-global--window-exists-p)
	    (progn
	      (neotree-dir project-dir)
	      (neotree-find file-name))))))

(global-set-key (kbd "M-1") 'neotree-open-project-dir)

;; Emacs lisp mode
(evil-leader/set-key-for-mode 'emacs-lisp-mode "e" 'eval-region)

;; C++ config
(straight-use-package 'rtags)
(straight-use-package 'flycheck-rtags)
(straight-use-package 'company-rtags)
(straight-use-package 'ivy-rtags)
(require 'rtags)
(require 'flycheck-rtags)
(require 'company-rtags)
(require 'ivy-rtags)

(setq-default rtags-display-result-backend 'ivy)
(setq-default rtags-completions-enabled t)
(add-to-list 'company-backends 'company-rtags)
(defun rdm-restart ()
  (interactive)
  (start-process-shell-command "rdm" "*rdm*" "rdm")
  (set-process-query-on-exit-flag (get-process "rdm") nil)
  (message "Rdm restarted")
)
(evil-leader/set-key "rr" 'rdm-restart)
(rdm-restart)
(add-hook 'c-mode-common-hook (lambda ()
				(flycheck-select-checker 'rtags)
				(setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
				(evil-leader/set-key "ff" 'rtags-find-symbol-at-point)
				(evil-leader/set-key "fr" 'rtags-rename-symbol)
				(evil-leader/set-key "fu" 'rtags-find-references-at-point)
				(evil-leader/set-key "fe" 'rtags-fixit)
				))
