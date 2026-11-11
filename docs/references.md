# Reference review

Reviewed the following source snapshots on 11 November 2026. These are references for design choices, not bundled distributions or code copied wholesale.

| Configuration | Snapshot | Ideas used | Deliberate differences |
| --- | --- | --- | --- |
| [Your onemacs](https://github.com/JJFCS/onemacs) | 95f160b | Org modules, personal bindings, font choices, compact-line patch, simpc and ESS | Dedicated completion/project/editing modules; explicit package sync |
| [emacs-solo](https://github.com/LionyxML/emacs-solo) | dec27eb | Built-in project tools, bounded startup tuning, centralized state, Dired and compilation polish | Allows third-party packages; no Org productivity or AI configuration |
| [flajann2/emacs-config](https://github.com/flajann2/emacs-config) | 46f3607 | Small responsibility-based modules, compilation colors, folding and language-specific tooling | Regular minibuffer instead of a floating Vertico frame; native Emacs keys |
| [etmacs](https://github.com/EstebanJTrabajos/etmacs) | f0af469 | Organized development commands, explicit test/build entry points, debugger and project context | No LSP, AI workflow, Org suite, modal editing or separate workspace framework |
| [shapr/emacs-config](https://github.com/shapr/emacs-config) | 5faf107 | Vertico/Consult/Embark composition, directory navigation, snippet support | One code-completion frontend; no Company, LSP, Org suite or broad startup GC setting |

The implementation retains and revises your original helper functions and keybindings. Additional functions are written for this configuration. Many package declarations follow the interfaces documented by their respective upstream projects.

The goal is a broad programming toolbox whose expensive work starts when requested. Eagerly loading every feature, turning on overlapping completion UIs, or starting several diagnostics systems per buffer would work against that goal.
