echo "04. 🎨 std lib loading..."
# ============================================================
# Bash Function Documentation
# ============================================================
foo-args() {
    local first_arg="$1"
    local total_args="$#"
    local -a all_args=("$@")

    echo_kv "Total Args" "$total_args"
    echo_kv "First Arg" "$first_arg"

    echo_muted "Arguments:"

    local -a TABLE_WIDTHS=(8 40)

    table_header "#" "Value"
    table_separator

    local i=1
    for item in "${all_args[@]}"; do
        table_row "$i" "$item"
        ((i++))
    done

    table_end
}
foo-conditionals() {
  # "use argument 1, unless it is unset or empty; otherwise use 10."
	local value="${1:-10}"

	# if / elif / else
	if [ "$value" -gt 10 ]; then
		echo "greater than 10"
	elif [ "$value" -eq 10 ]; then
		echo "equal to 10"
	else
		echo "less than 10"
	fi

	# String comparison
	if [ "$value" = "10" ]; then
		echo "string is exactly 10"
	fi

	# Negation
	if [ "$value" != "0" ]; then
		echo "value is not zero"
	fi

	# File checks
	if [ -f "$HOME/.zshrc" ]; then
		echo "file exists"
	fi

	if [ -d "$HOME" ]; then
		echo "directory exists"
	fi

	# Command success
	if command -v git >/dev/null 2>&1; then
		echo "git is installed"
	fi

	# Logical AND / OR
	if [ "$value" -gt 0 ] && [ "$value" -lt 100 ]; then
		echo "between 1 and 99"
	fi

	if [ "$value" -eq 0 ] || [ "$value" -lt 0 ]; then
		echo "zero or negative"
	fi
}
foo-conditionals-zsh() {
	local value="${1:-10}"

	# if / elif / else
	if [[ "$value" -gt 10 ]]; then
		echo "greater than 10"
	elif [[ "$value" -eq 10 ]]; then
		echo "equal to 10"
	else
		echo "less than 10"
	fi

	# String comparison
	if [[ "$value" == "10" ]]; then
		echo "string is exactly 10"
	fi

	# Negation
	if [[ "$value" != "0" ]]; then
		echo "value is not zero"
	fi

	# File checks
	if [[ -f "$HOME/.zshrc" ]]; then
		echo "Zsh config file exists"
	fi

	if [[ -d "$HOME" ]]; then
		echo "directory exists"
	fi

	# Command success
	if command -v git >/dev/null 2>&1; then
		echo "git is installed"
	fi

	# Logical AND / OR
	if [[ "$value" -gt 0 && "$value" -lt 100 ]]; then
		echo "between 1 and 99"
	fi

	if [[ "$value" -eq 0 || "$value" -lt 0 ]]; then
		echo "zero or negative"
	fi
}
foo-repeat() {
    if [ -z "$1" ]; then
        echo_error "Usage: foo-repeat <number>"
        return 1
    fi

    local n="$1"

    echo_kv "Iterations" "$n"
    echo_muted "Running:"

    local -a TABLE_WIDTHS=(10 20)

    table_header "#" "Status"
    table_separator

    for ((i=1; i<=n; i++)); do
        table_row "$i" "Iteration $i of $n"
    done

    table_end
}
foo-pipe() {
    if [ -z "$1" ]; then
        echo_error "Usage: foo-pipe <string_with_pipes>"
        return 1
    fi

    local input="$1"
    local -a items=("${(@s/|/)input}")

    echo_kv "Input" "$input"
    echo_kv "Items" "${#items[@]}"

    echo_muted "Processed pipe-delimited list:"

    local -a TABLE_WIDTHS=(8 40)

    table_header "#" "Value"
    table_separator

    local i=1
    for item in "${items[@]}"; do
        table_row "$i" "$item"
        ((i++))
    done

    table_end
}


