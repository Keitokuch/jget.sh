get() {
    [[ -n $JGET_SRC ]] || { git clone https://github.com/Keitokuch/jget.sh.git ; JGET_SRC=jget ; }
    [[ -f $BIN/jget ]] && rm $BIN/jget
    [[ -d $BIN/jget ]] && rm -rf $BIN/jget
    cp -f $JGET_SRC/jget.sh $BIN/jget
    cp -rf $JGET_SRC/jget_lib $BIN
}

exists() {
    has_command jget
}
