get() {
    [[ -n $JGET_SRC ]] || { JGET_SRC=jget_src; git clone https://github.com/Keitokuch/jget.sh.git $JGET_SRC; }
    [[ -f $BIN/jget ]] && rm $BIN/jget
    [[ -d $BIN/jget ]] && rm -rf $BIN/jget
    cp -f $JGET_SRC/jget.sh $BIN/jget
    cp -rf $JGET_SRC/jget_lib $BIN
}

exists() {
    has_command jget
}
