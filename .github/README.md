# ACS Emacs Configuration learn from shynur

## 🚀 Quick Start

### Requirements

- **Emacs**: 28.0+ (29.0+ recommended)
- **OS**: Windows 11 (primary development environment)
- **Fonts**: Maple Mono NF CN, Segoe UI Symbol, Segoe UI Emoji

### Installation

```bash
# Clone configuration to ~/.emacs.d
git clone <repository-url> ~/.emacs.d

# Start Emacs
emacs
```

Packages declared in `package-selected-packages` will be installed automatically on first launch.

---

## 📁 Project Structure

```
.emacs.d/
├── early-init.el          # Early initialization (before package system)
├── init.el                # Main configuration file
├── lisp/                  # Custom modules
│   ├── acs-early-init.el  # Early initialization logic
│   ├── acs-init.el        # Main initialization logic
│   ├── acs-package.el     # Package management configuration
│   └── acs-ui.el          # UI/Font configuration
├── etc/                   # Other configuration files
│   ├── acs-custom.el      # Custom variables and macros
│   └── yas-snippets/      # Yasnippet code snippets
├── .appdata/              # Runtime data (cache, etc.)
├── server/                # Emacs server configuration
└── site-lisp/             # Third-party libraries
```

---

## ⚡ Performance Optimization

### Startup Optimization (`early-init.el`)

| Option | Description |
|--------|-------------|
| `gc-cons-threshold` | Set to maximum during startup to reduce GC frequency |
| `gc-cons-percentage` | Set to 1.0 to delay GC |
| `frame-inhibit-implied-resize` | Inhibit window resizing during startup |
| `file-name-handler-alist` | Temporarily cleared to accelerate file operations |
| `inhibit-redisplay` | Inhibit startup redraw |

These variables are restored to their original values 1 second after startup completes.

---

## 🎨 UI Features

### Font Configuration

```elisp
Default font: Maple Mono NF CN
Symbol font: Segoe UI Symbol
Emoji font: Segoe UI Emoji
Chinese font: Follows default font
```

### Interface Customization

| Component | Style |
|-----------|-------|
| Cursor | Bright green background (`chartreuse`) |
| Line numbers | Italic light weight, bold for current line |
| Relative line numbers | With underline |
| Window divider | Violet, 12 pixels wide |
| Indentation guides | Deep sea green |
| Fill column indicator | Yellow, black background |
| Minibuffer prompt | Dark slate gray background, font size 100 |

### Window Management

- **Window divider mode**: Right side only (`window-divider-mode`)
- **Window state persistence**: Auto-save/restore window size and position
- **Fullscreen support**: Configurable maximized/fullscreen startup

---

## 📦 Configured Packages

Main packages declared in `acs-package.el`:

| Category | Packages |
|----------|----------|
| **Fuzzy Search** | ivy, swiper, marginalia |
| **Auto Completion** | company, company-quickhelp |
| **Development** | helpful, embark, yasnippet |
| **Version Control** | git-modes |
| **UI Enhancement** | doom-modeline, all-the-icons, neotree |
| **Major Modes** | markdown-mode, yaml-mode, powershell, textile-mode |
| **Others** | rainbow-mode, highlight-parentheses, drag-stuff |

---

## 🔧 Custom Configuration

### Path Configuration (`etc/acs-custom.el`)

```elisp
acs/c-appdata/           ; Data directory
acs/c-clang-format-path  ; clang-format path
acs/c-clang-path         ; clang path
acs/c-python-path        ; Python interpreter path
acs/c-email              ; Email address
acs/c-truename           ; Username
```

### Package Archive Configuration

Uses USTC ELPA mirror:

```elisp
gnu    → https://mirrors.ustc.edu.cn/elpa/gnu/
nongnu → https://mirrors.ustc.edu.cn/elpa/nongnu/
melpa  → https://mirrors.ustc.edu.cn/elpa/melpa/
```

---

## 🖥️ Using Emacsclient

Server mode is supported for quick connection via `emacsclient`:

```bash
# Start server
emacs --daemon

# Connect with GUI frame
emacsclient -c -n

# Connect in terminal mode
emacsclient -t
```

Window state is automatically saved when the last frame is closed.

---

## 📝 Notes

1. **Windows Paths**: Configuration is optimized for Windows paths; Linux/macOS users need to modify related paths
2. **Font Dependency**: Maple Mono NF CN font must be installed, otherwise falls back to system default
3. **Encoding**: Uses `chinese-gb18030` encoding for filename handling by default

---

## 🔗 References

- [GNU Emacs Manual](https://www.gnu.org/software/emacs/manual/)
- [Emacs Wiki](https://www.emacswiki.org/)
- [Doom Emacs](https://github.com/doomemacs/doomemacs) - Reference for some UI designs
- [Centaur Emacs](https://github.com/ema2159/centaur-emacs) - Reference for font configuration
