# Developer Configuration Settings

My development environment, kept in version control so I can rebuild a familiar terminal and editor setup without relying on memory. The root-level Stow packages are the original macOS setup. Fedora Linux has separate, Linux-friendly Zsh and WezTerm packages under `linux/fedora/`; shared Starship, Neovim, and Vim packages remain at the root.

This repository is intentionally personal rather than a universal bootstrap script. It reflects how I work today—primarily Android and Kotlin development—with a fast terminal workflow, a keyboard-focused Neovim setup, and a consistent Catppuccin-inspired interface.

## What is included

| Package | Configuration | Purpose |
| --- | --- | --- |
| `zsh` | `.zshrc` | macOS Oh My Zsh, Android/JDK environment variables, development paths, and Starship initialization |
| `starship` | `.config/starship/starship.toml` | Prompt symbols and language/tool indicators |
| `wezterm` | `.config/wezterm/wezterm.lua` | Terminal appearance, tabs, panes, links, and keyboard shortcuts |
| `nvim` | `.config/nvim/` | Lua-based Neovim configuration with LSP, completion, formatting, navigation, and Git tooling |
| `vim` | `.vimrc` | A minimal fallback Vim configuration |

The directory structure follows the [GNU Stow](https://www.gnu.org/software/stow/) package convention. Each package mirrors the path it should have beneath the home directory. On Fedora, use the Linux Zsh and WezTerm packages together with shared root packages; don't stow the root `zsh` or `wezterm` packages.

## Highlights

- A shared Catppuccin Mocha look across WezTerm and Neovim
- A shell environment prepared for Android SDK tools, JDK 21, Homebrew, and the VS Code command-line launcher
- Kotlin and Lua language support in Neovim through Mason and the built-in LSP client
- Completion with `blink.cmp`, formatting with `conform.nvim`, and syntax-aware editing with Treesitter
- Fast project navigation with Telescope and Oil
- Git change indicators and hunk actions with Gitsigns
- Reproducible Neovim plugin versions through `lazy-lock.json`

## Prerequisites

The root-level `zsh` and `wezterm` packages are designed for macOS. Shared packages such as `nvim`, `vim`, and `starship` also work on Fedora. macOS prerequisites include:

- [Homebrew](https://brew.sh/)
- [Git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [WezTerm](https://wezterm.org/)
- [Neovim](https://neovim.io/)
- JetBrains Mono and Symbols Nerd Font Mono, or compatible fonts
- JDK 21 and the Android SDK when using the Android-specific shell settings

The core command-line tools can be installed with Homebrew:

```sh
brew install git neovim starship stow
brew install --cask wezterm
```

The Zsh configuration also enables these Oh My Zsh plugins:

- [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
- [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)

Install them in the Oh My Zsh custom plugins directory before loading this `.zshrc`.

### Fedora Linux

Fedora-specific Zsh and WezTerm configurations are provided in `linux/fedora/`. These use Linux paths and Ctrl-based shortcuts. Use them with the shared root-level `nvim`, `vim`, and `starship` packages.

Install the command-line tools with DNF:

```sh
sudo dnf install git stow zsh neovim starship
```

Install WezTerm using its [official Linux installation instructions](https://wezterm.org/install/linux.html). For the Fedora RPM package, follow the Fedora/Copr instructions there. Install compatible JetBrains Mono and Symbols Nerd Font Mono fonts if you want the configured typography.

From the repository root, preview and then install the Fedora Zsh and WezTerm packages:

```sh
stow --simulate --verbose --dir=linux/fedora --target="$HOME" zsh wezterm
stow --simulate --verbose --target="$HOME" nvim vim starship
stow --verbose --dir=linux/fedora --target="$HOME" zsh wezterm
stow --verbose --target="$HOME" nvim vim starship
```

The Fedora Zsh config tolerates missing optional tools and Oh My Zsh plugins. It checks the standard Linux Android SDK and JDK locations before adding them to the environment. To use Zsh for the current terminal, run `zsh`; to make it the login shell, run `chsh -s "$(command -v zsh)"` and sign out and back in. The Fedora WezTerm config uses Ctrl-based shortcuts and OpenGL rendering.

## Installation

Clone the repository into the home directory. On Fedora, use the commands in [Fedora Linux](#fedora-linux) for Zsh and WezTerm, and install the shared packages as shown below:

```sh
git clone https://github.com/GetRighhttt/Developer-Configuration-Settings.git ~/dotfiles
cd ~/dotfiles
```

Before creating links, back up any existing configuration files that you want to keep. Then preview the changes Stow would make:

```sh
stow --simulate --verbose zsh vim nvim starship wezterm
```

If the preview looks correct, create the links:

```sh
stow --verbose zsh vim nvim starship wezterm
```

Restart the shell or reload its configuration:

```sh
exec zsh
```

On its first launch, Neovim bootstraps `lazy.nvim`. Mason then installs the configured language servers and formatting tools, so the initial setup requires an internet connection.

> [!CAUTION]
> Stow stops when a destination conflicts with a real file. Resolve those files deliberately instead of using `stow --adopt` without reviewing the result; `--adopt` can replace tracked repository content with the existing destination files.

## Machine-specific settings

Review `zsh/.zshrc` before using the macOS shell configuration on another Mac. It currently assumes:

- Android SDK at `$HOME/Library/Android/sdk`
- JDK 21 selected through `/usr/libexec/java_home`
- Homebrew OpenJDK 17 headers under `/opt/homebrew`
- Visual Studio Code installed in `/Applications`
- Starship configuration at `$HOME/.config/starship/starship.toml`

These values are preferences and machine assumptions, not required conventions. Adjust them to match the local toolchain.

## Neovim workflow

The leader key is `Space`.

| Shortcut | Action |
| --- | --- |
| `Space f f` | Find files |
| `Space f g` | Search project text |
| `Space f b` | Browse open buffers |
| `Space f h` | Search help tags |
| `Space f r` | Open recent files |
| `Space /` | Search within the current buffer |
| `Space e` or `-` | Open the Oil file explorer |
| `Space l f` | Format the current buffer |
| `Space l r` | Rename the symbol under the cursor |
| `Space l a` | Show available code actions |
| `Space w` | Save the current buffer |
| `Space x` | Close the current buffer |
| `Ctrl h/j/k/l` | Move between editor windows |
| `]c` / `[c` | Move between Git changes |
| `Space g p` | Preview the current Git hunk |
| `Space g b` | Show a line's Git blame information |

Formatting runs on save for Kotlin and Lua. Use `:FormatDisable` for the current buffer or `:FormatDisable!` globally when a project needs different behavior; `:FormatEnable` restores it.

## WezTerm workflow

| Shortcut | macOS | Fedora Linux |
| --- | --- | --- |
| Open a tab | `Command T` | `Ctrl T` |
| Close the active pane | `Command W` | `Ctrl W` |
| Split horizontally | `Command D` | `Ctrl D` |
| Split vertically | `Command Shift D` | `Ctrl Shift D` |
| Move between panes | `Ctrl Shift H/J/K/L` | `Ctrl Shift H/J/K/L` |
| Change font size | `Command +` / `Command -` | `Ctrl +` / `Ctrl -` |
| Reset font size | `Command 0` | `Ctrl 0` |
| Open command palette | `Command Shift P` | `Ctrl Shift P` |
| Open Quick Select | `Ctrl Shift Space` | `Ctrl Shift Space` |
| Search scrollback history | `Command Shift F` | `Ctrl Shift F` |
| Open a detected link | `Command-click` | `Ctrl-click` |

## Updating

Pull repository changes and ask Stow to refresh the links. On macOS, use the root-level packages. On Fedora, restow the Linux Zsh and WezTerm packages with shared packages:

```sh
cd ~/dotfiles
git pull --ff-only
stow --restow zsh vim nvim starship wezterm
```

On Fedora, run:

```sh
stow --restow --dir=linux/fedora --target="$HOME" zsh wezterm
stow --restow --target="$HOME" vim nvim starship
```

Inside Neovim, run `:Lazy sync` to update plugins and refresh `lazy-lock.json` when you intentionally want to move to newer plugin versions.

To remove the managed links without deleting this repository:

```sh
cd ~/dotfiles
stow --delete zsh vim nvim starship wezterm
```

## Repository hygiene

Keep credentials and machine secrets out of this repository. API keys, signing files, SSH keys, local environment files, and private tokens should be stored in an appropriate secret manager or an ignored local file.

When changing shared configuration, test it in a new terminal session before closing the current working session. That leaves a known-good shell available if a startup file contains an error.
