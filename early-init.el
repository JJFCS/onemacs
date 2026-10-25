;; -*- lexical-binding: t; -*-

;; Launching emacs when we compile from source - nextstep
(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
(let ((files (file-expand-wildcards "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/*/*/libemutls_w.a")))
    (when files
        (let* ((directory (file-name-directory (car files)))
               (existing (getenv "LIBRARY_PATH")))
            (unless (member directory (split-string (or existing "") ":" t))
                    (setenv "LIBRARY_PATH"
                        (concat directory
                                (if (and existing (not (equal existing "")))
                                    (concat ":" existing)
                                  "")))))))

(setq menu-bar-mode nil)
(setq tool-bar-mode nil)

;; this changes where emacs stores native compilation (.eln) files
(when (boundp 'native-comp-eln-load-path)
(setcar native-comp-eln-load-path
(expand-file-name "onemacs-cache/eln-cache/" user-emacs-directory)
                )
        )
