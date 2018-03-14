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

;; Themes and colors config
(load-theme 'peacock-contrast t)

;; Some common global configs
(setq-default visible-bell nil)
(global-linum-mode)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Unsetting weird default keybindings
(global-unset-key (kbd "C-j"))
(global-unset-key (kbd "C-k"))

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

(define-key text-mode-map (kbd "C-j") 'company-select-next)
(define-key text-mode-map (kbd "C-k") 'company-select-previous)

;; Ivy config
(straight-use-package 'ivy)
(ivy-mode 1)

;; (define-key ivy-mode-map (kbd "C-j") 'ivy-next-line)
;; (define-key ivy-mode-map (kbd "C-k") 'ivy-previous-line)

;; Projectile config
(straight-use-package 'projectile)
(straight-use-package 'counsel-projectile)
(projectile-global-mode)
(evil-leader/set-key "pf" 'counsel-projectile-find-file)
(evil-leader/set-key "pp" 'counsel-projectile-switch-project)

;; Emacs lisp mode
(evil-leader/set-key-for-mode 'emacs-lisp-mode "e" 'eval-region)

;; C++ config
(straight-use-package 'rtags)
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
