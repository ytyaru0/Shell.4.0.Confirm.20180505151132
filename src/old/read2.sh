Confirm(){
    _IsInvalidConfirmType "$1"
    code=$?
    echo code=$code
    [ $code -eq 1 ] && return 1;
    while [ 0 -eq 0 ]; do
        echo -e -n "\rQUESTION (y/n/c): "
        read -s -n1 answer
        case "$answer" in
            'y' | 'Y' | 'o' | 'O' ) { echo ; echo YES!!; break; };;
            'n' | 'N' ) { echo ; echo NO...; break; } ;;
            'c' | 'C' ) { echo ; echo CANCEL; break; } ;;
            * ) continue;;
        esac
    done
}
_IsInvalidConfirmType() {
    local lastIdx=`expr ${#1} - 1`
    local last="${1:$lastIdx}"
    local chars="$1"
    [ '-' = "$last" ] && chars="${1:0:lastIdx}"
    chars=${chars,,}
    case "$chars" in
        'o' | 'oc' | 'yn' | 'ync') return 0;;
        *) { echo 'Confirm関数の引数typeは、o,oc,yn,ync,のいずれかのみ有効。末尾に"-"を付与して短文化も可。'; return 1; } ;;
    esac
}
Confirm yn
