# Emacs Configuration

A fast, modular Emacs IDE setup with **~0.77s startup** and full IDE features via LSP.

### Features
- **IDE:** eglot + LSP (C/C++, Go, Python, Rust, JS/TS, Web)
- **Lazy Loading:** Deferred packages for speed
- **Bytecode Compiled:** Optimized execution
- **Modular:** Easy to extend
- **Auto-save:** Smart save on focus-out/idle

## Installation

**Requirements:** Emacs 27+, Git, language servers

```bash
git clone https://github.com/cabins/emacs-config ~/.emacs.d
cd ~/.emacs.d && make compile
emacs
```

## Features

**IDE:** Go-to definition, find references, completions, diagnostics via eglot
**Editing:** Multiple cursors, move lines, snippets, bracket highlighting
**UI:** Modern modeline, accessible themes, icon support
**Utilities:** Fuzzy search, git integration, buffer management

## Performance

Startup: **~0.77s** (7945HX Fedora i3, SSD, Emacs 29.3)

Optimizations:
- Deferred garbage collection at startup
- Lazy package loading (packages only load on demand)
- Bytecode compilation for all modules
- Native compilation enabled when Emacs is built with `--with-native-compilation`
- Package quickstart cache (Emacs 27.1+)

## Modules

| Module | Purpose |
|--------|---------|
| `init-fn.el` | Utility functions |
| `init-system.el` | Platform-specific settings |
| `init-elpa.el` | Package manager (MELPA) |
| `init-ui.el` | Themes and fonts |
| `init-builtin.el` | Emacs built-in features |
| `init-package.el` | Third-party packages |
| `init-ide.el` | LSP and language servers |
| `init-kbd.el` | Keybindings |

## Compilation

```bash
make compile        # Compile everything
make compile-local  # Compile config only
make compile-native  # Compile native code only, if supported
make clean          # Remove all .elc/.eln files
```

All `.elc` files are byte-compiled for faster loading.
`.eln` files are generated only when the Emacs binary supports native compilation.

## Language Support

| Language | Server | Key Bindings |
|----------|--------|--------------|
| C/C++ | clangd | M-. (definition), M-? (references) |
| Go | gopls | Same |
| Python | pylsp | C-c p s (sort imports) |
| Rust | rust-analyzer | Auto-formats on save |
| JS/TS | typescript-language-server | Same as C/C++ |
| Web | vls (Vue) | HTML/CSS support |

All LSP features include: go-to-definition, find references, completions, diagnostics, formatting.

## Keybindings

| Binding | Function |
|---------|----------|
| `M-.` | Go to definition |
| `M-?` | Find references |
| `C-c f` | Format buffer |
| `M-<up>`/`<down>` | Move line up/down |
| `C-c d` | Mark next occurrence |
| `C-x C-b` | Buffer list |
| `C-c v` | Git status |
| `C-s` | Search |

Custom bindings can be added to `custom.el`.

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| LSP not working | Server not installed | Install language server, run `M-x eglot-reconnect` |
| Completions not showing | Company mode off | Run `M-x company-mode` |
| Slow startup | Packages not compiled | Run `make compile` |
| No `.eln` files | Emacs lacks native compilation support | Use an Emacs build with `--with-native-compilation` or rely on `.elc` only |
| Stale bytecode | Old .elc files | Run `make clean && make compile` |

See init files for detailed settings.

## Customization

- **Add packages:** Edit `lisp/init-package.el`
- **Change keybindings:** Edit `lisp/init-kbd.el` or add to `custom.el`
- **Override settings:** Use `custom.el` (loaded last, overrides everything)

Example custom.el:
```elisp
(custom-set-variables '(package-name-variable value))
(global-set-key (kbd "C-c x") 'my-command)
```

Recompile after changes: `make compile`

## License & Attribution

Original: **Cabins Kong** (github.com/cabins)
Maintained by: **Sally Face** (SaltedC137)
Requires: Emacs 27+
