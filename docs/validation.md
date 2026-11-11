# Validation

Checked on 11 November 2026 using actual Emacs processes and installed packages.

| Check | Result |
| --- | --- |
| Emacs 31.1.90, source revision 205ae0b0583d | 20/20 ERT integration tests passed |
| Emacs 30.1 compatibility run | 20/20 ERT integration tests passed |
| First-run module build | All nine Org modules tangled and loaded |
| Incremental rebuild | Unchanged module retained its generated file; edited module rebuilt |
| Package availability | All 37 declared archive packages and simpc-mode installed |
| Wgrep packaging | MELPA build installed successfully; pinned to avoid upstream test files in the Nongnu 3.0.0 tar |
| Source-mode checks | C, C++, Python, JS, TS, TSX, Java, Go, Rust, Solidity, R, YAML, Markdown and Dockerfile selected their expected modes and enabled local completion |
| Deferred packages | Magit, Helpful, Vundo, Imenu List, shell-pop, EAT, Flycheck, Apheleia, Dape and editing packages loaded successfully on both tested Emacs versions |
| Warm loader audit | No network calls, installs or archive refresh; Org, Magit, Dape and Flycheck stayed unloaded during the loader check |
| Repository hygiene | git diff --check passed; generated code, caches, package installations and local settings excluded |

The ERT suite exercises real Cape candidate generation: native fallback, combined Emacs Lisp symbols and buffer words, language keywords, snippets, path completion and a real TAGS table. It also checks project-scoped scan limits, large/remote buffer gating, jump-slot persistence and isolation, custom key flow, compact-height input validation and RET behavior.

These checks run on Linux. The Emacs 31 test build is a terminal build without native compilation or tree-sitter; startup was also checked with the native-compilation-capable Emacs 30 build. Your patched macOS GUI, actual font rendering, compact line-height appearance, terminal child-frame display and installed tree-sitter grammars still need verification in your own build. The compact-height tests validate the configuration interface, not your C display patch.

The source-mode checks do not start R/Python interpreters, real debugger sessions or external formatters/linters. Those tools depend on your projects and environments. No startup-time or typing-latency result from this container is presented as a benchmark for your Mac.

Run the suite from the repository:

```bash
emacs --batch -Q -l tests/onemacs-tests.el -f ert-run-tests-batch-and-exit
```

It copies the configuration into a temporary directory and uses your installed package directory. To select a separate package directory:

```bash
ONEMACS_TEST_PACKAGE_DIR="$HOME/.config/onemacs-next/elpa" emacs --batch -Q -l tests/onemacs-tests.el -f ert-run-tests-batch-and-exit
```

Tests needing absent packages are reported as skipped. Install the declared packages to run all completion checks. The temporary configuration and state are removed at exit.
