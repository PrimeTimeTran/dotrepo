echo "05. 🔢 functions loading..."


# curl --url 'https://surrit.com/3e24bb42-23f2-4826-8f16-737f4227afad/842x480/video.m3u8' \
#   -H 'accept: */*' \
#   -H 'accept-language: en-US,en;q=0.9,nl;q=0.8' \
#   -H 'origin: https://missav.ws' \
#   -H 'priority: u=1, i' \
#   -H 'referer: https://missav.ws/dm26/en/ntk-217' \
#   -H 'sec-ch-ua: "Google Chrome";v="153", "Not_A Brand";v="8", "Chromium";v="153"' \
#   -H 'sec-ch-ua-mobile: ?0' \
#   -H 'sec-ch-ua-platform: "macOS"' \
#   -H 'sec-fetch-dest: empty' \
#   -H 'sec-fetch-mode: cors' \
#   -H 'sec-fetch-site: cross-site' \
#   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36'
# SIRO-5053
# SIRO-3171 
# SIRO-5033 
# https://surrit.com/7dc66d81-9e6b-46d2-a1ce-d0fd9f96dfd5/playlist.m3u8
# SIRO-1544 
# https://surrit.com/90a81f6e-4066-4ce0-b850-1e7fee10f99f/playlist.m3u8

# curl --url 'https://surrit.com/82f18b61-6c07-43d9-880b-694084a2d3ab/playlist.m3u8' \
#   -H 'sec-ch-ua-platform: "macOS"' \
#   -H 'Referer: https://missav.ws/dm14/en/siro-5053' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36' \
#   -H 'sec-ch-ua: "Google Chrome";v="153", "Not_A Brand";v="8", "Chromium";v="153"' \
#   -H 'sec-ch-ua-mobile: ?0'

# alias dls="downloadStream"
# downloadStream() {
#   ffmpeg -i "$2" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$1.mp4"
# }
alias dls1="downloadStream1"
downloadStream1() {
  yt-dlp \
   --add-header 'sec-fetch-mode: cors' \
   --add-header 'sec-fetch-site: cross-site' \
   --add-header 'accept: */*' \
   --add-header "referer: https://missav.ws/dm26/en/ntk-217" \
   --add-header "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36" \
   -c "$1" \
   -o "$2.mp4"
}

alias dls2="downloadStream2"
downloadStream2() {
  yt-dlp -o "$1.mp4" -c "$2"
}
# curl --url 'https://gcdn.nuvid.com/mp4_lq/40ae672fd53b98ba0a9141001324b06f.mp4?md5=SCE1ZQqJKwrl31AaGSOGkQ&expire=1790085025&speed=140k&buffer=1108k&tip=1' \
#   -H 'sec-ch-ua-full-version-list: "Google Chrome";v="153.0.8010.48", "Not_A Brand";v="8.0.0.0", "Chromium";v="153.0.8010.48"' \
#   -H 'sec-ch-ua-platform: "macOS"' \
#   -H 'Referer: https://www.nuvid.com/' \
#   -H 'sec-ch-ua: "Google Chrome";v="153", "Not_A Brand";v="8", "Chromium";v="153"' \
#   -H 'sec-ch-ua-model: ""' \
#   -H 'sec-ch-ua-mobile: ?0' \
#   -H 'sec-ch-ua-full-version: "153.0.8010.48"' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36' \
#   -H 'Range: bytes=0-' \
#   -H 'sec-ch-ua-platform-version: "15.3.2"'
alias dl="downloadStream"
downloadStream() {
  local first_arg_file_name="$1"
  # Downcase and replace spaces with hyphens
  first_arg_file_name="${first_arg_file_name,,}"
  first_arg_file_name="${first_arg_file_name// /-}"
  echo "$first_arg_file_name"
}

alias sc="searchCommand"
searchCommand() {
    fc -ln 0 | tac | grep "$@" | yank -l
}

