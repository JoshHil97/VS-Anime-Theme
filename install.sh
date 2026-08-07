#!/usr/bin/env bash
#
# install.sh — one-command setup for the VS-Anime-Theme VS Code environment.
#
# What it does (macOS):
#   1. Copies the anime wallpaper to ~/Pictures/anime-verses.png
#   2. Writes settings.json into your VS Code User folder with the wallpaper
#      path filled in AUTOMATICALLY (no manual editing).
#   3. Installs the snippets and keybindings globally.
#   4. Installs all recommended extensions via the `code` CLI.
#   5. Backs up anything it would overwrite first (nothing is lost).
#
# Usage:
#   cd into this repo, then:  bash install.sh
#
#   To use YOUR OWN image as the wallpaper, pass its path:
#     bash install.sh "/Users/you/Downloads/my-anime-pic.jpeg"
#   (If you don't pass one, the bundled collage wallpaper is used.)
#
set -euo pipefail

# Optional first argument: a custom wallpaper image to use instead of the bundle.
CUSTOM_WALLPAPER="${1:-}"

# ------------------------------------------------------------------
# Locate this repo (so the script works no matter where you cloned it)
# ------------------------------------------------------------------
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
SNIPPETS_DIR="$USER_DIR/snippets"
WALLPAPER_SRC="$REPO_DIR/assets/wallpaper/anime-verses.png"
WALLPAPER_DEST="$HOME/Pictures/anime-verses.png"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "==> VS-Anime-Theme installer"
echo "    Repo:        $REPO_DIR"
echo "    VS Code User: $USER_DIR"
echo

# ------------------------------------------------------------------
# 0. Sanity checks
# ------------------------------------------------------------------
if [[ "$(uname)" != "Darwin" ]]; then
  echo "!! This script targets macOS. For Windows/Linux, see README.md."
  exit 1
fi
mkdir -p "$USER_DIR" "$SNIPPETS_DIR"

# ------------------------------------------------------------------
# 1. Wallpaper -> ~/Pictures, and compute its absolute file:// URL
# ------------------------------------------------------------------
echo "==> [1/5] Installing wallpaper"
# If the user passed their own image, use that; otherwise use the bundled one.
if [[ -n "$CUSTOM_WALLPAPER" ]]; then
  if [[ -f "$CUSTOM_WALLPAPER" ]]; then
    WALLPAPER_SRC="$CUSTOM_WALLPAPER"
    echo "    Using your image: $CUSTOM_WALLPAPER"
  else
    echo "    !! Your image was not found at: $CUSTOM_WALLPAPER"
    echo "       Falling back to the bundled collage wallpaper."
  fi
fi
if [[ -f "$WALLPAPER_SRC" ]]; then
  cp "$WALLPAPER_SRC" "$WALLPAPER_DEST"
  echo "    Copied wallpaper to: $WALLPAPER_DEST"
else
  echo "    !! Wallpaper not found at $WALLPAPER_SRC — skipping copy."
fi
WALLPAPER_URL="file://$WALLPAPER_DEST"   # e.g. file:///Users/you/Pictures/anime-verses.png
echo "    Wallpaper URL:       $WALLPAPER_URL"

# ------------------------------------------------------------------
# 2. settings.json — fill in the wallpaper path, then install/merge
# ------------------------------------------------------------------
echo "==> [2/5] Installing settings.json"
TMP_SETTINGS="$(mktemp)"
# Replace both placeholder path spots with the real wallpaper URL.
sed "s#file:///ABSOLUTE/PATH/TO/VS-Anime-Theme/assets/wallpaper/anime-verses.png#${WALLPAPER_URL}#g" \
  "$REPO_DIR/.vscode/settings.json" > "$TMP_SETTINGS"

if [[ -f "$USER_DIR/settings.json" ]]; then
  cp "$USER_DIR/settings.json" "$USER_DIR/settings.json.bak-$STAMP"
  echo "    Existing settings backed up to: settings.json.bak-$STAMP"
  # Merge: your existing values + ours (ours win on conflicts).
  # Comments are dropped by the merge, but your original is safe in the backup.
  python3 - "$USER_DIR/settings.json.bak-$STAMP" "$TMP_SETTINGS" "$USER_DIR/settings.json" <<'PY'
