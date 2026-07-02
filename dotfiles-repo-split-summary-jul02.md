# Dotfiles Repo Split — July 2, 2026

## Context
The old monolithic `~/dotfiles` repo (github.com/kaiserkimguin/dotfiles) bundled config for three unrelated machine types (macOS, an Omarchy-managed machine, and this self-riced Arch+Hyprland test bench) plus genuinely shared config in one tree. It didn't reflect reality: each machine only wants a subset, and this machine's actual rice — Hyprland (hand-built, Lua-based, no Omarchy), waybar, rofi, kitty, swaync, GTK/Qt theming, yazi, plus `/etc/greetd`, `/etc/nftables.conf`, `/etc/systemd/zram-generator.conf` — wasn't tracked in any git repo at all; it only lived on disk.

## Decisions made
- **4 repos instead of 1**, sibling dirs under `~`: `dotfiles-common`, `dotfiles-mac`, `dotfiles-omarchy`, `dotfiles-arch`.
- **Naming**: user kept `common`/`mac`/`omarchy` as proposed, renamed `self-riced-arch` → `dotfiles-arch`.
- **Visibility**: `dotfiles-arch` private (contains `/etc/nftables.conf`, `/etc/greetd/config.toml`); the other three public, matching the old repo.
- **History**: fresh single-commit start per repo, no `git filter-repo` — user already has a separate backup of the old repo's state.
- **bash split**: `dotfiles-common/bash/.bashrc` is a loader that sources `~/.bashrc.d/*.sh`. Only `dotfiles-omarchy` ships a drop-in (`omarchy.sh`, sources Omarchy's own default bash rc) — avoids two repos both owning `~/.bashrc`.
- **Old `~/dotfiles`**: left untouched (local checkout + GitHub remote), retired from use on this machine, not deleted.

## What got discovered mid-session
- This machine is **not** running Omarchy (`~/.local/share/omarchy` doesn't exist) — `start-hyprland` (referenced in the greetd config) turned out to be shipped by the plain `hyprland` pacman package, not Omarchy. Earlier assumptions (including my own prior memory) that this box was Omarchy-managed were wrong.
- `~/.config/gtk-4.0/{assets,gtk.css,gtk-dark.css}` were absolute symlinks into `~/.themes/Everforest-Dark-Medium/` (an installed theme, not rice config) — excluded from `dotfiles-arch`; the live symlinks were left untouched on disk.
- `~/.config/mako/` confirmed dead (superseded by swaync) — not migrated.

## Execution
1. Installed `gh` CLI (`sudo pacman -S github-cli`), user authenticated interactively.
2. Built all 4 repos locally: copied content from the old repo (`functional/`, `aesthetic/`, `mac/`, `omarchy/`) and from this machine's live `~/.config`/`/etc` into the new structure, wrote a `stow`-based `install.sh` per repo, committed.
3. Pushed all 4 to GitHub via `gh repo create --source=. --push`.
4. Re-stowed this machine: removed stale symlinks pointing at the old repo (`.bashrc`, `.tmux.conf`, `.config/{nvim,tmux,smug}`), ran `dotfiles-common/install.sh` (all packages), then `dotfiles-arch/install.sh` (`home/*` via `stow --adopt`, `system/*` via `sudo stow --adopt` for the `/etc` targets).
5. Verified: `sha256sum` on the 3 `/etc` files matched pre/post migration exactly; all target paths are now symlinks into the correct new repo; fresh `bash -lc` shell loads with no errors; `hyprctl reload` returned `ok`; greetd and zram-generator services active; waybar running.

## Still open (unchanged by this session, just re-homed)
- **Theme switcher** (4-axis: color/shape/font/wallpaper via templating, matugen vs hand-rolled) — still unstarted. Would now target `dotfiles-arch` rather than a single-repo `templates/`/`themes/` restructure.
- **G14 migration** (NVIDIA hybrid graphics, asusctl/supergfxctl, multi-monitor, keyd Copilot remap, nftables SSH exception) — still unstarted. `dotfiles-arch` is the base it'll fork/extend from.
- **Old `~/dotfiles`**: manual archive/delete is a follow-up the user can do whenever, not done here.
