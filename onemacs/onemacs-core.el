
	;; -*- lexical-binding: t; -*-

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(use-package leuven-theme :ensure t)
		(use-package modus-themes :ensure t)

		(add-hook 'window-setup-hook	(lambda ()
		(run-with-idle-timer 0 nil	(lambda ()
							(load-theme 'leuven-dark t)
							(set-face-background hl-line-face "midnight blue")
							(set-face-italic 'font-lock-comment-face nil)
							(set-face-bold-p 'bold                   nil)

						)
		)
						)
		)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(defun onncera-sane ()
		(electric-pair-mode 1) (global-display-line-numbers-mode 1) (global-hl-line-mode 1) (delete-selection-mode 1)
		(blink-cursor-mode -1) (fringe-mode -1)  (menu-bar-mode -1) (scroll-bar-mode    -1) (tool-bar-mode        -1)
	)


	(when (boundp 'native-comp-eln-load-path)
	(setcar native-comp-eln-load-path
	(expand-file-name "onemacs-cache/eln-cache/" user-emacs-directory)
			)
		)


	(use-package emacs
		:init
		(add-hook 'emacs-startup-hook  'split-window-horizontally)
		(add-hook 'emacs-startup-hook  'toggle-frame-fullscreen t)
		(add-hook 'emacs-startup-hook  'onncera-sane t)
		(add-to-list    'exec-path "/opt/homebrew/bin")
	(setq recentf-save-file "~/.emacs.d/onemacs-cache/recentf")
	(setq savehist-file     "~/.emacs.d/onemacs-cache/history")
	(setq auto-save-default nil) (setq auto-save-list-file-prefix nil) (setq make-backup-files nil)
	(setq-default truncate-lines t)
	(setq inhibit-splash-screen  t)
	(setq display-line-numbers-type 'relative) (setq insert-directory-program "gls")
		)


	;; ONLY WHEN USING BERKELEY MONO FONT
	(defun swap-display-table-chars (from-char to-char display-table)
		(aset display-table from-char (vector to-char))
		(aset display-table to-char (vector from-char))
	)

	(defun setup-swap-display-table ()
		(let ((current-font (face-attribute 'default :family)) (dt  (or buffer-display-table  (make-display-table))))
		(when (string= current-font "Berkeley Mono Trial")
			(swap-display-table-chars ?# ?*  dt)
			(swap-display-table-chars ?/ ?\\ dt)
			(swap-display-table-chars ?\\ ?/ dt)
			(setq buffer-display-table dt)))
	)

	(add-hook 'text-mode-hook 'setup-swap-display-table)
	(add-hook 'prog-mode-hook 'setup-swap-display-table)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	(provide 'onemacs-core)