import json, re, sys

def strip_jsonc(s):
    out, in_str, q, i = [], False, "", 0
    while i < len(s):
        c = s[i]; n = s[i+1] if i+1 < len(s) else ""
        if in_str:
            out.append(c)
            if c == "\\": out.append(n); i += 2; continue
            if c == q: in_str = False
            i += 1; continue
        if c in ('"', "'"): in_str = True; q = c; out.append(c); i += 1; continue
        if c == "/" and n == "/":
            while i < len(s) and s[i] != "\n": i += 1
            continue
        if c == "/" and n == "*":
            i += 2
            while i < len(s) and not (s[i] == "*" and s[i+1:i+2] == "/"): i += 1
            i += 2; continue
        out.append(c); i += 1
    text = "".join(out)
    text = re.sub(r",(\s*[}\]])", r"\1", text)  # trailing commas
    return text

def load(path):
    with open(path) as f: return json.loads(strip_jsonc(f.read()))

existing, ours, dest = sys.argv[1], sys.argv[2], sys.argv[3]
merged = load(existing)
merged.update(load(ours))   # ours win
with open(dest, "w") as f:
    json.dump(merged, f, indent=2, ensure_ascii=False)
    f.write("\n")
print("    Merged your settings with the anime theme (ours win on conflicts).")
PY
else
  cp "$TMP_SETTINGS" "$USER_DIR/settings.json"
  echo "    Wrote fresh settings.json (kept comments)."
fi
rm -f "$TMP_SETTINGS"

# ------------------------------------------------------------------
# 3. Snippets + keybindings
# ------------------------------------------------------------------
echo "==> [3/5] Installing snippets & keybindings"
cp "$REPO_DIR/.vscode/typescript.code-snippets" "$SNIPPETS_DIR/"
cp "$REPO_DIR/.vscode/liquid.code-snippets"     "$SNIPPETS_DIR/"
echo "    Snippets installed."

if [[ -f "$USER_DIR/keybindings.json" ]]; then
  cp "$USER_DIR/keybindings.json" "$USER_DIR/keybindings.json.bak-$STAMP"
  echo "    Existing keybindings backed up to: keybindings.json.bak-$STAMP"
fi
cp "$REPO_DIR/vscode-user/keybindings.json" "$USER_DIR/keybindings.json"
echo "    Keybindings installed."

# ------------------------------------------------------------------
# 4. Extensions
# ------------------------------------------------------------------
echo "==> [4/5] Installing extensions"
EXTS=(
  catppuccin.catppuccin-vsc
  catppuccin.catppuccin-vsc-icons
  pkief.material-icon-theme
  eamodio.gitlens
  usernamehw.errorlens
  christian-kohler.path-intellisense
  esbenp.prettier-vscode
  dbaeumer.vscode-eslint
  shopify.theme-check-vscode
  sissel.shopify-liquid
  formulahendry.auto-rename-tag
  aaron-bond.better-comments
  shalldie.background
  icrawl.discord-vscode
)
if command -v code >/dev/null 2>&1; then
  for ext in "${EXTS[@]}"; do
    echo "    - $ext"
    code --install-extension "$ext" --force >/dev/null 2>&1 || echo "      (could not install $ext — install it manually later)"
  done
  echo "    Extensions done."
else
  echo "    !! The 'code' command isn't on your PATH."
  echo "       Open VS Code -> Cmd+Shift+P -> 'Shell Command: Install code command in PATH', then re-run this script."
fi

# ------------------------------------------------------------------
# 5. Done
# ------------------------------------------------------------------
echo
echo "==> [5/5] All set!"
echo
echo "Two things left that a script can't do for you:"
echo "  1. Install the JetBrains Mono font:  https://www.jetbrains.com/lp/mono/"
echo "     (download, unzip, double-click the .ttf files to install)."
echo "  2. In VS Code: Cmd+Shift+P -> 'Reload Window' to apply everything."
echo "     The Background extension may show a one-time 'installation corrupt'"
echo "     warning — click the gear -> 'Don't Show Again'. That's expected."
echo
echo "Enjoy your anime code dojo. ⚔️🌸"
