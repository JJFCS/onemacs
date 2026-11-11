;;; early-init.el --- Startup and your patched macOS build -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil
      gc-cons-threshold (* 128 1024 1024)
      gc-cons-percentage 0.6
      frame-inhibit-implied-resize t)

(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

;; Preserve the Homebrew/libgccjit workaround used by your custom Emacs.app.
(when (eq system-type 'darwin)
  (let ((brew-bin "/opt/homebrew/bin"))
    (when (file-directory-p brew-bin)
      (add-to-list 'exec-path brew-bin)
      (unless (member brew-bin (split-string (or (getenv "PATH") "") ":" t))
        (setenv "PATH" (concat brew-bin ":" (getenv "PATH"))))))
  (when-let* ((archive (car (file-expand-wildcards
                           "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/*/*/libemutls_w.a"))))
    (let ((directory (directory-file-name (file-name-directory archive)))
          (existing (getenv "LIBRARY_PATH")))
      (unless (member directory (split-string (or existing "") ":" t))
        (setenv "LIBRARY_PATH"
                (concat directory (if existing (concat ":" existing) "")))))))

(when (and (fboundp 'startup-redirect-eln-cache)
           (boundp 'native-comp-eln-load-path))
  (startup-redirect-eln-cache
   (expand-file-name "onemacs-cache/eln-cache/" user-emacs-directory)))

;;; early-init.el ends here
