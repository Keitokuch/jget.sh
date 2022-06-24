
OMZ=$HOME/.oh-my-zsh

exists() {
    [[ -f "$OMZ/oh-my-zsh.sh" ]]
}

get() {
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -) --unattended" 
}

remove() {
    rm $OMZ/oh-my-zsh.sh
}
