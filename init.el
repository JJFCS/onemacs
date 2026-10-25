;; -*- lexical-binding: t; -*-

;; ORG & BABEL ARE INCLUDED WITH EMACS SO NO DOWNLOAD IS NEEDED
(require 'org)
(require 'ob-tangle)

(let* ((modules-dir (expand-file-name "modules/" user-emacs-directory))
       (elisp-dir   (expand-file-name "elisp/" modules-dir)))
       (make-directory elisp-dir t)  ;; creates the directories if it does not exist

       ;; Load modules in this exact order
       (dolist (module '("main" "bespoke" "emacs" "programming" "keybindings" "appearances"))
       (let ((org-file (expand-file-name (concat module ".org") modules-dir))
              (el-file (expand-file-name (concat module ".el") elisp-dir)))

            ;; Tangle only when necessary
            (when (or (not (file-exists-p el-file))
                      (file-newer-than-file-p org-file el-file))
                  (org-babel-tangle-file org-file el-file "emacs-lisp"))

            ;; Load the generated Lisp file
            (load el-file nil 'nomessage))))
