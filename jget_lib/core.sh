declare -ga JGET_PATH=()
declare -ga JGET_RM_PATH=()

BIN=$JGET/bin
LIB=$JGET/lib
MAN=$JGET/share/man
mkdir -p $BIN
mkdir -p $LIB
mkdir -p $MAN

BUILD=$JGET/build
mkdir -p $BUILD

jget_path=$JGET/.paths
jget_libpath=$JGET/.libpaths

FORMULA=$SRC/formula

add_path "$BIN"
add_clean_up "jget_setup"
add_clean_up "jget_clean"

jget_clean() {
    rm -rf $BUILD
}

jget_setup() {
    for path in "${JGET_PATH[@]}"; do 
        check_append $path $jget_path
    done

    for path in "${JGET_RM_PATH[@]}"; do
        remove_line $path $jget_path
        profile_remove "export PATH=$path:\$PATH" 
    done

    while read path
    do
        profile_add "export PATH=$path:\$PATH" 
    done <"$jget_path"

    profile_add "export LD_LIBRARY_PATH=$LIB:\$LD_LIBRARY_PATH" 
    profile_add "export MANPATH=$MAN:\$MANPATH" 
}


load_source() {
    . $SRC/generic.sh
    if [[ $ostype == "linux" ]]; then 
        nr_worker=$(nproc)
        . $SRC/linux.sh
        case $os in
            centos|rhel)
                . $SRC/centos.sh
                ;;
            ubuntu)
                . $SRC/ubuntu.sh
                ;;
            debian)
                . $SRC/debian.sh
                ;;
            *)
                # MSG+=("Failed: linux distro $os not supported.")
                # return 1
                ;;
        esac
    elif [[ $ostype == "darwin" ]]; then
        nr_worker=$(sysctl -n hw.ncpu)
        . $SRC/macos.sh        
    fi
}

jget_install() {
    global_options $@
    shift "$(( OPTIND - 1 ))"

    while (( ${#@} > 0 ))
    do
        jget_install_one $@
        shift "$OPTIND"
    done
}

jget_remove() {
    global_options $@
    shift "$(( OPTIND - 1 ))"

    while (( ${#@} > 0 ))
    do
        jget_remove_one $@
        shift "$OPTIND"
    done
}

jget_install_one() {
    local dir=$(pwd)
    local target=$1 && shift
    parse_options $@ 
    local forced=$_forced
    local silent=$_silent
    local optind=$OPTIND
    unset -f get exists
    local formula="$FORMULA/$target.sh"
    source $formula 2>/tmp/jerr || { MSG+=("Error in loading formula for $target: $(cat /tmp/jerr)"); return 1; }
    [[ -n $(command -v get) ]] || { MSG+=("[ ERROR ] Formula for $target is broken: get() not found"); return 1; }
    [[ -n $(command -v exists) ]] || { MSG+=("[ ERROR ] Formula for $target is broken: exists() not found"); return 1; }

    if ! exists || [[ $forced ]] || [[ $version ]] ; then
        cd $BUILD
        if get; then
            [[ $silent ]] || MSG+=(">>> installed $target <<<")
        else
            MSG+=("[ ERROR ] Failed to install $target")
        fi
        cd $dir
    else
       [[ $silent ]] || MSG+=("=== $target already installed ===")
    fi
    # global variable position can be changed by nested calls
    OPTIND=optind
}

jget_remove_one() {
    local dir=$(pwd)
    local target=$1 && shift
    parse_options $@ 
    local silent=$_silent
    local optind=$OPTIND
    local func=_rm_$target
    unset -f remove exists
    local formula="$FORMULA/$target.sh"
    source $formula 2>/tmp/jerr || { MSG+=("Error in loading formula for $target: $(cat /tmp/jerr)"); return 1; }
    [[ -n $(command -v exists) ]] || { MSG+=("[ ERROR ] Formula for $target is broken: exists() not found"); return 1; }
    [[ -n $(command -v remove) ]] || { MSG+=("[ ERROR ] Can not remove $target: remove() not found"); return 1; }
    if exists; then
        cd $BUILD
        if remove; then
            [[ $silent ]] || MSG+=(">>> removed $target <<<")
        else
            MSG+=("[ ERROR ] Failed to removed $target")
        fi
        cd $dir
    else
       [[ $silent ]] || MSG+=("=== $target not found ===")
    fi
    # global variable position can be changed by nested calls
    OPTIND=optind
    cd $dir
}