foo-loop() {
  names=(
	"use-after-free"
	"double-free"
	"dangling-pointer"
	"data-race"
	"null-pointer"
	"buffer-overflow"
	"uninitialized-memory"
	"iterator-invalidation"
	"memory-leak"
	"resource-lifetime"
  )

  for i in {1..10}; do
	printf -v n "%02d" "$i"
	touch "target/${n}-${names[$i]}.c"
  done
}
# ============================================================
# Color Formatting
# ============================================================
echo_info() {
    echo "${INFO}$*${RESET}"
}
echo_success() {
    echo "${SUCCESS}$*${RESET}"
}
echo_warning() {
    echo "${WARNING}$*${RESET}"
}
echo_error() {
    echo "${ERROR}$*${RESET}"
}
echo_muted() {
    echo "${MUTED}$*${RESET}"
}
echo_title() {
  echo "${TABLE_SECTION_TITLE_COLOR}$*${RESET}"
}
echo_key() {
    echo "${KEY}$*${RESET}"
}
echo_value() {
    echo "${VALUE}$*${RESET}"
}
echo_kv() {
    echo "${KEY}$1${RESET}: ${VALUE}$2${RESET}"
}
echo_metric() {
    local label="$1"
    local value="$2"
    local width="${3:-35}"
    local dots=$((width - ${#label} - 1))
    printf "${KEY}%-${#label}s${MUTED} %*s${RESET} ${VALUE}%s${RESET}\n" \
        "$label" \
        "$dots" "" \
        "$value" | sed 's/ \+/./g'
}
# ============================================================
# Table Formatting
# ============================================================
table_section() {
    table_separator
    echo_title "$1"
}
table_cell() {
	local value="$1"
	local width="$2"
	local align="$3"
	local color="$4"
	case "$align" in
		left)
			printf "%s%-*s%s" "$color" "$width" "$value" "$RESET"
			;;
		right)
			printf "%s%*s%s" "$color" "$width" "$value" "$RESET"
			;;
	esac
}
table_header() {
    local -a columns=("$@")

    table_cell "${columns[1]}" "${TABLE_WIDTHS[1]}" left "$TABLE_SUMMARY_COLOR"

    for i in {2..$#columns}; do
        table_cell "${columns[$i]}" "${TABLE_WIDTHS[$i]}" right "$TABLE_SUMMARY_COLOR"
    done

    printf "\n"
}
table_row() {
	local -a columns=("$@")

	table_cell \
		"${columns[1]}" \
		"${TABLE_WIDTHS[1]}" \
		left \
		"$TABLE_KEY_COLOR"

	for ((i = 2; i <= $#columns; i++)); do
		table_cell \
			"${columns[$i]}" \
			"${TABLE_WIDTHS[$i]}" \
			right \
			"$TABLE_VALUE_COLOR"
	done

	printf "\n"
}
table_separator() {
    local total=0

    for width in "${TABLE_WIDTHS[@]}"; do
        (( total += width ))
    done

    printf '%s%*s%s\n' \
        "$GRAY_01" \
        "$total" '' \
        "$RESET" |
        tr ' ' '-'
}
table_summary() {
    local label="$1"
    local value="$2"

    table_kv_line \
        "$label" \
        "$value" \
        "$(table_width)"
}
table_width() {
    local total=0

    for width in "${TABLE_WIDTHS[@]}"; do
        (( total += width ))
    done

    echo "$total"
}
table_end() {
    printf '\n'
}
table_kv() {
    table_kv_line "$1" "$2" "$(table_width)"
}
table_kv_line() {
    local key="$1"
    local value="$2"
    local width="${3:-${TABLE_WIDTHS[1]}}"
    # local filler="${4:-.}"
    local filler="${4:- }"
    local padding=$((width - ${#key} - ${#value} - 1))
    (( padding < 1 )) && padding=1
    printf "%s%s%s" \
        "$TABLE_KEY_COLOR" \
        "$key" \
        "$RESET"
    printf "%s%*s%s" \
        "$TABLE_SEPARATOR_COLOR" \
        "$padding" '' \
        "$RESET" |
        tr ' ' "$filler"
    printf " %s%s%s\n" \
        "$TABLE_VALUE_COLOR" \
        "$value" \
        "$RESET"
}
# table_metric() {
#     local label="$1"
#     local value="$2"

#     local total_width=0

#     for width in "${TABLE_WIDTHS[@]}"; do
#         (( total_width += width ))
#     done

#     local dots=$((total_width - ${#label} - ${#value}))

#     (( dots < 1 )) && dots=1

#     printf "%s%s%s" \
#         "$TABLE_KEY_COLOR" \
#         "$label" \
#         "$RESET"

#     printf "%s%*s%s" \
#         "$TABLE_SEPARATOR_COLOR" \
#         "$dots" '' \
#         "$RESET" |
#         tr ' ' '.'

#     printf " %s%s%s\n" \
#         "$TABLE_SUMMARY_COLOR" \
#         "$value" \
#         "$RESET"
# }
foo-table() {
    local -a TABLE_WIDTHS=(24 15 30)

    table_section "Configuration"

    table_header "Name" "Type" "Value"
    table_separator

    table_row "foo"           "string"  "hello"
    table_row "bar"           "number"  "123"
    table_row "enabled"       "boolean" "true"
    table_row "something-long" "path"    "~/.config/zsh"

    table_end
}
foo-table2() {
    local -a TABLE_WIDTHS=(24 15 30)

    table_section "Files"

    table_header "Name" "Type" "Value"
    table_separator

    table_row "config"      "file" "3010"
    table_row "markdown"    "file" "58"
    table_row "directories" "count" "2"

    table_separator

    table_row "Total" "" "3070"
    table_summary "Match Rate" "1.93%" 3

    table_end
}
foo-manual-parser() {
    local directories="."
    local type=".svg"

    local -a EXCLUDED_DIRS=(
        node_modules
        .git
        .next
        .nuxt
        dist
        .venv
        build
        target
    )

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -d)
                directories="$2"
                shift 2
                ;;
            -t)
                type="$2"
                shift 2
                ;;
            *)
                echo_error "Unknown flag: $1"
                return 1
                ;;
        esac
    done

    local -a targets=("${(@s/|/)directories}")
    [[ "$type" != .* ]] && type=".$type"
    # ─────────────────────────────────────────
    # TABLE CONFIG
    # ─────────────────────────────────────────

    local -a TABLE_WIDTHS=(30 12 12 10)
    # ─────────────────────────────────────────
    # INPUT / CONFIG
    # ─────────────────────────────────────────
    table_section "Params:"
    table_kv "Directories" "${#targets[@]}"
    table_kv "Extension" "$type"

    # ─────────────────────────────────────────
    # DATA
    # ─────────────────────────────────────────

    table_section "Results:"
    table_header "Directory" "Matches" "Total" "Rate"
    local directories_searched=0
    local total_files=0
    local total_matches=0

    for dir in "${targets[@]}"; do
        if [[ ! -d "$dir" ]]; then
            echo_warning "Directory not found: $dir"
            continue
        fi

        ((directories_searched++))

        local find_prune=()

        for excluded in "${EXCLUDED_DIRS[@]}"; do
            find_prune+=(-name "$excluded" -prune -o)
        done

        local +t file_count
        local +t match_count

        file_count=$(
            find "$dir" \
                "${find_prune[@]}" \
                -type f \
                -print |
            wc -l |
            tr -d ' '
        )

        match_count=$(
            find "$dir" \
                "${find_prune[@]}" \
                -type f \
                -name "*$type" \
                -print |
            wc -l |
            tr -d ' '
        )

        local percentage="0.00"

        if (( file_count > 0 )); then
            percentage=$(awk \
                "BEGIN { printf \"%.2f\", ($match_count / $file_count) * 100 }")
        fi

        total_files=$((total_files + file_count))
        total_matches=$((total_matches + match_count))

        table_row "$dir" "$match_count" "$file_count" "$percentage%"
    done
    # ─────────────────────────────────────────
    # SUMMARY
    # ─────────────────────────────────────────
    table_section "Summary:"

    local total_percentage="0.00"

    if (( total_files > 0 )); then
        total_percentage=$(awk \
            "BEGIN { printf \"%.2f\", ($total_matches / $total_files) * 100 }")
    fi

    table_row \
        "Total" \
        "$total_matches" \
        "$total_files" \
        "$total_percentage%"

    table_end
}
_foo_manual_parser_directories() {
    local cur="$PREFIX"

    if [[ "$cur" != *"|"* ]]; then
        _directories
        return
    fi

    local completed="${cur%|*}|"
    local partial="${cur##*|}"

    local base="${partial:h}"
    local name="${partial:t}"

    [[ "$base" == "." ]] && base="."

    local -a matches

    if [[ "$partial" == */ ]]; then
        matches=("$partial"*(N/))
    else
        matches=("${base:-.}/${name}"*(N/))
    fi

    # -----------------------------------------
    # Build candidate + display arrays
    # -----------------------------------------

    local -a candidates
    local -a displays

    local match
    local candidate
    local display

    for match in "${matches[@]}"; do
        match="${match#./}"

        candidate="${completed}${match}"
        display="${match:t}"

        candidates+=("$candidate")
        displays+=("$display")
    done

    # -----------------------------------------
    # Add them together
    # -----------------------------------------

    if (( ${#candidates[@]} )); then
        compadd \
            -Q \
            -S '' \
            -d displays \
            -- "${candidates[@]}"
    fi
}
_foo_manual_parser() {
    _arguments \
        '-d+[Directories to search]:directory:_foo_manual_parser_directories' \
        '-t+[File extension]:extension:(.md .svg .json .ts .tsx .rs .py)'
}
compdef _foo_manual_parser foo-manual-parser

# foo-media-parser -s bitrate -o desc -l 10
foo-media-parser() {
    local directories="."
    local extensions=".mp4|.avi|.mkv"
    local sort_field="file"
    local sort_order="asc"
    local limit=10

    local -a EXCLUDED_DIRS=(
        node_modules
        .git
        .next
        .nuxt
        dist
        .venv
        build
        target
    )

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -d)
                directories="$2"
                shift 2
                ;;

            -t)
                extensions="$2"
                shift 2
                ;;

            -s|--sort)
                sort_field="$2"
                shift 2
                ;;

            -o|--order)
                sort_order="${2:l}"

                if [[ "$sort_order" != "asc" && "$sort_order" != "desc" ]]; then
                    echo_error "Sort order must be 'asc' or 'desc'"
                    return 1
                fi

                shift 2
                ;;

            -l|--limit)
                limit="$2"

                if ! [[ "$limit" =~ '^[0-9]+$' ]]; then
                    echo_error "Limit must be a number"
                    return 1
                fi

                shift 2
                ;;

            *)
                echo_error "Unknown flag: $1"
                return 1
                ;;
        esac
    done

    local -a targets=("${(@s/|/)directories}")
    local -a types=("${(@s/|/)extensions}")

    # ─────────────────────────────────────────
    # SORT CONFIG
    # ─────────────────────────────────────────

    local sort_column
    local sort_numeric=0

    case "$sort_field" in
        file)
            sort_column=1
            ;;

        resolution)
            sort_column=2
            ;;

        aspect)
            sort_column=3
            ;;

        fps)
            sort_column=4
            sort_numeric=1
            ;;

        codec)
            sort_column=5
            ;;

        bitrate)
            sort_column=6
            sort_numeric=1
            ;;

        duration)
            sort_column=7
            sort_numeric=1
            ;;

        size)
            sort_column=8
            sort_numeric=1
            ;;

        *)
            echo_error "Unknown sort field: $sort_field"
            echo "Valid fields: file, resolution, aspect, fps, codec, bitrate, duration, size"
            return 1
            ;;
    esac

    # ─────────────────────────────────────────
    # TABLE CONFIG
    # ─────────────────────────────────────────

    # local -a TABLE_WIDTHS=(35 12 12 10 10 14 12 12)
    local -a TABLE_WIDTHS=(30 12 8 8 10 14 12 10)

    # ─────────────────────────────────────────
    # INPUT / CONFIG
    # ─────────────────────────────────────────

    table_section "Params:"
    table_kv "Directories" "${#targets[@]}"
    table_kv "Extensions" "$extensions"
    table_kv "Sort" "$sort_field ($sort_order)"
    table_kv "Limit" "${limit:-none}"

    # ─────────────────────────────────────────
    # DATA
    # ─────────────────────────────────────────

    local -a rows=()
    local file

    for dir in "${targets[@]}"; do
        if [[ ! -d "$dir" ]]; then
          echo_warning "Directory not found: $dir"
          continue
        fi

        local find_prune=()

        for excluded in "${EXCLUDED_DIRS[@]}"; do
          find_prune+=(-name "$excluded" -prune -o)
        done

        while IFS= read -r file; do
            local ext="${file##*.}"
            ext=".${ext:l}"

            local valid=0

            for type in "${types[@]}"; do
              [[ "$ext" == "$type" ]] && valid=1
            done

            (( valid )) || continue

            # ─────────────────────────────────
            # FFPROBE
            # ─────────────────────────────────

            local probe

            probe=$(ffprobe \
              -v error \
              -select_streams v:0 \
              -show_entries \
                  stream=width,height,display_aspect_ratio,r_frame_rate,codec_name,bit_rate,duration \
              -of csv=p=0 \
              "$file" 2>/dev/null
            )

            if [[ -z "$probe" ]]; then
              echo_warning "Unable to read: $file"
              continue
            fi

            local codec width height aspect fps bitrate duration

            IFS=',' read -r \
              codec \
              width \
              height \
              aspect \
              fps \
              bitrate \
              duration <<< "$probe"

            # ─────────────────────────────────
            # RAW SORT VALUES
            # ─────────────────────────────────

            local fps_sort=0
            local bitrate_sort=0
            local duration_sort=0
            local size_sort=0

            if [[ -n "$fps" ]]; then
              fps_sort=$(awk -v fps="$fps" '
                BEGIN {
                  split(fps, a, "/")
                  if (a[2] > 0)
                    printf "%.6f", a[1] / a[2]
                  else
                    print 0
                }
              ')
            fi

            [[ -n "$bitrate" ]] && bitrate_sort="$bitrate"
            [[ -n "$duration" ]] && duration_sort="$duration"

            # Bytes, for accurate size sorting
            size_sort=$(stat -f "%z" "$file" 2>/dev/null || echo 0)

            # ─────────────────────────────────
            # DISPLAY VALUES
            # ─────────────────────────────────

            local resolution="${width}x${height}"

            local fps_display
            fps_display=$(awk -v fps="$fps" '
              BEGIN {
                split(fps, a, "/")
                if (a[2] > 0)
                  printf "%.2f", a[1] / a[2]
                else
                  print fps
              }
            ')

            local bitrate_display="N/A"

            if [[ "$bitrate" != "" && "$bitrate" != "0" ]]; then
                bitrate_display=$(awk -v b="$bitrate" '
                    BEGIN {
                        printf "%.2f Mbps", b / 1000000
                    }
                ')
            fi

            local duration_display="N/A"

            if [[ -n "$duration" ]]; then
              duration_display=$(awk -v d="$duration" '
                BEGIN {
                    h = int(d / 3600)
                    m = int((d % 3600) / 60)
                    s = int(d % 60)
                    printf "%02d:%02d:%02d", h, m, s
                }
              ')
            fi

            local size
            size=$(du -h "$file" | cut -f1)
            local filename="${file:t}"
            rows+=(
              "$filename|$resolution|$aspect|$fps_display|$codec|$bitrate_display|$duration_display|$size|$fps_sort|$bitrate_sort|$duration_sort|$size_sort"
            )

        done < <(
          find "$dir" \
            "${find_prune[@]}" \
            -type f \
            \( \
                -iname "*.mp4" \
                -o -iname "*.avi" \
                -o -iname "*.mkv" \
            \) \
            -print
        )
    done

    # ─────────────────────────────────────────
    # SORT
    # ─────────────────────────────────────────

    local sort_raw_column

    case "$sort_field" in
      file)       sort_raw_column=1 ;;
      resolution) sort_raw_column=2 ;;
      aspect)     sort_raw_column=3 ;;
      fps)        sort_raw_column=9 ;;
      codec)      sort_raw_column=5 ;;
      bitrate)    sort_raw_column=10 ;;
      duration)   sort_raw_column=11 ;;
      size)       sort_raw_column=12 ;;
    esac

    local sort_args=(
        -t $'\t'
        "-k${sort_raw_column},${sort_raw_column}"
    )

    if (( sort_numeric )); then
        sort_args+=(-n)
    fi

    if [[ "$sort_order" == "desc" ]]; then
        sort_args+=(-r)
    fi

    rows=("${(@f)$(printf '%s\n' "${rows[@]}" | sort "${sort_args[@]}")}")

    # ─────────────────────────────────────────
    # LIMIT
    # ─────────────────────────────────────────

    if (( limit > 0 )); then
        rows=("${(@f)$(printf '%s\n' "${rows[@]}" | head -n "$limit")}")
    fi

    # ─────────────────────────────────────────
    # OUTPUT
    # ─────────────────────────────────────────
    table_section "Results:"
    table_header \
     	"File" \
     	"Resolution" \
     	"Aspect" \
     	"FPS" \
     	"Codec" \
     	"Bitrate" \
     	"Duration" \
     	"Size"
    local row
    for row in "${rows[@]}"; do
      local -a fields
      IFS='|' read -r -A fields <<< "$row"
      table_row "${(@)fields[1,8]}"
    done
    table_end
}

# Troubleshooting FPath
## Prints the plugins
# env -u FPATH zsh
## Should have 1's next to every file
# print -l $fpath | sort | uniq -c | sort -nr
