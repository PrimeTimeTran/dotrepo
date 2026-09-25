echo "99. 🧪 wip loading..."

# Switch between Official Rust Analyzer versions and locally build ones
# 
# Points at the rust-analyzer installed by this specific Rust nightly toolchain:
# 
OFFICIAL_RA_BIN="$HOME/.rustup/toolchains/nightly-2026-06-30-aarch64-apple-darwin/bin/rust-analyzer"

# Points at locally compiled Rust Analyzer.
# 
CUSTOM_RA_BIN="$HOME/KB/project/app/rust-analyzer/target/release/rust-analyzer"
# echo $CUSTOM_RA_BIN
# $ ls -la "$OFFICIAL_RA_BIN"
# $ ls -la "$CUSTOM_RA_BIN"

# Install again
# $ rustup component add rust-analyzer --toolchain nightly-2026-06-30-aarch64-apple-darwin
function ra-ck() {
  # Which rust-analyzer will my shell execute?
  echo "Active binary path: $(which rust-analyzer)"
  echo "Version info: $(rust-analyzer --version)"
}
function ra-official() {
    mkdir -p "$HOME/bin"
    ln -sf "$OFFICIAL_RA_BIN" "$HOME/bin/rust-analyzer"
    hash -r
    echo "Switched to OFFICIAL rust-analyzer."
    ra-ck
}

function ra-custom() {
    mkdir -p "$HOME/bin"
    ln -sf "$CUSTOM_RA_BIN" "$HOME/bin/rust-analyzer"
    hash -r
    echo "Switched to CUSTOM rust-analyzer."
    ra-ck
}


alias rr="build_rust "
build_rust() {
    local file="$1"
    shift

    [[ -z "$file" ]] && {
        echo "usage: build_rust <file>"
        return 1
    }

    local src="target/$file"
    local name="${file%.*}"
    local out="tmp/$name"

    [[ -f "$src" ]] || {
        echo "Missing source: $src"
        return 1
    }

    mkdir -p tmp

    echo "=== Building $file ==="

    # cargo run --quiet -- "$src" -o "$out" "$@" || return 1
    cargo run -- "$src" -o "$out" "$@" || return 1

    echo
    echo "=== Running $name ==="

    "$out"
    local exit_code=$?

    echo
    echo "Exit status: $exit_code"

    return $exit_code
}
_build_examples() {
    local -a files
    local file

    files=()

    for file in target/*(.); do
        files+=("${file:t}")
    done

    _describe 'examples' files
}

alias ru-d='rustup doc'
alias ru-s='rustup doc --std'
alias ru-b='rustup doc --book'

alias cg='cargo'
alias cg-c='cg clean'
alias cg-ck='cg check'
alias cg-b='cg build'
alias cg-t='cg test'
alias cg-r='cg run --quiet' # Quiet is successful run. Noisy if not.

alias cck-s="cg-ck --message-format=short"
alias cck-se="cck-s 2>&1 | grep ' error\['"
alias cck-sef="cck-se | cut -d: -f1 | sort | uniq -c  | sort -nr"

alias cg-rm='cg-r --bin main'
alias cg-rb='cg-r --bin'

alias carf='cg fix --bin "setup_utility"'
alias cg-b-b='cg-b --bin'

alias cg-t-nc='cg-t -- --nocapture'
alias cg-t-nff='cg-t --no-fail-fast'
alias cg-t-nc-nff='cg-t-nc'
alias cg-t-pkg='cg-t --package '
alias cg-t-doc='cg-t --doc '
alias cg-nextest='cg nextest run'
alias cg-nt='cg-nextest --test-threads 1 --no-fail-fast'

alias cg-ir='cargo insta review'

# Run Cargo Nextest with various configs
cg-w-test() {
    local cmd_base="nextest run"
    local filters=""
    if [ "$#" -gt 0 ]; then
        for t in "$@"; do
            filters="$filters --test $t"
        done
    fi
    # local cmd_options="--test-threads 1 --no-fail-fast --features snapshotting"
    # local cmd_options="--test-threads 1"
    local cmd_options="--test-threads 1 --no-fail-fast"
    cargo watch -x "$cmd_base $filters $cmd_options"
}

function car-w-test-s() {
    local tests=("$@")
    local test_args=()
    for t in "${tests[@]}"; do
        test_args+=(--test "$t")
    done

    # cargo nextest run --test-threads 1 --no-fail-fast --features snapshotting "${test_args[@]}"
    cargo nextest run --test-threads 1 --no-fail-fast "${test_args[@]}"
}
