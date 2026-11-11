# Choosing the completion stack

The chosen default is **Vertico + Orderless + Marginalia + Consult + Embark** for the minibuffer, and **Corfu + Cape + Yasnippet** for code buffers. These are two separate interfaces sharing Emacs completion facilities.

## What each package does

| Component | Role | Example |
| --- | --- | --- |
| Vertico | Displays minibuffer candidates | Files, buffers, M-x commands |
| Orderless | Matches space-separated components in any order | `python mode` in M-x |
| Marginalia | Adds descriptions and metadata | Function descriptions, file information |
| Consult | Supplies search/navigation commands | Buffer search, ripgrep, Imenu, buffer switching |
| Embark | Acts on the selected candidate or thing at point | Open, copy, inspect, export |
| Embark-Consult | Connects search candidates to export buffers | Export ripgrep results for editing |
| Corfu | Displays completion at the cursor | Identifier dropdown |
| Cape | Supplies and combines completion sources | Words, keywords, paths, lines |
| Yasnippet / yasnippet-capf | Provides templates and exposes them as candidates | Expand a function template with editable fields |

## Vertico ecosystem versus Ivy/Swiper/Counsel and Helm

Swiper is Ivy's buffer-search command; Counsel is a collection of enhanced commands. Comparing Swiper alone with Vertico compares a search command with a UI.

| Consideration | Vertico ecosystem | Ivy + Swiper + Counsel | Helm |
| --- | --- | --- | --- |
| Integration model | Builds on standard completing-read and completion styles | Ivy UI and API, with Counsel commands | Helm sources, actions and commands |
| Initial setup | Several independent pieces to configure | A cohesive set with familiar defaults | A cohesive, extensive interface |
| Buffer search | consult-line and consult-line-multi | Swiper and related commands | Helm search commands and sources |
| Matching | Emacs styles, including Orderless | Ivy matching and configurable regex builders | Helm matching, sources and filtering |
| Actions | Embark, including actions outside a completion session | Ivy actions attached to candidates | Integrated source actions and persistent actions |
| Multiple sources | Supported by commands such as consult-buffer; not every command is multi-source | Counsel supplies richer commands and actions | A particular strength: rich multi-source sessions |
| Bulk operations | Embark export, then Occur/Grep/Dired editing | Command-dependent actions and occur/export | Marked candidates and source-dependent batch actions |
| Screen use | Small minibuffer by default; alternate layouts are optional | Usually minibuffer-oriented | Usually a larger candidate buffer |
| Maintenance tradeoff | More configuration joints, but individual parts can be replaced | Fewer conceptual pieces, more Ivy-specific integration | More Helm-specific concepts and bindings to learn |
| Performance | Lightweight UI design; sources still determine cost | Can be responsive; expensive sources still cost time | Can be responsive; source count and work matter |

For your vanilla, modular setup, the Vertico ecosystem is a good fit: standard commands benefit from the UI, and you can change matching, annotations, actions or search independently. The drawback is maintaining more moving pieces. A smaller package count is a legitimate reason to prefer Ivy; integrated source actions and marked-candidate workflows are legitimate reasons to prefer Helm.

There is no benchmark here proving one framework faster on your machine. File counts, process startup, source generation, matching styles, annotations and preview can matter more than the UI. This setup keeps previews explicit and uses cheaper matching for automatic code completion.

Your earlier Fido setup is still a useful, small built-in option. This configuration uses icomplete-vertical as its first-run fallback; after installation, only Vertico is active. Do not enable Fido, Ivy or Helm mode alongside it.

## Code completion sources and boundaries

| Source | What it knows | Automatic or explicit |
| --- | --- | --- |
| Native major-mode CAPFs | Whatever that mode exposes | Tried first, with metadata retained |
| Python / ESS R process | Names available to the running process | Native mode/REPL integration; start the process yourself |
| Buffer words | Text in the current buffer and bounded relevant open buffers | Automatic fallback |
| Language keywords | Static language vocabulary, including custom mode aliases | Automatic fallback |
| Snippets | Installed templates and your personal snippets | Automatic fallback and explicit menu |
| Abbreviations | Your defined Emacs abbrevs | Automatic fallback |
| TAGS | Indexed symbol names and source locations | Automatic fallback after selecting/building the index |
| File paths | Paths in the completion context | Separate provider before code sources |
| Whole lines | Existing lines from relevant buffers | Explicit |
| All open editing buffers | Broader vocabulary across open local buffers | Explicit |
| Dictionary words | Words in cape-dict-file | Explicit; provide a dictionary file if your OS lacks one |
| Shell history | Relevant command history | Explicit |
| Unicode / TeX / entities | Symbol names and mnemonics | Explicit |
| Emacs Lisp symbols | Symbols already known to Emacs | Native completion and explicit Cape command |

An open project's buffers are the automatic cross-buffer word pool. Outside a project, buffers with the same major mode are used. This means you may occasionally see identifiers from another language in a mixed-language project. The source set is bounded and does not crawl unopened files on each edit.

Static providers are merged into one list. The known-compatible Emacs Lisp symbol source is also merged with them. Other native providers and file paths keep separate sessions because their boundaries and protocols can differ. Making a source nonexclusive allows fallback if it has no matches; it does not merge its successful results with every other source. Source shortcuts let you bypass that ordering.

Corfu starts with no selected candidate and no ghost-text insertion. Type three characters, wait 0.25 seconds, then select with C-n/C-p or TAB. RET inserts a newline until a candidate has been selected. M-RET explicitly accepts the current/first candidate. Popup documentation opens on M-h. Emacs 31's terminal child frames are supported by current Corfu; corfu-terminal is not needed for that version.

Without a semantic engine, an arbitrary `object.` does not guarantee a correct member list, inferred types, safe rename or complete references. Text words, snippets, runtime names and an optional index provide useful completion without pretending to know those things. TAGS also becomes stale until rebuilt.

## Source shortcuts

| Key | Source |
| --- | --- |
| C-c . b | Bounded buffer words |
| C-c . a | All ordinary open local editing buffers |
| C-c . k | Language keywords |
| C-c . f | File paths |
| C-c . l | Whole lines |
| C-c . w | Dictionary words |
| C-c . s | Snippet insertion menu |
| C-c . e | Emacs Lisp symbols |
| C-c . h | Shell/minibuffer history |
| C-c . u | TeX symbol mnemonics |
| C-c . m | Emoji |

Upstream documentation: [Vertico](https://github.com/minad/vertico), [Orderless](https://github.com/oantolin/orderless), [Marginalia](https://github.com/minad/marginalia), [Consult](https://github.com/minad/consult), [Embark](https://github.com/oantolin/embark), [Corfu](https://github.com/minad/corfu), [Cape](https://github.com/minad/cape), [Ivy/Swiper/Counsel](https://github.com/abo-abo/swiper), [Helm](https://github.com/emacs-helm/helm).
