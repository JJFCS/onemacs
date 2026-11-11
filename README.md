# Onemacs

Your modular vanilla Emacs programming environment, aimed at your patched Emacs 31 build. No distribution, modal editing layer, language server or AI completion. Org is only the format used to author the configuration modules.

## Try it beside your current configuration

```bash
git clone --branch codex/programming-completion https://github.com/JJFCS/onemacs.git "$HOME/.config/onemacs-next"
/Applications/Emacs.app/Contents/MacOS/Emacs --init-directory "$HOME/.config/onemacs-next"
```

Use the executable inside **your patched app** if its name or location differs. `--init-directory` selects configuration files; it does not choose an Emacs build. The test directory has its own packages and state.

On first launch, run **M-x onncera-sync-packages**, then restart with the same command. This explicitly downloads the declared packages and their dependencies. Startup itself does not refresh archives, upgrade packages, clone repositories, install grammars, or start servers. Internet access and Git are needed for the initial sync. Missing packages are reported; fix their cause and run sync again.

Your current configuration can still be launched using your usual command. To remove this trial, close that instance and remove only the `onemacs-next` directory you created.

## Module flow

| Module | Responsibility |
| --- | --- |
| `early-init.el` | Startup GC, frame defaults, your Homebrew/libgccjit workaround, native cache |
| `main.org` | Personal options, paths, package activation and explicit installation |
| `bespoke.org` | Your movement, buffer, font, theme and compact-line commands |
| `emacs.org` | History, Dired, windows, built-in editing and terminals |
| `completion.org` | Minibuffer, code completion and snippets |
| `editing.org` | Avy, multiple cursors, region tools, folding, help and undo viewer |
| `projects.org` | Project.el, builds/tests, Magit, gutter, TAGS and jump slots |
| `programming.org` | Language modes, optional tree-sitter, diagnostics, formatter and debugger |
| `keybindings.org` | Your original keys, plus named programming command groups |
| `appearances.org` | Fonts, italics, theme and final personal overrides |

Edit the `.org` modules. Changed modules tangle on the next launch; unchanged launches load the generated Lisp without requiring Org. `M-x onncera-build-modules` rebuilds changed modules; `C-u M-x onncera-build-modules` rebuilds all. Restart to activate those changes consistently. Generated files live in `modules/elisp/` and are ignored by Git.

This is a personal configuration rather than a hot-reloading framework. Restart after installing packages or changing hooks.

## Completion without LSP

[Read the completion guide and framework comparison](docs/completion.md).

Automatic suggestions combine identifiers already present in open buffers, language keywords, snippets, abbreviations and a configured TAGS index. Native mode/REPL completion is tried before those fallback candidates. File paths use a separate context-sensitive source. Source-specific commands also give direct access to lines, all buffers, dictionary words, shell history, Unicode and Emacs Lisp symbols.

Emacs Lisp symbols are combined with buffer words and snippets. Other native sources retain their boundaries and metadata: when such a provider has matches it owns that session; when it has none, static sources can take over. File paths stay separate. Use explicit source shortcuts whenever you want a different source.

| Action | Key |
| --- | --- |
| Indent, then complete when appropriate | `TAB` |
| Request completion | `M-TAB` / `C-M-i` |
| Next / previous candidate | `C-n` / `C-p`, or `TAB` / `S-TAB` |
| Accept an explicitly selected candidate | `RET` |
| Newline when no candidate is selected | `RET` |
| Accept the first/current candidate explicitly | `M-RET` |
| Dismiss | `C-g` |
| Show completion documentation | `M-h` in the popup |
| All source commands | `C-c .`, then `C-h` |
| Toggle automatic completion in this buffer | `C-c . t` |

## Programming workflow

| Action | Key |
| --- | --- |
| Search current buffer / multiple buffers | `M-s l` / `M-s L` |
| Search project with ripgrep / Git grep | `M-s r` / `M-s g` |
| Switch buffers and recent files | `C-x b` |
| Symbol outline / outline sidebar | `C-c a i` / `C-c a o` |
| Act on candidate or thing at point | `C-.` |
| Export search results for editing | `C-.`, then `E` |
| Build / rerun build / project test command | `C-c c c` / `C-c c r` / `C-c c t` |
| Format now / toggle formatting on save | `C-c c f` / `C-c c a` |
| Diagnostics list | `C-c c l` |
| Debug / toggle breakpoint | `C-c c d` / `C-c c b` |
| Magit status | `C-c g s` |
| Generate project TAGS index | `C-c p t` |
| Expand / shrink region | `C-c e e` / `C-c e s` |
| Align / query replace regexp | `C-c e a` / `C-c e r` |
| Clean trailing whitespace explicitly | `C-c e c` |
| Fold code / visual undo history | `C-c e f` / `C-c e v` |
| Undo / redo | Your `C-/` / `C-?` |
| Window layout undo / redo | `C-c w u` / `C-c w r` |
| Existing terminal popup / EAT | `M-\`` / `C-c t e` |
| Enhanced help / configuration / package report | `C-c h` prefix |
| Assign or visit four project/branch jump slots | `F9`–`F12`; prefix argument reassigns |
| Delete slot / clear scope / slot menu | `F13` / `F14` / `F15` |

