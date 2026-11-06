# Your terminal and practice setup

Built November 5, 2026. The inventory, sample programs and verification log are saved with the Codex chat outputs at /Users/stefanbayne/Documents/Codex/2026-11-05/referenced-chatgpt-conversation-this-is-an/outputs.

## What belongs where

A terminal displays a shell. The shell finds programs through PATH. Neovim edits source files. A compiler or interpreter runs the source. A terminal does not itself add support for a programming language.

Ghostty -> Zsh -> kpractice -> Neovim -> devrun -> compiler/interpreter

Ghostty and WezTerm can use the same Zsh environment. Their window appearance and terminal shortcuts have separate configuration files.

| File in ~/dotfiles | Purpose |
| --- | --- |
| ghostty/.config/ghostty/config | New Ghostty appearance and pane shortcuts |
| zsh/.zshrc | Interactive shell startup, Oh My Zsh and Starship |
| zsh/.config/zsh/development.zsh | Shared tool paths, JDK 17 selection, Detekt runtime and Android SDK variables |
| practice/.config/nvim-practice/init.lua | New Neovim profile with no plugins |
| practice/.local/bin/kpractice | Selects the practice profile and opens Neovim |
| practice/.local/bin/devrun | Runs single-file C, C++, Java, Kotlin and Python programs |
| practice/.local/bin/krun | Compiles a Kotlin source file and runs its temporary JAR |

The live configuration files are symbolic links into these packages. Editing either path edits the same file. Changes in the repository are uncommitted so you can review them.

## Ghostty settings

This file was written for you using Ghostty's documented options. It is independent of your WezTerm Lua configuration.

- Font size 14; Ghostty uses its bundled default font.
- Dark slate background, light text and a cyan block cursor.
- Opaque window with 10px horizontal and 8px vertical padding.
- Steady cursor and confirmation before closing a running process.
- Existing default shortcuts remain available alongside the custom shortcuts below.

| Shortcut | Action |
| --- | --- |
| Ctrl Shift Enter | Split right |
| Ctrl Shift Backslash | Split below |
| Ctrl Shift H/J/K/L | Move between terminal panes |
| Ctrl Shift Z | Zoom the current pane |
| Command Shift Comma on macOS | Reload Ghostty configuration |

For example, `background-opacity = 1` makes the window opaque. `keybind = ctrl+shift+enter=new_split:right` connects a key combination to a Ghostty action.

Ctrl H/J/K/L belongs to navigation inside Neovim; adding Shift moves between Ghostty panes instead. A pane is a separate shell, so you can edit on one side and run commands on the other.

Reference: https://ghostty.org/docs/config

## Shell and languages

`typeset -U path PATH` keeps Zsh's path array unique. PATH is an ordered list of directories: the shell uses the first matching program. `whence -p python3` shows which Python it finds.

On macOS, the configuration finds Homebrew at /opt/homebrew or /usr/local, selects JDK 17 through java_home or its stable Homebrew path, and uses the already installed Homebrew Python 3.14. It includes the existing Ruby path. An activated Python virtual environment stays first when this file is reloaded.

On Linux, it uses the system tool paths and leaves JDK selection to the machine. It looks for an Android SDK under ~/Android/Sdk rather than the macOS ~/Library/Android/sdk location. Existing ANDROID_HOME or ANDROID_SDK_ROOT values take priority; both are then set to the same SDK. Only tool directories that exist are added.

| Language | Tool used on this Mac | Run one file |
| --- | --- | --- |
| C | Apple Clang, through cc | devrun main.c |
| C++ | Apple Clang, through c++ | devrun main.cpp |
| Java | JDK 17 | devrun Main.java |
| Kotlin | Kotlin 2.4.21 with JDK 17 | devrun Main.kt |
| Python | Homebrew Python 3.14, or the active venv | devrun main.py |

C uses C17; C++ uses C++20. Both enable common warnings and debugging information. CC and CXX can select another compiler. Java uses source-file launch mode. Kotlin is compiled into a JAR containing its standard runtime, then Java runs it. Temporary build files are removed after the program exits. Arguments and standard input pass through to the program.

The runner is for one source file with standard libraries. Use your project's build tool for multiple files, external dependencies, or Android apps. Use each production project's ./gradlew rather than the globally installed Gradle.

