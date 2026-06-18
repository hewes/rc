# Neovim Configuration

## Plugin Manager

[vim-jetpack](https://github.com/tani/vim-jetpack) — run `:JetpackSync` after adding plugins.

All plugins are declared in `jetpack.vim`. Config files live in `plugin.d/` (auto-sourced on startup).

---

## Plugins

### LSP

| Plugin | Role |
|--------|------|
| `neovim/nvim-lspconfig` | LSP client config |
| `williamboman/mason.nvim` | LSP server installer |
| `williamboman/mason-lspconfig.nvim` | Bridge mason ↔ lspconfig (v2, uses `automatic_enable`) |
| `mfussenegger/nvim-jdtls` | Enhanced Java LSP (jdtls) — handles per-project workspace |
| `hedyhli/outline.nvim` | Symbol outline sidebar |

**Config:** `plugin.d/mason.lua`

LSP keybindings are set via `LspAttach` autocmd (applies to all servers except `jdtls`).
Java-specific bindings are in `after/ftplugin/java.lua` via nvim-jdtls `on_attach`.

**Installing servers:**
```
:MasonInstall <server>

# For Spring Boot (run inside devcontainer):
:MasonInstall jdtls spring-boot-tools
```

### Completion

| Plugin | Role |
|--------|------|
| `Shougo/ddc.vim` | Completion engine (denops-based) |
| `Shougo/pum.vim` | Popup menu |
| `Shougo/ddc-around` | Buffer-word source |
| `LumaKernel/ddc-source-file` | File path source |
| `shun/ddc-vim-lsp` | LSP source |
| `vim-skk/skkeleton` | Japanese input source |

> **Note:** `ddc#enable()` is currently commented out in `plugin.d/ddc.vim`. Completion runs via `<C-x><C-o>` (omnifunc) for LSP-enabled buffers, and manually via `<TAB>` when ddc is enabled.

### Fuzzy Finder / Navigation

| Plugin | Role |
|--------|------|
| `Shougo/ddu.vim` | Fuzzy finder (denops-based) |
| `Shougo/ddu-ui-ff` | Floating finder UI |
| `Shougo/ddu-source-file` / `file_rec` | File sources |
| `shun/ddu-source-rg` | ripgrep source |
| `shun/ddu-source-buffer` | Buffer list |
| `Shougo/ddu-source-file_old` | Recent files (MRU) |
| `Shougo/ddu-source-line` | Lines in buffer |
| `uga-rosa/ddu-source-lsp` | LSP symbols / references / definitions |
| `matsui54/ddu-source-help` | Help tags |
| `Shougo/ddu-source-register` | Registers |

**Config:** `plugin.d/ddu.vim`

### Editing

| Plugin | Role |
|--------|------|
| `tpope/vim-surround` | Surround text objects |
| `tpope/vim-repeat` | Repeat plugin actions with `.` |
| `scrooloose/nerdcommenter` | Comment/uncomment |
| `h1mesuke/vim-alignta` | Alignment |
| `kana/vim-smartchr` | Smart character insertion (per filetype) |
| `hadronized/hop.nvim` | EasyMotion-style jump |

### UI

| Plugin | Role |
|--------|------|
| `vim-airline/vim-airline` | Status line |
| `vim-airline/vim-airline-themes` | Airline themes (current: `wombat`) |
| `iamcco/markdown-preview.nvim` | Browser preview for Markdown |

### Infrastructure

| Plugin | Role |
|--------|------|
| `vim-denops/denops.vim` | Deno-based plugin runtime (required by ddc, ddu, skkeleton) |
| `vim-skk/skkeleton` | SKK Japanese input method |

---

## Key Mappings

### Leader Keys

| Key | Role |
|-----|------|
| `,` | `<leader>` |
| `m` | `<localleader>` |

### Normal Mode — General

| Key | Action |
|-----|--------|
| `<Leader><Leader>` | Next buffer |
| `<Space><Space>` | Alternate buffer (`<C-^>`) |
| `,t` | New tab |
| `<C-h>` / `<C-l>` | Previous / next tab |
| `Y` | Yank to end of line |
| `+` / `-` | Increase / decrease window height |
| `sw` | Start `:%s/\<word\>/` substitution |
| `sp` | Replace word with yank register |

### Toggle (`<Space>` prefix)

| Key | Toggles |
|-----|---------|
| `<Space>p` | `paste` |
| `<Space>w` | `wrap` |
| `<Space>n` | `number` |
| `<Space>l` | `list` |
| `<Space>h` | `hlsearch` |

### Tags (`t` prefix)

| Key | Action |
|-----|--------|
| `tt` | Jump to tag (`<C-]>`) |
| `tj` | `:tag` |
| `tk` | `:pop` |
| `tl` | `:tags` |

### Quickfix (`q` prefix)

| Key | Action |
|-----|--------|
| `qn` / `qp` | Next / prev quickfix item |
| `qo` / `qc` | Open / close quickfix window |
| `q<Space>` | Toggle quickfix window |
| `qwn` / `qwp` | Next / prev location list item |
| `qwo` / `qwc` | Open / close location list |

> `Q` is remapped to the original `q` (record macro).

### LSP (all LSP-enabled buffers)

| Key | Action |
|-----|--------|
| `gd` | Go to definition (ddu picker) |
| `gr` | References (ddu picker) |
| `gc` | Call hierarchy (ddu picker) |
| `K` | Hover docs (Java only) |
| `rn` | Rename symbol |
| `ma` | Code action |
| `<C-m>` | Signature help |
| `[d` / `]d` | Prev / next diagnostic |

### ddu Finder (`f` prefix)

| Key | Action |
|-----|--------|
| `fb` | Files in current buffer's directory |
| `fc` | Files in cwd |
| `fh` | Files in home directory |
| `fm` | Recently used files (MRU) |
| `fl` | Lines in current buffer |
| `fj` | Buffer list |
| `fo` | LSP document symbols |
| `fg` | ripgrep (prompts for pattern) |

#### Inside ddu window

| Key | Action |
|-----|--------|
| `<CR>` | Open file / narrow into directory |
| `i` | Open filter prompt |
| `j` / `k` | Navigate (wraps around) |
| `<C-n>` / `<C-p>` | Navigate (in filter) |
| `<Space>` | Toggle select item |
| `<TAB>` | Choose action |
| `u` | Go to parent directory |
| `p` | Toggle auto-preview |
| `e` | Expand / collapse item |
| `q` / `<C-j>` | Quit |

### Hop

| Key | Action |
|-----|--------|
| `Fw` | Jump to word (hop hints) |

### Outline

| Key | Action |
|-----|--------|
| `<Space>o` | Toggle outline sidebar |

### Markdown Preview

| Key | Action |
|-----|--------|
| `<Space>p` | Toggle browser preview |

### Java (additional, via nvim-jdtls)

| Key | Action |
|-----|--------|
| `,oi` | Organize imports |
| `,ev` | Extract variable |
| `,em` | Extract method |

### Japanese Input (SKK)

| Key | Action |
|-----|--------|
| `<C-j>` (insert) | Toggle skkeleton |

---

## Filetype Settings

| Filetype | Indent | Tabs |
|----------|--------|------|
| Default | 2 | spaces |
| Java | 4 | tabs |
| C / C++ | 4 | tabs |
| Go | 4 | tabs |
| Python | 4 | spaces |
| Ruby | 2 | spaces |
| Scala | 4 | tabs |

---

## Spring Boot / Java Setup

Java development runs inside a Docker devcontainer — Java is **not** installed on the host Mac.

**Devcontainer template** (add to Spring Boot projects as `.devcontainer/devcontainer.json`):

```json
{
  "name": "Spring Boot Dev",
  "image": "mcr.microsoft.com/devcontainers/java:21-bullseye",
  "features": {
    "ghcr.io/devcontainers/features/java:1": {
      "version": "21",
      "installMaven": "latest",
      "installGradle": "none"
    }
  },
  "mounts": [
    "source=${localEnv:HOME}/rc,target=/root/rc,type=bind,consistency=cached",
    "source=${localEnv:HOME}/.local/share/nvim,target=/root/.local/share/nvim,type=bind,consistency=cached"
  ],
  "postCreateCommand": "ln -sf /root/rc/nvim /root/.config/nvim && nvim --headless -c 'MasonInstall jdtls spring-boot-tools' -c 'qa'"
}
```

First time inside a container:
```
:JetpackSync
:MasonInstall jdtls spring-boot-tools
```

---

## Notable Configuration

- **Colorscheme:** `capybara` (falls back to `torte`)
- **Backup/undo:** `~/.backup/` with persistent undo for `~/*` files
- **Tab line:** custom function showing file paths, scrolls when tabs overflow
- **`updatetime`:** 500ms (triggers document highlight on `CursorHold`)
- **`virtualvedit=all`:** cursor can move past end of line
- **`clipboard=unnamed`:** yanks go to system clipboard
- **`ambiwidth=double`:** correct display of CJK ambiguous-width characters
- **`ddc#enable()`** is commented out — enable it in `plugin.d/ddc.vim` to activate auto-completion
- **`browsedir`** is guarded with `has('nvim')` — Neovim-only option