# echo "In-memory limit: $HISTSIZE"
# echo "On-disk limit: $HISTFILESIZE"
alias sf="searchDirRecursivelyForFilesByText"
alias sdfs="searchDirRecursivelyForFilesByText"
searchDirRecursivelyForFilesByText() {
  local input="$1"
  shift
  # default directory is "."
  set -- "${@:-.}"

  local expr=()
  local first=1

  for p in ${input//|/ }; do
    [ -z "$p" ] && continue

    if [ $first -eq 1 ]; then
      expr+=( -iname "*$p*" )
      first=0
    else
      expr+=( -o -iname "*$p*" )
    fi
  done

  find "$@" "(" "${expr[@]}" ")"
}

javahome() {
    unset JAVA_HOME
    export JAVA_HOME=$(/usr/libexec/java_home -v "$1");
    java -version
}

copydir() {
  pwd | tr -d "\r\n" | pbcopy
}

cw() {
    watchman watch-del "$PWD" ; watchman watch-project "$PWD"
}

asrun() {
    if [ -z "$1" ]; then
        echo "Usage: asrun <directory>"
        return 1
    fi
    dir="$1"
    shift
    as -o "${dir}/app.o" "${dir}/app.s" &&
    ld -o "${dir}/app" "${dir}/app.o" -e _start -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem &&
    ./"${dir}/app" "$@"
}

ls-size() {
    local target="."
    local extension="*.svg"

    while getopts "d:t:" opt; do
        case $opt in
            d) target="$OPTARG" ;;
            t) extension="*.$OPTARG" ;;
        esac
    done

    # %f = filename, %s = size in bytes.
    # Use 'human-readable' equivalent by dividing by 1024 or using du
    find "$target" -type f -name "$extension" ! -name '.*' -printf "%p %s\n" | \
    awk '{
        size=$NF/1024;
        printf "%-50s %8.2f KB\n", $1, size
    }'
}

sanitize-project() {
  echo "Applying .noindex to dependency directories..."
  find . -maxdepth 3 -type d \( -name "node_modules" -o -name ".venv" -o -name "venv" -o -name "target" \) -exec touch {}/.noindex \;
  echo "Done. Spotlight will now ignore these folders."
}

set-finder-ext-icons() {
    EDITOR_ID="dev.zed.Zed"
    extensions=(
      "js" "ts" "jsx" "tsx" "rs" "md" "json" "yaml" "yml" "toml"
      "css" "html" "sh" "zsh" "py" "go" "c" "cpp" "h" "hpp" "txt"
    )
    for ext in "${extensions[@]}"; do
      echo "Setting $ext to $EDITOR_ID..."
      duti -s $EDITOR_ID "$ext" all
    done
    items=(
      "gitignore" "prettierrc" "eslintrc" "editorconfig" "env" "dockerignore"
    )

    for item in "${items[@]}"; do
        echo "Setting $item to $EDITOR_ID..."
      duti -s "$EDITOR_ID" "$item" all
    done
}

# This cleans your entire home directory of "noisy" folders
clean-spotlight() {
  # find . -maxdepth 1 -type d ! -name "." ! -name "Documents" ! -name "KB" ! -name "Library" -exec touch {}/.noindex \;
  echo "Applying .noindex to all non-essential folders..."
  # Target common junk folders
  find ~/Downloads ~/Movies ~/Pictures ~/Music ~/Public -maxdepth 1 -type d -exec touch {}/.noindex \;
  # Target your project build folders
  find ~/Documents ~/KB -maxdepth 4 -type d \( -name "node_modules" -o -name ".venv" -o -name "venv" -o -name "target" \) -exec touch {}/.noindex \;
  echo "Done. Spotlight will only focus on your active work."
}

