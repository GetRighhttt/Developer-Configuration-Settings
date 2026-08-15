# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  web-search
)

source "$ZSH/oh-my-zsh.sh"

# Development tools
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# Add each tool directory once. Zsh's path array keeps this readable.
typeset -U path PATH
path=(
  "$JAVA_HOME/bin"
  "$ANDROID_SDK_ROOT/emulator"
  "$ANDROID_SDK_ROOT/platform-tools"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "$HOME/.local/bin"
  $path
)

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"
