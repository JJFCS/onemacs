;;; init.el --- Onemacs module loader -*- lexical-binding: t; -*-

(when (version< emacs-version "30.1")
  (error "Onemacs needs Emacs 30.1 or newer; developed for your Emacs 31 build"))

(defconst onncera-config-directory
  (file-name-directory (or load-file-name buffer-file-name))
  "Directory containing this configuration.")

(defconst onncera-modules
  '("main" "bespoke" "emacs" "completion" "editing" "projects"
    "programming" "keybindings" "appearances")
  "Configuration modules, in dependency order.")

(defun onncera-build-modules (&optional force)
  "Tangle changed Org modules, or all modules with FORCE.
Org is a configuration authoring tool here; it is only loaded for a rebuild."
  (interactive "P")
  (let ((source-dir (expand-file-name "modules/" onncera-config-directory))
        (target-dir (expand-file-name "modules/elisp/" onncera-config-directory)))
    (make-directory target-dir t)
    (dolist (module onncera-modules)
      (let ((source (expand-file-name (concat module ".org") source-dir))
            (target (expand-file-name (concat module ".el") target-dir)))
        (unless (file-readable-p source)
          (error "Missing Onemacs module: %s" source))
        (when (or force (not (file-exists-p target))
                  (file-newer-than-file-p source target))
          (require 'ob-tangle)
          (org-babel-tangle-file source target "emacs-lisp"))))))

(defun onncera-load-modules ()
  "Build and load modules in `onncera-modules' order."
  (onncera-build-modules)
  (dolist (module onncera-modules)
    (load (expand-file-name (concat "modules/elisp/" module ".el")
                           onncera-config-directory)
          nil 'nomessage t)))

(unwind-protect
    (onncera-load-modules)
  (setq gc-cons-threshold (* 32 1024 1024)
        gc-cons-percentage 0.1))

;;; init.el ends here