# Build a C project through various stages.
build() {
    local name="${1%.c}"
    shift

    local src="target/$name.c"
    local out="tmp/$name"

    mkdir -p tmp

    gcc -g -O0 -S "$src" -o "$out.s" &&
    gcc -g -O0 -c "$src" -o "$out.o" &&
    gcc -g -O0 "$@" "$src" -o "$out" || return

    echo
    echo "=== Running $name ==="

    "$out"
    local exit_code=$?

    echo

    case $exit_code in
        0)
            echo "Success"
            ;;
        1)
            echo "General error"
            ;;
        134)
            echo "Abort (SIGABRT) - usually allocator/runtime detected a problem"
            ;;
        136)
            echo "Floating point exception (SIGFPE)"
            ;;
        137)
            echo "Killed (SIGKILL)"
            ;;
        138)
            echo "Bus error (SIGBUS) - invalid memory alignment/access"
            ;;
        139)
            echo "Segmentation fault (SIGSEGV) - invalid memory access"
            ;;
        141)
            echo "Broken pipe (SIGPIPE)"
            ;;
        143)
            echo "Terminated (SIGTERM)"
            ;;
        *)
            echo "Unknown exit status: $exit_code"
            ;;
    esac

    echo "Exit status: $exit_code"
}
build_sanitize() {
    local name="${1%.c}"
    shift

    local src="target/$name.c"
    local out="tmp/$name"

    mkdir -p tmp

    gcc \
        -g \
        -O0 \
        -fsanitize=address,undefined \
        "$@" \
        "$src" \
        -o "$out" || return

    echo
    echo "=== Running $name ==="

    "$out"
}
_build_examples() {
    local -a files
    local file

    files=()

    for file in target/*.c; do
        files+=("${file:t:r}")
    done

    _describe 'examples' files
}

compdef _build_examples build
compdef _build_examples build_sanitize

build_pthread() {
    local name="${1%.c}"
    local src="target/$name.c"
    local out="tmp/$name"

    mkdir -p tmp

    gcc -S "$src" -o "$out.s" &&
    gcc -c "$src" -o "$out.o" &&
    gcc -pthread "$src" -o "$out" &&
    "$out"
}
compdef _build_examples build
compdef _build_examples build_rust
compdef _build_examples build_sanitize
compdef _build_examples build_pthread

hls_info() {
    local playlist="$1"
    echo "=== Playlist ==="
    echo "$playlist"
    echo
    ffprobe \
        -hide_banner \
        "$playlist"
}
hls_remux() {
    local playlist="$1"
    local output="${2:-output.mp4}"

    echo "=== Remuxing ==="
    echo "Input:  $playlist"
    echo "Output: $output"
    echo

    ffmpeg \
        -hide_banner \
        -i "$playlist" \
        -map 0:v:0 \
        -map 0:a:0? \
        -c copy \
        -movflags +faststart \
        "$output"
}
hls_remux_background() {
    local playlist="$1"
    local output="${2:-output.mp4}"
    local log="${3:-ffmpeg.log}"

    nohup ffmpeg \
        -hide_banner \
        -allowed_extensions ALL \
        -protocol_whitelist 'file,http,https,tcp,tls,crypto,data' \
        -i "$playlist" \
        -map '0:v:0' \
        -map '0:a:0?' \
        -c copy \
        -movflags +faststart \
        "$output" \
        >"$log" 2>&1 </dev/null &

    local pid=$!

    echo "Started ffmpeg: $pid"
    echo "Output: $output"
    echo "Log: $log"
}

hls_watch() {
    local log="${1:-ffmpeg.log}"
    tail -f "$log"
}

mp4_to_avi() {
  ffmpeg -i "$1" \
    -c:v libsvtav1 \
    -crf 35 \
    -preset 6 \
    -c:a copy \
    -progress pipe:1 \
    "${2:-output-1080p-av1.mkv}"
}

setAssociation() {
  duti -s com.colliderli.iina .mkv all
  duti -s com.colliderli.iina .mp4 all
  duti -s com.colliderli.iina .avi all
  duti -x mkv
  duti -x avi
}

killit() {
	local port="$1"
	local pids

	if [[ -z "$port" ]]; then
		echo "usage: end <port>"
		return 1
	fi

	pids=$(lsof -ti :"$port")

	if [[ -z "$pids" ]]; then
		echo "nothing listening on port $port"
		return 0
	fi

	echo "killing port $port: $pids"
	kill -9 $pids
}


run_gesture() {
  APP="$HOME/Library/Developer/Xcode/DerivedData/Jitouch-awdrxkydbewiitbfccdshqkylzkq/Build/Products/Debug/Jitouch.app/Contents/MacOS/Jitouch"
  echo "$APP"
  "$APP"

  # Find it
  # pgrep -fl Jitouch
}




# Print  disk utilizations
#
# du -sh * | sort -hr
# ls -lh
# du -sh .[!.]* * 2>/dev/null | sort -hr
