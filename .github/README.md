# ACS Emacs Configuration

个人定制的 Emacs 配置，注重性能优化和美观的 UI。

## 🚀 快速开始

### 环境要求

- **Emacs**: 28.0+ (推荐 29.0+)
- **操作系统**: Windows 11 (主要开发环境)
- **字体**: Maple Mono NF CN, Segoe UI Symbol, Segoe UI Emoji

### 安装步骤

```bash
# 克隆配置到 ~/.emacs.d
git clone <repository-url> ~/.emacs.d

# 启动 Emacs
emacs
```

首次启动时会自动安装 `package-selected-packages` 中声明的包。

---

## 📁 项目结构

```
.emacs.d/
├── early-init.el          # 早期初始化 (包系统初始化前)
├── init.el                # 主配置文件
├── lisp/                  # 自定义模块
│   ├── acs-early-init.el  # 早期初始化逻辑
│   ├── acs-init.el        # 主初始化逻辑
│   ├── acs-package.el     # 包管理配置
│   └── acs-ui.el          # UI/字体配置
├── etc/                   # 其他配置文件
│   ├── acs-custom.el      # 自定义变量和宏
│   └── yas-snippets/      # Yasnippet 代码片段
├── .appdata/              # 运行时数据 (缓存等)
├── server/                # Emacs server 配置
└── site-lisp/             # 第三方库
```

---

## ⚡ 性能优化

### 启动优化 (`early-init.el`)

| 优化项 | 说明 |
|--------|------|
| `gc-cons-threshold` | 启动时调至最大，减少 GC 频率 |
| `gc-cons-percentage` | 设为 1.0，延迟 GC |
| `frame-inhibit-implied-resize` | 抑制启动时窗口大小调整 |
| `file-name-handler-alist` | 临时清空，加速文件操作 |
| `inhibit-redisplay` | 抑制启动时重绘 |

启动完成 1 秒后恢复上述变量的原始值。

---

## 🎨 UI 特性

### 字体配置

```elisp
默认字体：Maple Mono NF CN
符号字体：Segoe UI Symbol
Emoji 字体：Segoe UI Emoji
中文字体：跟随默认字体
```

### 界面定制

| 组件 | 样式 |
|------|------|
| 光标 | 亮绿色背景 (`chartreuse`) |
| 行号 | 斜体细字重，当前行黑体 |
| 倍数行号 | 带下划线 |
| 窗口分隔线 | 紫罗兰色，12 像素宽 |
| 缩进参考线 | 深海绿色 |
| 填充列指示器 | 黄色，黑色背景 |
| 提示框 | 深岩灰色背景，字号 100 |

### 窗口管理

- **窗口分隔线模式**: 仅右侧显示 (`window-divider-mode`)
- **窗口状态持久化**: 自动保存/恢复窗口大小和位置
- **全屏支持**: 可配置最大化/全屏启动

---

## 📦 已配置的包

在 `acs-package.el` 中声明的主要包：

| 类别 | 包名 |
|------|------|
| **模糊搜索** | ivy, swiper, marginalia |
| **自动补全** | company, company-quickhelp |
| **开发辅助** | helpful, embark, yasnippet |
| **版本控制** | git-modes |
| **UI 增强** | doom-modeline, all-the-icons, neotree |
| **语言模式** | markdown-mode, yaml-mode, powershell, textile-mode |
| **其他** | rainbow-mode, highlight-parentheses, drag-stuff |

---

## 🔧 自定义配置

### 路径配置 (`etc/acs-custom.el`)

```elisp
acs/c-appdata/           ; 数据目录
acs/c-clang-format-path  ; clang-format 路径
acs/c-clang-path         ; clang 路径
acs/c-python-path        ; Python 解释器路径
acs/c-email              ; 邮箱地址
acs/c-truename           ; 用户名
```

### 包源配置

使用中科大 ELPA 镜像：

```elisp
gnu    → https://mirrors.ustc.edu.cn/elpa/gnu/
nongnu → https://mirrors.ustc.edu.cn/elpa/nongnu/
melpa  → https://mirrors.ustc.edu.cn/elpa/melpa/
```

---

## 🖥️ Emacsclient 使用

配置支持 server 模式，可使用 `emacsclient` 快速连接：

```bash
# 启动 server
emacs --daemon

# 连接客户端
emacsclient -c -n

# 连接终端模式
emacsclient -t
```

窗口状态会在最后一个 frame 关闭时自动保存。

---

## 📝 注意事项

1. **Windows 路径**: 配置针对 Windows 路径进行了优化，Linux/macOS 用户需修改相关路径
2. **字体依赖**: 需要安装 Maple Mono NF CN 字体，否则回退到系统默认
3. **编码设置**: 默认使用 `chinese-gb18030` 编码处理文件名

---

## 🔗 参考资源

- [GNU Emacs Manual](https://www.gnu.org/software/emacs/manual/)
- [Emacs Wiki](https://www.emacswiki.org/)
- [Doom Emacs](https://github.com/doomemacs/doomemacs) - 部分 UI 设计参考
- [Centaur Emacs](https://github.com/ema2159/centaur-emacs) - 字体配置参考
