while [ 0 -eq 0 ]; do
    echo -e -n "\rQUESTION (y/n/c): "
    #read -s -n1 -p "QUESTION (y/n/c): " answer
    read -s -n1 answer
    case "$answer" in
        'y' | 'Y' | 'o' | 'O' ) { echo ; echo YES!!; break; };;
        'n' | 'N' ) { echo ; echo NO...; break; } ;;
        'c' | 'C' ) { echo ; echo CANCEL; break; } ;;
        * ) continue;;
    esac
done

