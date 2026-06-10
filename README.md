# Neovim Config

Personal Neovim configuration built on [LazyVim](https://lazyvim.github.io).

## Prerequisites

Install the following before cloning:

| Tool | Purpose |
|------|---------|
| `neovim >= 0.10` | Editor |
| `git` | Plugin management & version control |
| `ripgrep` | File content search (snacks.nvim picker) |
| `fd` | Fast file discovery (snacks.nvim picker) |
| `fzf` | Fuzzy finder |
| `node` + `npm` | Required by several LSPs (tsserver, npm-groovy-lint) |
| `python3` | Python LSP (basedpyright) and tooling |
| `go` | Go language support |
| `java 19+` | Groovy LSP and Gradle (Temurin recommended) |
| `lazygit` | Git UI (optional but recommended) |

**macOS (Homebrew) — install everything in one line:**

```sh
brew install neovim git ripgrep fd fzf node python go lazygit
```

**Java (Temurin 19):**

```sh
brew install --cask temurin@19
# or via SDKMAN: sdk install java 19-tem
```

## Installation

```sh
# Optional: back up an existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this config
git clone https://github.com/filipurminsky/nvim-config.git ~/.config/nvim

# Launch Neovim — plugins install automatically
nvim
```

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs all plugins. [Mason](https://github.com/williamboman/mason.nvim) then installs LSP servers, formatters, and linters in the background (~1–2 min on a fast connection).

Run `:checkhealth` after everything finishes to verify your setup.

## Language Support

Go, Python, TypeScript/JavaScript, Java, Groovy, Terraform, Ansible, Docker, Helm, YAML, JSON, SQL, Markdown, Tailwind CSS.

## Key Plugins

- [LazyVim](https://github.com/LazyVim/LazyVim) — plugin framework and sensible defaults
- [snacks.nvim](https://github.com/folke/snacks.nvim) — file picker, explorer, notifications, and more
- [nvim-surround](https://github.com/kylechui/nvim-surround) — surround text objects
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) — git diff and merge tool
- [darcula-dark](https://github.com/xiantang/darcula-dark.nvim) — colorscheme
- [claudecode.nvim](https://github.com/greggh/claudecode.nvim) — Claude Code integration

## Claude Code Integration

`claudecode.nvim` requires the `claude` CLI available on your PATH:

```sh
npm install -g @anthropic-ai/claude-code
```