The old global CPPFLAGS pointed at JDK 17 headers while the shell selected JDK 17. The new configuration does not set that variable. Projects needing JNI headers should set their own include flags.

For Python dependencies, create an environment inside that project:

```sh
python3 -m venv .venv
source .venv/bin/activate
python -m pip install package-name
# Finish with:
deactivate
```

Activation makes `python` and `pip` refer to that project's environment. No global aliases or automatic activation were added.

Reference: https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/

## Practice Neovim

`kpractice Main.kt` sets NVIM_APPNAME=nvim-practice before starting Neovim. That selects ~/.config/nvim-practice and separate Neovim data directories. Running `nvim` directly still opens your existing profile.

The practice profile uses built-in syntax highlighting, file browsing and terminal support. It adds line numbers, relative line numbers, four-space indentation, search preferences, persistent undo and a few shortcuts. There is no plugin manager, completion engine, formatter or language server in this profile.

| Shortcut | Action |
| --- | --- |
| Space w | Save the file |
| Space e | Browse files using :Explore |
| Space r | Save and run the current source file in a terminal split |
| Ctrl H/J/K/L | Move between editor windows |
| Escape twice in the terminal | Leave terminal input mode |
| :close | Close the run-output split |
| :Tutor | Open Neovim's editing tutorial |

Press Space and then the lowercase letter; these are sequences, not simultaneous key presses. The same profile works with .c, .cpp, .java, .kt and .py files. Use normal Vim commands such as :edit, :split, :vsplit, :write and :quit to practice.

Each run opens a new output split. Close it with :close after returning to normal mode. This keeps the runner simple and the output visible.

## Start a session

Open a new Ghostty window so it starts with the new environment. An old terminal can still carry the former exported CPPFLAGS; use `unset CPPFLAGS` and `exec zsh -l` there if needed.

Open Main.kt from /Users/stefanbayne/Documents/Codex/2026-11-05/referenced-chatgpt-conversation-this-is-an/outputs/practice with `kpractice Main.kt`. Press Space r to run its Two Sum checks. The folder also contains short C, C++, Java and Python examples.

Use :Tutor for editing practice, then work on one problem at a time. Keep Android Studio for production builds, previews, profiling and debugging.

## macOS and Fedora

The Ghostty config and practice profile contain no macOS-only window settings or Command-only custom shortcuts. The shared shell file separates macOS SDK/JDK discovery from Linux behavior. The remaining .zprofile is still specific to this Mac's Toolbox installation and locale.

To move these packages to Fedora, first install Zsh, Neovim 0.11 or newer, a C/C++ toolchain, JDK 17, Python 3 with venv, Kotlin's command-line compiler, Git and GNU Stow. Install Ghostty using its current official Linux installation instructions. Add Oh My Zsh and the configured shell plugins if using the full .zshrc; Starship is optional. Keep Java selection and any Python version manager specific to the Fedora machine.

Clone your dotfiles and preview only these packages first:

```sh
stow --simulate --verbose zsh ghostty practice
```

After resolving any conflicts deliberately, run the same command without --simulate. Existing nvim, Starship and WezTerm packages are separate choices. Never use --adopt to overwrite an existing configuration without reviewing it.

Fedora was not accessed or tested in this session. Terminal shortcuts can also be intercepted by a desktop's global shortcuts.

## Review and rollback

A snapshot of the original .zshrc, including your existing Ruby PATH edit, is in the backup directory recorded in backup-location.txt. The backup lives in this chat's work/backups directory. The original WezTerm files and existing Neovim configuration were checked for unintended changes. No IDE versions, SDK platforms, build-tools, caches or applications were deleted.

To roll back the shell, copy the backed-up .zshrc over ~/dotfiles/zsh/.zshrc and open a new shell. This restores its earlier settings without changing the ~/.zshrc link. The new Ghostty and practice profiles can remain dormant until you choose to remove their links. Do not automatically delete the new packages or uninstall tools if you have begun using them.

Android Studio's runtime, SDKs and project Gradle settings were not changed. The absent SDK command-line tools and old version-specific JDK entries are documented in inventory.md for a future project-aware review.
