# VS Anime Theme — Personalized VS Code Setup

A ready-to-drop VS Code configuration for a **web / platform developer** working
in **TypeScript**, **Shopify Liquid** theme development, and **Wix Velo** — with
an anime-flavoured ambience (custom wallpaper + Discord Rich Presence).

---

## What's in here

| File | Purpose |
| ---- | ------- |
| `.vscode/settings.json` | Editor config: JetBrains Mono + ligatures, format-on-save (Prettier), ESLint fix-on-save, inlay hints, minimap off, TS + Liquid indent rules, Catppuccin + Material icons, Error Lens, Better Comments, GitLens, **Background** (anime wallpaper) + **Discord Rich Presence**. |
| `.vscode/extensions.json` | Recommended-extensions list — VS Code prompts to install them when you open the folder. |
| `.vscode/typescript.code-snippets` | TypeScript component/module boilerplate (`tsfc`, `tsclass`, `tsasync`, `tshook`, `tszod`, `tsresult`, …). |
| `.vscode/liquid.code-snippets` | Shopify Liquid section/block/snippet boilerplate (`lsection`, `lblocks`, `lsnippet`, `lproductcard`, `lpaginate`, …). |
| `vscode-user/keybindings.json` | Custom shortcuts for fast file nav, multi-cursor editing, and terminal split. |
| `AGENTS.md` | Describes the stack & coding conventions so AI assistants get context automatically. |
| `CLAUDE.md` | Thin pointer to `AGENTS.md` for tools that read `CLAUDE.md`. |
| `tsconfig.json` | Backs "TS strict mode" — the real enforcement of every strict flag. |
| `.prettierrc.json` | Prettier rules matching the editor settings. |
| `assets/wallpaper/anime-verses.png` | The bundled anime + scripture wallpaper wired into the Background extension. |

---

## Install

### Option 0 — One command (macOS, easiest) ⭐

Clone the repo, then run the installer. It copies the wallpaper, fills in the
absolute path **for you**, installs settings/snippets/keybindings into your VS
Code User folder, and installs every extension — backing up anything it would
replace:

```bash
git clone https://github.com/JoshHil97/VS-Anime-Theme.git
cd VS-Anime-Theme
bash install.sh
```

Then install the JetBrains Mono font and reload VS Code (the script reminds you).
Prefer to do it by hand? Use the options below.

### Option A — Per project (recommended)

Copy the repo files into your project root. The `.vscode/` folder, `AGENTS.md`,
`CLAUDE.md`, `tsconfig.json`, and `.prettierrc.json` all work as-is:

```bash
cp -r .vscode AGENTS.md CLAUDE.md tsconfig.json .prettierrc.json /path/to/your/project/
```

Open the project in VS Code → accept the recommended-extensions prompt.

> **Keybindings** are user-scoped (VS Code has no per-workspace keybindings), so
> install those globally — see Option B.

### Option B — Global VS Code user folder

Drop files into your VS Code **User** directory:

- **macOS:** `~/Library/Application Support/Code/User/`
- **Windows:** `%APPDATA%\Code\User\`
- **Linux:** `~/.config/Code/User/`

Then:

1. **Keybindings:** copy `vscode-user/keybindings.json` → `User/keybindings.json`.
2. **Settings:** merge `.vscode/settings.json` into `User/settings.json`
   (global defaults for every project).
3. **Snippets:** copy `.vscode/*.code-snippets` → `User/snippets/`.

### Install the extensions

From the Command Palette: **"Extensions: Show Recommended Extensions"**, or CLI:

```bash
code --install-extension catppuccin.catppuccin-vsc \
     --install-extension pkief.material-icon-theme \
     --install-extension eamodio.gitlens \
     --install-extension usernamehw.errorlens \
     --install-extension christian-kohler.path-intellisense \
     --install-extension esbenp.prettier-vscode \
     --install-extension dbaeumer.vscode-eslint \
     --install-extension shopify.theme-check-vscode \
     --install-extension formulahendry.auto-rename-tag \
     --install-extension aaron-bond.better-comments \
     --install-extension shalldie.background \
     --install-extension icrawl.discord-vscode
```

Install the **JetBrains Mono** font from
<https://www.jetbrains.com/lp/mono/> so the font/ligature settings take effect.

---

## Finishing the anime setup

### Background wallpaper (`shalldie.background`)

A wallpaper ships with this repo at **`assets/wallpaper/anime-verses.png`**
(anime characters + scripture collage). The Background extension requires an
**absolute `file://` path**, so open `.vscode/settings.json` and replace
`/ABSOLUTE/PATH/TO/` under `background.editor.images` (and, if you enable it,
`background.fullscreen.image`) with this repo's real location:

```jsonc
"images": [
  // macOS / Linux
  "file:///Users/you/VS-Anime-Theme/assets/wallpaper/anime-verses.png"
  // Windows:
  // "file:///C:/Users/you/VS-Anime-Theme/assets/wallpaper/anime-verses.png"
]
```

Tip: run `pwd` (macOS/Linux) inside the repo to get the absolute path. Swap in
any other image the same way. Opacity is preset to **0.12** (within your
10–15 % target) so code stays fully readable. The Background extension patches VS Code's files, so after changing the
wallpaper you'll see a one-time **"VS Code installation appears corrupt"**
warning — click the gear → **Don't Show Again**. It's expected; the extension
re-applies itself on each VS Code update (just run its *Reload* command).

### Discord Rich Presence (`icrawl.discord-vscode`)

Make sure the Discord desktop app is running. Presence is enabled by default with
anime-styled status strings (`⚔️ Editing …`, `🌸 Idling in the code dojo`).
Tweak the `discord.*` keys in `settings.json` to taste. Run
**"Discord Presence: Reconnect to Discord Gateway"** if it doesn't connect.

---

## Keybinding cheatsheet

> macOS shown; swap `cmd` → `ctrl` on Windows/Linux.

| Shortcut | Action |
| -------- | ------ |
| `cmd+p` | Quick Open file |
| `cmd+t` | Go to symbol in workspace |
| `cmd+e` | Toggle last two editors |
| `cmd+[` / `cmd+]` | Navigate back / forward |
| `cmd+d` | Add next occurrence to selection |
| `cmd+shift+l` | Select all occurrences |
| `cmd+alt+↑/↓` | Add cursor above / below |
| `cmd+alt+i` | Cursor at end of each selected line |
| `cmd+\` | Split terminal |
| `` ctrl+` `` | Toggle terminal |
| `cmd+alt+←/→` | Focus prev / next terminal pane |
| `cmd+k z` | Maximize / restore panel |

---

## Notes

- `settings.json` and the snippet files use JSONC (comments allowed) — VS Code
  accepts this for its own config files.
- Strict TypeScript is enforced by `tsconfig.json`; the editor settings only make
  the strictness *visible* (inlay hints, style-check warnings).
- Some extension IDs have community forks; the ones listed are the widely-used
  originals as of this setup.
