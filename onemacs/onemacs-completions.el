
	;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; - TODO: INCLUDE THE FOLLOWING MODULES === HELM-LSP, HELM-PROJECTILE, HELM-SWOOP, HELM-C-YASNIPPET
;;									HELM-DESCBINDS
	(use-package helm-describe-modes :ensure t)
	(use-package helm-ag             :ensure t)
	(use-package helm-rg             :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(savehist-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(use-package helm-flx :ensure t :init (helm-flx-mode) (setq helm-flx-for-helm-locate t))
	(use-package helm     :ensure t :init (setq helm-M-x-show-short-doc t) (helm-mode)

		:bind (

		([remap apropos]                  . helm-apropos)
		([remap bookmark-jump]            . helm-bookmarks)
		([remap execute-extended-command] . helm-M-x)
		([remap find-file]                . helm-find-files)
		([remap find-library]             . helm-locate-library)
		([remap imenu]                    . helm-semantic-or-imenu)
		([remap locate]                   . helm-locate)
		([remap switch-to-buffer]         . helm-mini)
		([remap yank-pop]                 . helm-show-kill-ring)

		)

	)

	(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
	(define-key helm-map (kbd "C-j") #'helm-select-action)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(provide 'onemacs-completions)

