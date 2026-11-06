# Homebrew on Apple Silicon and Intel Macs; Fedora uses its normal system PATH.
typeset -U path PATH
if [[ "$OSTYPE" == darwin* ]]; then
  for brew_prefix in /opt/homebrew /usr/local; do
    if [[ -x "$brew_prefix/bin/brew" ]]; then
      path=("$brew_prefix/bin" "$brew_prefix/sbin" $path)
      [[ -d "$brew_prefix/opt/ruby/bin" ]] && path=("$brew_prefix/opt/ruby/bin" $path)
      # Use the already installed Homebrew Python, without changing Apple's Python.
      [[ -x "$brew_prefix/opt/python@3.14/libexec/bin/python3" ]] && path=("$brew_prefix/opt/python@3.14/libexec/bin" $path)
      break
    fi
  done
  unset brew_prefix
  # Production Gradle and Detekt use JDK 17; language servers select their own runtime.
  selected_java=$(/usr/libexec/java_home -F -v 17 2>/dev/null) || selected_java=""
  if [[ -z "$selected_java" ]]; then
    for jdk_home in /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home /usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home; do
      if [[ -x "$jdk_home/bin/java" ]]; then
        selected_java="$jdk_home"
        break
      fi
    done
    unset jdk_home
  fi
  if [[ -n "$selected_java" ]]; then
    export JAVA_HOME="$selected_java"
    if [[ ! -x "${DETEKT_JAVA_HOME:-}/bin/java" ]]; then
      export DETEKT_JAVA_HOME="$JAVA_HOME"
    fi
  fi
  unset selected_java
  default_android_sdk="$HOME/Library/Android/sdk"
else
  default_android_sdk="$HOME/Android/Sdk"
  # JAVA_HOME can be set by the machine's JDK manager on Fedora.
fi

if [[ -n "${ANDROID_HOME:-}" ]]; then
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
elif [[ -n "${ANDROID_SDK_ROOT:-}" ]]; then
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
elif [[ -d "$default_android_sdk" ]]; then
  export ANDROID_HOME="$default_android_sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
fi
unset default_android_sdk

[[ -n "${JAVA_HOME:-}" && -d "$JAVA_HOME/bin" ]] && path=("$JAVA_HOME/bin" $path)
if [[ -n "${ANDROID_HOME:-}" ]]; then
  for sdk_bin in "$ANDROID_HOME/platform-tools" "$ANDROID_HOME/emulator" "$ANDROID_HOME/cmdline-tools/latest/bin"; do
    [[ -d "$sdk_bin" ]] && path+=("$sdk_bin")
  done
  unset sdk_bin
fi
for tool_bin in "$HOME/.local/bin" "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"; do
  [[ -d "$tool_bin" ]] && path=("$tool_bin" $path)
done
unset tool_bin
# JNI headers belong in the project that needs them, rather than global CPPFLAGS.

# Reloading the shell must keep an activated project's Python environment first.
[[ -n "${VIRTUAL_ENV:-}" && -d "$VIRTUAL_ENV/bin" ]] && path=("$VIRTUAL_ENV/bin" $path)
