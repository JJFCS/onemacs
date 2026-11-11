;;; onemacs-tests.el --- Startup and completion integration -*- lexical-binding: t; -*-
(require 'ert)
(require 'cl-lib)
(require 'package)

(defconst onncera-test-repo
  (file-name-directory (directory-file-name (file-name-directory load-file-name))))
(defconst onncera-test-directory (make-temp-file "onemacs-tests-" t))
(defconst onncera-test-packages
  (or (getenv "ONEMACS_TEST_PACKAGE_DIR") package-user-dir))
(copy-directory (expand-file-name "modules" onncera-test-repo)
                (expand-file-name "modules" onncera-test-directory))
(let ((generated (expand-file-name "modules/elisp" onncera-test-directory)))
  ;; A working checkout can contain stale ignored output. Exercise the same
  ;; first-run build as a clean clone, without inheriting that output.
  (when (file-directory-p generated) (delete-directory generated t)))
(dolist (name '("init.el" "early-init.el"))
  (copy-file (expand-file-name name onncera-test-repo)
             (expand-file-name name onncera-test-directory)))
(setq user-emacs-directory (file-name-as-directory onncera-test-directory)
      package-user-dir onncera-test-packages
      package-enable-at-startup nil
      debug-on-error t)
(load (expand-file-name "early-init.el" onncera-test-directory) nil t)
(load (expand-file-name "init.el" onncera-test-directory) nil t)

(add-hook 'kill-emacs-hook
          (lambda () (ignore-errors (delete-directory onncera-test-directory t)))
          99)

(defmacro onncera-test-with-code (&rest body)
  "Run BODY in a source buffer without launching diagnostic processes."
  (declare (indent 0) (debug t))
  `(with-temp-buffer
     (let ((prog-mode-hook nil) (after-change-major-mode-hook nil)) (prog-mode))
     (setq default-directory (file-name-as-directory onncera-test-directory))
     (when (locate-library "cape") (onncera-setup-completion))
     ,@body))

(defun onncera-test-candidates (capf)
  "Return candidates for CAPF at point, without showing a popup."
  (let* ((result (funcall capf))
         (text (and result (buffer-substring-no-properties (nth 0 result) (nth 1 result)))))
    (when result (all-completions text (nth 2 result) (plist-get (nthcdr 3 result) :predicate)))))

(ert-deftest onncera-startup-generates-readable-modules ()
  (dolist (name onncera-modules)
    (let ((file (expand-file-name (concat "modules/elisp/" name ".el") onncera-test-directory)))
      (should (file-readable-p file))
      (with-temp-buffer
        (insert-file-contents file)
        (emacs-lisp-mode)
        (check-parens)))))

(ert-deftest onncera-main-never-installs-on-load ()
  (cl-letf (((symbol-function 'package-refresh-contents) (lambda (&rest _) (ert-fail "Unexpected refresh")))
            ((symbol-function 'package-install) (lambda (&rest _) (ert-fail "Unexpected installation")))
            ((symbol-function 'package-vc-install) (lambda (&rest _) (ert-fail "Unexpected clone"))))
    (load (expand-file-name "modules/elisp/main.el" onncera-test-directory) nil t)))

(ert-deftest onncera-module-rebuild-is-incremental ()
  (let* ((onncera-config-directory (make-temp-file "onemacs-rebuild-" t))
         (onncera-modules '("unit"))
         (source (expand-file-name "modules/unit.org" onncera-config-directory))
         (target (expand-file-name "modules/elisp/unit.el" onncera-config-directory)))
    (unwind-protect
        (progn
          (make-directory (file-name-directory source) t)
          (with-temp-file source (insert "#+begin_src emacs-lisp\n(setq onncera-test-value 1)\n#+end_src\n"))
          (onncera-build-modules)
          (should (file-exists-p target))
          (let ((mtime (file-attribute-modification-time (file-attributes target))))
            (onncera-build-modules)
            (should (equal mtime (file-attribute-modification-time (file-attributes target)))))
          (with-temp-file source (insert "#+begin_src emacs-lisp\n(setq onncera-test-value 2)\n#+end_src\n"))
          (set-file-times target (time-subtract (current-time) 5))
          (onncera-build-modules)
          (with-temp-buffer (insert-file-contents target) (should (search-forward "value 2" nil t))))
      (delete-directory onncera-config-directory t))))

(ert-deftest onncera-gc-restored-after-startup ()
  (should (= gc-cons-threshold (* 32 1024 1024)))
  (should (= gc-cons-percentage 0.1)))

(ert-deftest onncera-preserves-user-key-flow ()
  (should (eq (key-binding (kbd "M-o")) 'other-window))
  (should (eq (key-binding (kbd "C-8")) 'xref-find-definitions))
  (should (eq (key-binding (kbd "<f9>")) 'onncera-jump-1))
  (should (commandp (key-binding (kbd "<f9>"))))
  (should (eq (key-binding (kbd "C-c a l")) 'onncera-set-compact-line-height))
  (should (eq (key-binding (kbd "C-c e a")) 'align-regexp))
  (should (bound-and-true-p which-key-mode)))

(ert-deftest onncera-smart-line-start-toggles ()
  (with-temp-buffer
    (insert "    abc")
    (onncera-smart-beginning-of-line)
    (should (= (point) 5))
    (onncera-smart-beginning-of-line)
    (should (= (point) 1))))

(ert-deftest onncera-compact-height-validates-and-sets-patch-variable ()
  (defvar onncera-line-height-compact-pixels)
  (let ((onncera-line-height-compact-pixels 4))
    (should-error (onncera-set-compact-line-height -1) :type 'user-error)
    (should-error (onncera-set-compact-line-height 1.5) :type 'user-error)
    (onncera-set-compact-line-height 3)
    (should (= onncera-line-height-compact-pixels 3))))

(ert-deftest onncera-buffer-words-are-project-scoped-and-bounded ()
  (onncera-test-with-code
    (let ((first (generate-new-buffer "onemacs-first"))
          (second (generate-new-buffer "onemacs-second"))
          (foreign (generate-new-buffer "onemacs-foreign"))
          (onncera-completion-buffer-limit 1)
          (origin (current-buffer)))
      (unwind-protect
          (progn
            (dolist (buffer (list first second foreign))
              (with-current-buffer buffer
                (let ((prog-mode-hook nil) (after-change-major-mode-hook nil)) (prog-mode))
                (setq default-directory (file-name-as-directory onncera-test-directory))))
            (cl-letf (((symbol-function 'project-current) (lambda (&rest _) '(onemacs-project)))
                      ((symbol-function 'project-buffers) (lambda (_) (list origin first second))))
              (let ((selected (onncera-completion-buffers)))
                (should (eq (car selected) origin))
                (should (= (length selected) 2))
                (should-not (memq foreign selected)))))
        (mapc #'kill-buffer (list first second foreign))))))

(ert-deftest onncera-remote-and-large-buffers-avoid-automatic-extras ()
  (onncera-test-with-code
    (let ((onncera-large-buffer-size 3))
      (insert "long")
      (should-not (onncera-light-buffer-p)))
    (cl-letf (((symbol-function 'file-remote-p) (lambda (&rest _) t)))
      (should-not (onncera-light-buffer-p)))))

(ert-deftest onncera-project-jump-assigns-and-revisits-position ()
  (require 'bookmark)
  (let ((bookmark-alist nil) (bookmark-alist-modification-count 0)
        (bookmark-default-file (expand-file-name "test-bookmarks" onncera-test-directory))
        (bookmark-save-flag nil)
        (file (expand-file-name "jump.txt" onncera-test-directory)))
    (with-temp-file file (insert "first\nsecond\n"))
    (let ((buffer (find-file-noselect file)))
      (unwind-protect
          (with-current-buffer buffer
            (cl-letf (((symbol-function 'onncera-jump-scope) (lambda () "test-scope:")))
              (goto-char 7)
              (onncera-jump-slot 1)
              (goto-char 1)
              (onncera-jump-slot 1)
              (should (= (point) 7))))
        (kill-buffer buffer)))))

(ert-deftest onncera-clearing-jumps-preserves-other-projects ()
  (require 'bookmark)
  (let ((bookmark-alist '(("scope:1" (filename . "/tmp/a"))
                          ("other:1" (filename . "/tmp/b"))))
        (bookmark-alist-modification-count 0)
        (bookmark-save-flag nil))
    (cl-letf (((symbol-function 'onncera-jump-scope) (lambda () "scope:")))
      (onncera-jump-clear)
      (should-not (assoc "scope:1" bookmark-alist))
      (should (assoc "other:1" bookmark-alist)))))

(ert-deftest onncera-native-capf-falls-back-to-actual-buffer-words ()
  (skip-unless (locate-library "cape"))
  (onncera-test-with-code
    (insert "onsBufferCandidate onsB")
    (setq-local completion-at-point-functions
                (list (lambda () (list (- (point) 4) (point) '("unrelatedNative")))))
    (onncera-setup-completion)
    (let* (found
          (completion-in-region-function
           (lambda (begin end table &optional predicate)
             (setq found (all-completions (buffer-substring begin end) table predicate)) t)))
      (completion-at-point)
      (should (member "onsBufferCandidate" found)))))

(ert-deftest onncera-static-capf-combines-words-and-keywords ()
  (skip-unless (locate-library "cape"))
  (require 'cape)
  (onncera-test-with-code
    (setq major-mode 'python-mode)
    (setq-local cape-dabbrev-buffer-function #'current-buffer)
    (insert "returnFromCache ret")
    (let ((words (onncera-test-candidates #'onncera-static-code-capf)))
      (should (member "return" words))
      (should (member "returnFromCache" words)))))

(ert-deftest onncera-elisp-completion-includes-symbols-and-local-words ()
  (skip-unless (locate-library "cape"))
  (with-temp-buffer
    (let ((prog-mode-hook nil) (emacs-lisp-mode-hook nil)
          (after-change-major-mode-hook nil))
      (emacs-lisp-mode))
    (setq default-directory (file-name-as-directory onncera-test-directory))
    (insert "messageLocalCache\n(mess")
    (onncera-setup-completion)
    (let* (found
           (completion-in-region-function
            (lambda (begin end table &optional predicate)
              (setq found (all-completions (buffer-substring begin end) table predicate)) t)))
      (completion-at-point)
      (should (member "message" found))
      (should (member "messageLocalCache" found)))))

(ert-deftest onncera-tags-capf-reads-real-project-symbols ()
  (skip-unless (locate-library "cape"))
  (let* ((source (expand-file-name "tagged.c" onncera-test-directory))
         (table (expand-file-name "TAGS" onncera-test-directory))
         (entry "int onemacs_indexed_symbol(void) {}\177onemacs_indexed_symbol\0011,0\n"))
    (with-temp-file source (insert "int onemacs_indexed_symbol(void) {}\n"))
    (with-temp-file table
      (insert (format "\f\n%s,%d\n%s" source (string-bytes entry) entry)))
    (onncera-test-with-code
      (setq-local tags-file-name table)
      (insert "onemacs_indexed")
      (should (member "onemacs_indexed_symbol" (onncera-test-candidates #'onncera-tags-capf))))))

(ert-deftest onncera-cape-supports-simpc-and-typescript-keywords ()
  (skip-unless (locate-library "cape"))
  (require 'cape-keyword)
  (onncera-test-with-code
    (setq major-mode 'simpc-mode)
    (insert "ret")
    (should (member "return" (onncera-test-candidates #'cape-keyword)))
    (erase-buffer)
    (setq major-mode 'typescript-ts-mode)
    (insert "inter")
    (should (member "interface" (onncera-test-candidates #'cape-keyword)))))

(ert-deftest onncera-snippet-triggers-appear-without-taking-tab ()
  (skip-unless (and (locate-library "cape") (locate-library "yasnippet-capf")))
  (require 'yasnippet)
  (require 'yasnippet-capf)
  (onncera-test-with-code
    (yas-minor-mode 1)
    (yas-define-snippets 'prog-mode '(("onsSnippet" "value = ${1:0}" "Test snippet")))
    (setq-local cape-dabbrev-buffer-function #'current-buffer)
    (insert "onsS")
    (should (member "onsSnippet" (onncera-test-candidates #'onncera-static-code-capf)))
    (should-not (lookup-key yas-minor-mode-map (kbd "TAB")))))

(ert-deftest onncera-file-completion-still-uses-path-boundaries ()
  (skip-unless (locate-library "cape"))
  (require 'cape)
  (let ((file (expand-file-name "onemacsPathCandidate.txt" onncera-test-directory)))
    (with-temp-file file (insert "test"))
    (onncera-test-with-code
      (insert (expand-file-name "onemacsPath" onncera-test-directory))
      (should (seq-some (lambda (candidate) (string-match-p "onemacsPathCandidate" candidate))
                        (onncera-test-candidates #'cape-file))))))

(ert-deftest onncera-unselected-return-inserts-newline ()
  (skip-unless (locate-library "corfu"))
  (require 'corfu)
  (onncera-test-with-code
    (insert "code")
    (let ((corfu--index -1) (accepted nil))
      (cl-letf (((symbol-function 'corfu-quit) #'ignore)
                ((symbol-function 'corfu-insert) (lambda () (setq accepted t))))
        (onncera-corfu-return)
        (should-not accepted)
        (should (equal (buffer-string) "code\n"))))))

(ert-deftest onncera-selected-return-accepts-candidate ()
  (skip-unless (locate-library "corfu"))
  (require 'corfu)
  (let ((corfu--index 0) accepted)
    (cl-letf (((symbol-function 'corfu-insert) (lambda () (setq accepted t))))
      (onncera-corfu-return)
      (should accepted))))

;;; onemacs-tests.el ends here
