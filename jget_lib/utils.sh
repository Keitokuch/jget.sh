declare -ga CLEANUP=("put_msg")
declare -ga MSG=()

declare -i ERR_NETWORK=102
declare -i ERR_SUPPORT=103
declare -i ERR_DEPEND=104

terminate() {
    MSG+=("Terminated. Cleaning up...")
    clean_up
    exit 1
}

clean_up() {
    for task in "${CLEANUP[@]}"; do
        $task
    done
}

# Print logged messages
put_msg() {
    for msg in "${MSG[@]}"; do
        echo $msg
    done
}

parse_options() {
    unset _forced _silent version prefix
    OPTIND=1
    while getopts ":fsv:p:" opt ; do
        case $opt in
            f)
                _forced=1
                ;;
            s)
                _silent=1
                ;;
            v)
                version=$OPTARG
                ;; 
            p)
                prefix=$OPTARG
        esac 
    done
    _forced=${_forced:-$FORCED}
    _silent=${_silent:-$SILENT}
    prefix=${prefix:-$PREFIX}
}

global_options() {
    unset FORCED SILENT PREFIX
    OPTIND=1
    while getopts ":fsp:" opt ; do
        case $opt in 
            f)
                FORCED=1
                ;;
            s)
                SILENT=1
                ;;
            p)
                PREFIX=$OPTARG
                ;;
        esac
    done
    PREFIX=${PREFIX:-$JGET}
}

parse_ostype() {
    if [[ $(uname) == "Linux" ]]; then
        ostype=linux
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            os=$ID
            osversion=$VERSION_ID
        else
            MSG+=("Failed: linux distro not recognized.")
            return 1
        fi
    elif [[ $(uname) == "Darwin" ]]; then
        os=macos
        ostype=darwin
    else
        MSG+=("Failed: OS type $OSTYPE not supported.")
        return 1
    fi
    arch=$(uname -m)
    [[ $arch == "x86_64"* ]] && arch="x86_64"
}

require() {
    jget_install -s $@ 
}

is_macos() {
    [[ $ostype == "darwin" ]]
}

is_linux() {
    [[ $ostype == "linux" ]]
}

is_arm64() {
    [[ $(uname -m) == arm64 ]]
}

is_x64() {
    [[ $(uname -m) == x86_64* ]]
}

profile_add() {
    check_append "$1" $JGET_PROFILE
}

profile_remove() {
    remove_line "$1" $JGET_PROFILE
}

add_path() {
    JGET_PATH+=($1)
}

remove_path() {
    JGET_RM_PATH+=($1)
}


check_append() {
    grep -qxsF -- "$1" "$2" || echo "$1" >> "$2"
}

remove_line() {
    grep -v "$1" "$2" > temp && mv temp "$2"
}

has_executable() {
    [[ -x $(command -v $1) ]]
}

has_command() {
    [[ -x $(command -v $1) ]]
}

has_lib() {
    haslib=$(whereis "$1" | wc -w)
    if [[ $haslib -gt 1 ]]; then 
        return 0
    else
        if [[ $(whereis -B "$LIB" -f "$1" | wc -w) -gt 1 ]]; then
            return 0
        else
            return 1
        fi
    fi
}

has_func() {
    declare -f $1 > /dev/null
    return $?
}

add_clean_up() {
    CLEANUP=("$1" "${CLEANUP[@]}")
}
