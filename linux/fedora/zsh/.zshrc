# Oh My Zsh (optional; keep Zsh usable without it).
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  plugins=(git web-search)
  [[ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]] && plugins+=(zsh-autosuggestions)
  [[ -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]] && plugins+=(zsh-syntax-highlighting)
  source "$ZSH/oh-my-zsh.sh"
fi

# Optional development tools. These locations are Linux-friendly and only
# exported when they exist, so this file also works on machines without them.
if [[ -d "$HOME/Android/Sdk" ]]; then
  export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
  path=("$ANDROID_SDK_ROOT/emulator" "$ANDROID_SDK_ROOT/platform-tools" $path)
elif [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
  path=("$ANDROID_SDK_ROOT/emulator" "$ANDROID_SDK_ROOT/platform-tools" $path)
fi

if [[ -d "$HOME/.sdkman/candidates/java/current" ]]; then
  export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
elif [[ -d /usr/lib/jvm/java-21-openjdk ]]; then
  export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
fi
[[ -n "$JAVA_HOME" && -d "$JAVA_HOME/bin" ]] && path=("$JAVA_HOME/bin" $path)

# Add each tool directory once. Zsh's path array keeps this readable.
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
