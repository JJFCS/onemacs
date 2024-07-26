
	;; -*- lexical-binding: t; -*-

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(require 'package)
	(setq package-archives '(
		("melpa" . "https://melpa.org/packages/") ("elpa" . "https://elpa.gnu.org/packages/")
				)
	)

	(unless
		(bound-and-true-p package--initialized)
			(setq package-enable-at-startup nil)
			(package-initialize)
	)

	(unless (package-installed-p 'use-package) (package-refresh-contents) (package-install 'use-package))
	(eval-when-compile  (require 'use-package)                                                          )
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(add-to-list 'load-path (expand-file-name "onemacs" user-emacs-directory))
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(require 'onemacs-core)
		(require 'onemacs-completions)
		(require 'onemacs-convenience)
		(require 'onemacs-prog)
		(require 'onemacs-supreme)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(put 'upcase-region 'disabled nil)
(custom-set-faces
		'(default ((t (:family "Berkeley Mono Trial" :foundry "nil" :slant normal :weight regular :height 120 :width normal))))
		'(completions-annotations ((t (:slant normal))))
		'(completions-common-part ((t (:slant normal))))
	)

