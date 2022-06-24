#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SRC=$DIR/jget_lib

JGET=$HOME/.jget
mkdir -p $JGET

. $SRC/utils.sh
# . $SRC/config

SH_PROFILE=$HOME/.profile
BASH_PROFILE=$([[ -f $HOME/.bash_profile ]] && echo "$HOME/.bash_profile" || echo "$HOME/.profile")
ZSH_PROFILE=$HOME/.zshenv
SYS_RC=($BASH_PROFILE $ZSH_PROFILE $SH_PROFILE)

JGET_PROFILE=$HOME/.jget_profile

jget_init() {
    touch "$JGET_PROFILE"
    for profile in "${SYS_RC[@]}"; do 
        check_append "source "$JGET_PROFILE"" $profile
    done
    parse_ostype
    load_source 
    # TODO: jget config file

    trap terminate SIGINT
    trap terminate SIGTSTP
}

jget() {
    source $SRC/core.sh
    jget_init

    opt=$1
    shift
    case $opt in
        install)
            jget_install $@
            ;;
        remove)
            jget_remove $@
            ;;
        test)
            do_test $@
            ;;
        func)
            $@
            echo $?
            ;;
        update)
            jget_install -f jget
            ;;
        *)
            usage
            ;;
    esac
    clean_up
}

usage() {
    echo "Usage: $0 install [pkg_name] | remove [pkg_name] | update"
}

main() {
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] || jget $@
    # if [[ $# -gt 0 ]]; then
    #     jget $@
    # fi
}


main $@