Your numeric movement keys, multiple-cursor function keys, `M-o`, smart `C-a`, tabify/untabify and compact line-height controls are retained. `C-s`, `M-%`, `C-M-%`, keyboard macros and registers remain available. Local major-mode bindings retain normal precedence over global user bindings; `C-x p` always exposes the native project map.

Consult preview is explicit with **M-.** while the minibuffer is active. Choosing candidates does not automatically move the source view. Normal buffers hide starred buffers in `consult-buffer`; use its hidden-buffer narrowing (Space), or `M-x switch-to-buffer` and type `*`.

For bulk edits: search with `M-s r`, export using `C-. E`, enable `M-x wgrep-change-to-wgrep-mode`, edit and finish with `C-c C-c`. Emacs 31's built-in `grep-edit-mode` is an alternative. In Dired, `C-x C-q` enables editable filenames.

## External tools are optional and explicit

| Feature | External requirement |
| --- | --- |
| Fast project text search | `rg`; Git grep works with Git instead |
| Python / R runtime completion | A running Python process / ESS R process, with the environment you want |
| Project identifier index and locations | **Universal Ctags**, then `C-c p t`; rebuild after relevant changes |
| Syntax checks | The matching linter/compiler, such as Ruff, ESLint or a compiler |
| Formatting | The configured formatter, such as Black, Prettier, gofmt or rustfmt |
| Debugging | A Dape-compatible debug adapter, such as debugpy or a suitable LLDB adapter |
| Tree-sitter | Emacs built with tree-sitter and the relevant compiled grammar |

The configuration does not install system tools. For project-local tools, add the project's virtual environment or `node_modules/.bin` to `exec-path` **and** the process `PATH`, or launch Emacs from that environment. A GUI-launched app may not inherit paths set only in your shell startup files. `M-x onncera-doctor` shows what this Emacs process can find.

C/C++ uses your `simpc-mode` preference, which is intentionally simple; it cannot provide compiler-level member completion. Emacs Lisp has native symbol completion and ElDoc. Python completion can use its inferior process (`M-x run-python`); ESS completion can use a running R process (`M-x R`). Runtime completion reflects what is actually loaded into that process.

Tree-sitter improves parsing, highlighting, indentation and navigation. It does not supply language-server intelligence. Installed, compatible grammars enable selected built-in `*-ts-mode` remaps. Missing grammars fall back to classic modes. To install one explicitly, load the corresponding built-in mode library if needed, run `M-x treesit-install-language-grammar`, then restart.

Diagnostics run on save or when the mode is enabled, rather than on every keystroke. Emacs Lisp uses Flymake; other normal local source buffers use Flycheck. No checker is downloaded or started when none is applicable. Formatting is explicit unless you turn on `apheleia-mode`. Debugging starts only when you invoke it.

## Personal changes

`local.el` loads before packages and features. It is ignored by Git. For example:

```elisp
(setq onncera-font "JetBrains Mono"
      onncera-font-height 140
      onncera-completion-buffer-limit 8
      onncera-completion-auto t
      onncera-theme nil
      onncera-use-simpc t)
```

`custom.el` loads last so final overrides win. A mode hook is the right place for buffer-local choices:

```elisp
(add-hook 'python-mode-hook
          (lambda () (setq-local fill-column 100)))
```

Most extras and automatic completion start only for local buffers under one million characters. Remote buffers keep manual completion; long-line protection uses built-in so-long. Automatic word completion scans only a bounded set of already open relevant buffers. The explicit all-buffer command trades more scanning for wider results.

Package code is loaded by commands, file types and hooks where practical. The minibuffer UI is loaded immediately because it is needed immediately. Startup temporarily raises GC to 128 MiB, then restores 32 MiB even when a module fails. These are starting values, not a claim about measured performance on your Mac. Use `M-x emacs-init-time` for startup and `M-x profiler-start`, reproduce a slow action, then `profiler-report` for interactive performance.

Your previous no-backup/no-autosave preference is preserved. Whitespace cleanup is now explicit; turn it back on with a buffer-local save hook if desired. No theme is forced; install/select your preferred theme through standard Emacs package commands. The compact-line patch starts at 4 px only when your patched variable exists.

If your current appearance also depends on an untracked `custom.el`, copy the relevant appearance settings into the trial configuration. That machine-local file is not available from the GitHub repository.

Installed package versions remain stable until you update them. `onncera-sync-packages` installs missing packages; it does **not** upgrade existing ones. Use `M-x list-packages` for intentional updates and `M-x onncera-package-report` to record versions and VC revisions. This is not a lockfile-based setup.

## Validation

Run from the repository with Emacs on PATH:

```bash
emacs --batch -Q -l tests/onemacs-tests.el -f ert-run-tests-batch-and-exit
```

The suite uses temporary configuration/state directories. With the packages installed, it also tests actual Cape candidate generation and fallback. [Validation details and limits](docs/validation.md). [Reference configurations and design choices](docs/references.md).
