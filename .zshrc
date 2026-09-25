# 0. Shell Init
# 0. Performance
# 1. Environment
# 2. PATH
# 3. User State
# 4. Oh My Zsh / Plugins
# 5. Tool initialization
# 6. User scripts

# ============================================================
# 0. Performance: Tool for bash loading metrics
# ============================================================
# zmodload zsh/zprof
# ============================================================
# 0. Shell initialization, Zsh completion state
# ============================================================
# FPATH/fpath is Zsh-internal state. Never inherit it from
# terminal hosts such as Zed.
typeset +x FPATH

fpath=(
  /usr/local/share/zsh/site-functions
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/Cellar/zsh/5.9/share/zsh/functions
)

# ============================================================
# 1. Environment
# ============================================================
## [-f ~/.zsh-env.zsh]: Compact shell conditional.
## [...]: Test
## -f: "Does this path exist and is it a regular file?"
[ -f ~/.config/zsh/env.zsh ] && source ~/.config/zsh/env.zsh

# -d path     # directory exists
# -e path     # anything exists
# -r path     # readable
# -w path     # writable
# -x path     # executable

# ============================================================
# 2. Paths
# ============================================================
[ -f ~/.config/zsh/path.zsh ] && source ~/.config/zsh/path.zsh

# ============================================================
# 3. User State
# ============================================================
[[ -f ~/.config/zsh/state.zsh ]] && source ~/.config/zsh/state.zsh

# ============================================================
# 4. Oh My Zsh / Plugins
# ============================================================
plugins=(zsh-autosuggestions cd-ls alias-tips)

source "$ZSH/oh-my-zsh.sh"
source "$ZSH/custom/themes/primetimetran.zsh-theme"

# ============================================================
# 5. Tool initialization
# ============================================================
load_nvm() {
  unset -f load_nvm node npm npx yarn
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm use default >/dev/null
}

node() {
  load_nvm
  command node "$@"
}

npm() {
  load_nvm
  command npm "$@"
}

npx() {
  load_nvm
  command npx "$@"
}

yarn() {
  load_nvm
  command yarn "$@"
}

eval "$(pyenv init -)"

# Vite+
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# ============================================================
# 6. User scripts & aliases
# ============================================================
[ -f ~/.config/zsh/secret.zsh ] && source ~/.config/zsh/secret.zsh
[ -f ~/.config/zsh/color.zsh ] && source ~/.config/zsh/color.zsh
[ -f ~/.config/zsh/std.zsh ] && source ~/.config/zsh/std.zsh
[ -f ~/.config/zsh/function.zsh ] && source ~/.config/zsh/function.zsh
[ -f ~/.config/zsh/alias.zsh ] && source ~/.config/zsh/alias.zsh
[ -f ~/.config/zsh/alias-git.zsh ] && source ~/.config/zsh/alias-git.zsh
[ -f ~/.config/zsh/completion.zsh ] && source ~/.config/zsh/completion.zsh
[ -f ~/.config/zsh/wip.zsh ] && source ~/.config/zsh/wip.zsh

echo "💯 ⌛️ Time flies..."

# ============================================================
# 0. Used with start of this file.
# ============================================================
# zprof

# # Point to the official one (adjust if yours is Homebrew or rustup)
# # If using rustup:
# export OFFICIAL_RA="$HOME/.cargo/bin/rust-analyzer"
# # Or if using Homebrew on Apple Silicon:
# # export OFFICIAL_RA="/opt/homebrew/bin/rust-analyzer"

# # Alias to explicitly run the official release
# alias ra-official="$OFFICIAL_RA"

# # Alias to explicitly run your custom build
# alias ra-custom="$HOME/bin/rust-analyzer"
# function ra-build-and-deploy() {
#     echo "1. Killing active rust-analyzer instances to release file locks..."
#     pkill -9 rust-analyzer 2>/dev/null
#     echo "2. Building custom rust-analyzer..."
#     # (Run your cargo build command here, e.g.:)
#     cargo build --release --manifest-path /path/to/rust-analyzer/Cargo.toml
#     echo "3. Copying to bin..."
#     cp /path/to/target/release/rust-analyzer ~/bin/rust-analyzer
#     echo "4. Clearing Zsh path cache..."
#     hash -r
#     echo "Done! Custom rust-analyzer is live."
# }
# Run your update script quickly
# alias ra-up="/Users/future/KB/update-rust-analyzer.sh"

# # Check which binary is currently executing
# function ra-check() {
#     echo "Active binary path: $(which rust-analyzer)"
#     echo "Version info: $(rust-analyzer --version)"
# }

# # Temporarily force fallback to the official toolchain rust-analyzer version
# function ra-use-official() {
#     # Point directly to the toolchain bin directory where rust-analyzer actually lives
#     export PATH="$HOME/.rustup/toolchains/nightly-2025-08-20-aarch64-apple-darwin/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
#     hash -r
#     echo "Switched current shell session to OFFICIAL rust-analyzer."
#     ra-check
# }

# # Force back to your custom ~/bin version
# function ra-use-custom() {
#     export PATH="$HOME/bin:$HOME/.rustup/toolchains/nightly-2025-08-20-aarch64-apple-darwin/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
#     hash -r
#     echo "Switched current shell session to CUSTOM rust-analyzer."
#     ra-check
# }
# Path to the official toolchain binary discovered earlier

# Pi
export PATH="/Users/future/.vite-plus/js_runtime/node/24.19.0/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/future/.lmstudio/bin"
# End of LM Studio CLI section

