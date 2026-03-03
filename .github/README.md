# ACS Emacs Configuration

> A high-performance, aesthetic Emacs configuration for Windows
>
> **Inspired by**: shynur, Centaur Emacs, Doom Emacs

![Emacs Version](https://img.shields.io/badge/Emacs-28.0+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows%2011-lightgrey.svg)

---

## 📖 Table of Contents

- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Key Features](#-key-features)
- [Configured Packages](#-configured-packages)
- [Customization](#-customization)
- [Server Mode](#-server-mode)
- [Advanced Configuration](#-advanced-configuration)
- [FAQ](#-faq)
- [References](#-references)

---

## 🚀 Quick Start

### Requirements

| Component | Version | Description |
|-----------|---------|-------------|
| **Emacs** | 28.0+ (29.0+ recommended) | Latest native compilation and performance features |
| **OS** | Windows 11 | Primary development environment |
| **Font** | Maple Mono NF CN | Default programming font |
| **Symbol Font** | Segoe UI Symbol | Unicode symbol rendering |
| **Emoji Font** | Segoe UI Emoji | Emoji rendering |

### Installation

```bash
# 1. Clone the configuration to ~/.emacs.d
git clone <repository-url> ~/.emacs.d

# 2. Start Emacs
emacs
```

> **First Launch**: All packages declared in `package-selected-packages` will be installed automatically.
>
> ⏱️ **Expected Time**: ~30-60 seconds (depends on network speed and package count)

---

## 📁 Project Structure

```
.emacs.d/
├── early-init.el              # Early initialization (before package system)
├── init.el                    # Main configuration file
│
├── lisp/                      # Core modules
│   ├── acs-early-init.el      # Early initialization logic
│   ├── acs-init.el            # Main initialization logic
│   ├── acs-package.el         # Package management
│   ├── acs-ui.el              # UI / Fonts / Interface
│   ├── acs-key.el             # Key bindings
│   ├── acs-start.el           # Startup flow control
│   ├── acs-plugin.el          # Third-party plugin integration
│   ├── acs-sh.el              # Shell interaction
│   └── themes/
│       ├── acs-themes.el      # Theme loader
│       ├── acs-light-theme.el # Light theme
│       └── acs-dark-theme.el  # Dark theme
│
├── etc/                       # Configuration files
│   ├── acs-custom.el          # Custom variables and macros
│   ├── clang-format.yaml      # Clang format configuration
│   └── yas-snippets/
│       └── markdown-mode/     # Yasnippet snippets
│
├── .appdata/                  # Runtime data (cache, etc.)
├── server/                    # Emacs server configuration
├── site-lisp/                 # Third-party libraries
│   └── lsp-bridge/            # LSP bridge library
│
├── bin/                       # Binary files
│   ├── conpty_proxy.exe       # ConPTY proxy
│   ├── libvterm-0.dll         # VTerm library
│   └── vterm.el               # VTerm configuration
│
└── auto-save-list/            # Auto-saved window states
```

---

## ⚡ Key Features

### 🎯 Startup Optimization

Achieved through `early-init.el`:

| Optimization | Value | Effect |
|--------------|-------|--------|
| `gc-cons-threshold` | `most-positive-fixnum` | Minimal GC during startup |
| `gc-cons-percentage` | `1.0` | Delay garbage collection |
| `frame-inhibit-implied-resize` | `t` | Prevent window resize on startup |
| `file-name-handler-alist` | `nil` | Accelerate file operations |
| `inhibit-redisplay` | `t` | Suppress startup redraw |

> ⏰ All temporary optimizations are restored 1 second after startup completes.

### 🎨 UI Design

#### Font Configuration

```elisp
Default Font:    Maple Mono NF CN
Symbol Font:     Segoe UI Symbol
Emoji Font:      Segoe UI Emoji
Chinese Font:    Follows default font
```

#### Interface Components

| Component | Style |
|-----------|-------|
| **Cursor** | Bright green background (`chartreuse`), no blink |
| **Line Numbers** | Absolute + relative, current line bold |
| **Line Ticks** | Highlighted every 10 lines |
| **Window Divider** | Violet, 12px wide |
| **Indent Guides** | Deep sea green |
| **Fill Column** | Yellow text, black background |
| **Minibuffer** | Dark slate gray background, font size 100 |
| **Tooltip** | Dark slate gray background |

#### Window Management

- **Divider Mode**: Right side only (`window-divider-mode`)
- **State Persistence**: Auto-save/restore window position and size
- **Fullscreen**: Maximized by default, toggle with `C-c z`

### 📊 Mode Line Enhancements

#### Display Information

| Item | Description |
|------|-------------|
| **Memory Usage** | Real-time RSS display (cached via timer) |
| **GC Stats** | GC count + total elapsed time |
| **Uptime** | Emacs session duration |
| **Input Events** | Keyboard input statistics |
| **Current Function** | Via `which-function-mode` |
| **Battery** | Laptop battery status |
| **Time** | System date and time |

#### Tab Line

- Buffer icons via `all-the-icons`
- Buffer cycling support

### 🔍 Search & Completion

| Feature | Package | Description |
|---------|---------|-------------|
| **Fuzzy Search** | `ivy` + `swiper` | Fast file/symbol search |
| **Auto Completion** | `company` + `company-quickhelp` | Code completion + quick help |
| **Snippets** | `yasnippet` | Template-based code input |
| **Dev Tools** | `helpful` + `embark` | Enhanced help and context actions |

---

## 📦 Configured Packages

### Package List

```elisp
package-selected-packages = '(
    ;; Search & Navigation
    ivy swiper marginalia embark

    ;; Completion
    company company-quickhelp

    ;; Development
    helpful yasnippet dirvish git-modes

    ;; UI Enhancement
    doom-modeline all-the-icons neotree
    rainbow-mode highlight-parentheses drag-stuff

    ;; Major Modes
    markdown-mode yaml-mode textile-mode

    ;; Utilities
    rainbow-delimiters page-break-lines ascii-table
    on-screen keycast htmlize
)
```

### Package Categories

| Category | Packages | Description |
|----------|----------|-------------|
| **Fuzzy Search** | `ivy`, `swiper`, `marginalia` | Fast file, symbol, and command search |
| **Auto Completion** | `company`, `company-quickhelp` | Intelligent code completion with documentation |
| **Development** | `helpful`, `embark`, `yasnippet` | Enhanced help, context actions, code templates |
| **Version Control** | `git-modes` | Git integration |
| **File Browser** | `dirvish` | Modern file manager |
| **UI Enhancement** | `doom-modeline`, `all-the-icons` | Beautiful mode line and icons |
| **Major Modes** | `markdown-mode`, `yaml-mode`, `textile-mode` | Text format support |
| **Visual Aids** | `rainbow-mode`, `highlight-parentheses` | Syntax highlighting enhancements |

---

## 🔧 Customization

### Path Configuration (`etc/acs-custom.el`)

```elisp
acs/c-appdata/           ; Data directory (cache, private data)
acs/c-clang-format-path  ; clang-format executable path
acs/c-clang-path         ; clang compiler path
acs/c-commonlisp-path    ; SBCL path
acs/c-python-path        ; Python interpreter path
acs/c-email              ; User email
acs/c-truename           ; User real name
acs/c-os                 ; Operating system version
```

### Package Archives

Uses **USTC ELPA Mirror** for faster downloads in China:

```elisp
package-archives = '(
    ("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
    ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
    ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")
)
```

**Archive Priorities**:
- `gnu` and `melpa` have equal priority (selects newer version)
- `nongnu` has lower priority

---

## 🖥️ Server Mode

### Starting the Server

```bash
# Start Emacs daemon in background
emacs --daemon

# Connect with GUI frame
emacsclient -c -n

# Connect in terminal mode
emacsclient -t
```

### Window State Management

| Feature | Description |
|---------|-------------|
| **Auto-Save** | Saves window position and size when last frame closes |
| **Auto-Restore** | Restores saved state when creating new frames |
| **Multi-Frame** | Each new frame inherits saved state |

### Startup Notification

Server mode sends a system notification on launch:

```
📢 Emacs Daemon Launched
Emacs has started in the background
Time: X.XX seconds
```

---

## 🎹 Key Bindings

### Window Management

| Key | Function |
|-----|----------|
| `C-c z` | Exit fullscreen, restore window position |

### Menu Cleanup

The following menu items are disabled for a cleaner interface:

- **File Menu**: Close tab, delete frame, exit Emacs, etc.
- **Edit Menu**: Copy, cut, paste (use keyboard shortcuts instead)
- **Options Menu**: CUA mode, customize settings, etc.
- **Help Menu**: About Emacs, manuals (accessible via shortcuts)

---

## ⚙️ Advanced Configuration

### Encoding

```elisp
file-name-coding-system = 'chinese-gb18030
```

Uses GB18030 encoding for filename handling, compatible with Chinese Windows systems.

### Scroll Bar

| Property | Value |
|----------|-------|
| **Position** | Right |
| **Width** | 28px |
| **Mode** | Enabled |

### Fringe

| Setting | Value |
|---------|-------|
| **Left Fringe** | Disabled (width = 0) |
| **Right Fringe** | Enabled |
| **Empty Line Indicators** | Disabled |
| **Wrap Arrow** | Enabled (down arrow) |

### Cursor

| Property | Value |
|----------|-------|
| **Type** | Box |
| **Color** | Bright green (`chartreuse`) |
| **Blink** | Disabled |
| **Non-selected Windows** | Visible |

---

## ❓ FAQ

### Q1: First launch is very slow?

**A**: The first launch downloads and installs all declared packages.

**Recommendations**:
1. Ensure stable network connection
2. USTC mirror is pre-configured
3. Wait patiently (~30-60 seconds)

### Q2: Font display issues?

**A**: Ensure the following fonts are installed:
- Maple Mono NF CN (main programming font)
- Segoe UI Symbol (included with Windows)
- Segoe UI Emoji (included with Windows)

If Maple Mono is not installed, modify the font configuration in `acs-ui.el`.

### Q3: How to use on Linux/macOS?

**A**: This configuration is optimized for Windows. For other systems:
1. Modify path configurations in `acs-custom.el`
2. Adjust font configuration for your system
3. May need to change encoding settings

### Q4: How to customize themes?

**A**:
```elisp
M-x load-theme    ; Load a theme
M-x enable-theme  ; Enable a loaded theme
M-x disable-theme ; Disable a theme
```

Currently provides `acs-light-theme` and `acs-dark-theme`.

### Q5: How to reset window state?

**A**: Delete the window state files in `auto-save-list/` directory.

---

## 🔗 References

### Official Documentation

- [GNU Emacs Manual](https://www.gnu.org/software/emacs/manual/)
- [Emacs Wiki](https://www.emacswiki.org/)
- [Emacs Lisp Reference](https://www.gnu.org/software/emacs/manual/html_node/elisp/)

### Reference Projects

- [Doom Emacs](https://github.com/doomemacs/doomemacs) - UI design inspiration
- [Centaur Emacs](https://github.com/ema2159/centaur-emacs) - Font configuration reference
- [shynur's Emacs Config](https://github.com/shynur) - Core configuration source

### Package Archives

- [GNU ELPA](https://elpa.gnu.org/)
- [NonGNU ELPA](https://elpa.nongnu.org/)
- [MELPA](https://melpa.org/)

---

## 📝 Changelog

### v2.0 (Current)

| Type | Description |
|------|-------------|
| ✨ | Added window state persistence |
| ✨ | Added startup notification (server mode) |
| 🎨 | Enhanced mode line display (memory, GC stats) |
| ⚡ | Further optimized startup performance |
| 🐛 | Fixed Chinese filename encoding issues |

---

## 📄 License

This configuration is released under the **GPL-3.0** License.

---

## 🤝 Contributing

Issues and Pull Requests are welcome!

---

