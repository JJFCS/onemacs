
	;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(use-package multiple-cursors :ensure t :defer t
		:init (setq mc/list-file "~/.emacs.d/onemacs-cache/mc-lists.el")
		:bind (
		("M-p" . mc/mark-previous-like-this   )
		("M-n" . mc/mark-next-like-this       )
		("C-<" . mc/skip-to-previous-like-this)
		("C->" . mc/skip-to-next-like-this    )
		)
	)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(use-package vundo   :ensure t :defer t)
	(use-package undo-fu :ensure t
		:bind (
		("C-/" . undo-fu-only-undo)
		("C-?" . undo-fu-only-redo)
		)
	)


	(use-package undo-fu-session
		:ensure t
		:init
		(setq undo-fu-session-directory
			(expand-file-name "onemacs-cache/undo-fu-session/" user-emacs-directory))
		(setq undo-fu-session-incompatible-files '
			("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))

		:config
		(undo-fu-session-global-mode)
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(provide 'onemacs-convenience)

