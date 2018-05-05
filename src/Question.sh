# 確認
# YES(OK),No,Cancel
#   YES/OK: 許可する
#   NO    : 許可しない
#   Cancel: 中断する
# 質問ループ
#   所定の入力値以外だったときの対応
#   * 質問をくりかえす
#   * 所定の値を返して終了
[ -z "$ConfirmLabels" -a "${ConfirmLabels:-A}"="${ConfirmLabels-A}" ] && { declare -A ConfirmLabels; }
[ -z "$ConfirmMethods" -a "${ConfirmMethods:-A}"="${ConfirmMethods-A}" ] && { declare -A ConfirmMethods; }
[ -z "$ConfirmCodes" -a "${ConfirmCodes:-A}"="${ConfirmCodes-A}" ] && { declare -A ConfirmCodes; }
ConfirmLabels[y]=yes
ConfirmLabels[n]=no
ConfirmLabels[o]=ok
ConfirmLabels[c]=cancel
ConfirmCodes[y]=0
ConfirmCodes[n]=1
ConfirmCodes[o]=0
ConfirmCodes[c]=2
ConfirmMethods[y]="echo YES!!"
ConfirmMethods[n]="echo No..."
ConfirmMethods[o]="echo OK!!"
ConfirmMethods[c]="echo Cancell..."
Confirm() {
    echo "$1"
}
# $1 質問タイプ o,oc,yn,ync
# $2 質問文
# 選択肢が指定値以外のときはループする。(`select`コマンドと同様の振る舞い)
ConfirmQuestion(){
    case "$1" in
        'o' | 'oc' | 'yn' | 'ync') ;;
        *) { echo 'o,oc,yn,yncのいずれかにしてください。'; exit 1; } ;;
    esac
    local answer='InvalidValue'
    #echo -n "$1 `_AnswerChars $1`: "
    local ansChars=`_AnswerCharsLong $1`
    local isLoop='false'
    while [ 'false' = "$isLoop" ]; do
        echo -n "$2 $ansChars: "
        read -n 1 answer
        echo ''
        local isLoop=`IsQuestionLoop "$1" "$answer"`
    done
    #echo $answer
    return ${ConfirmCodes[$answer]}
}
# $1: o,oc,yn,ync
# $2: 入力値(read)
#IsQuestionLoop(){
#    echo "$1" | awk -v FS='' '{
#        for (i = 1; i <= NF; i++) {
#            if ($i == $2) { print 'true'; }
#        }
#        print 'false';
#    }'
#}

# $1: o,oc,yn,ync
# $2: 入力値(read)
IsQuestionLoop(){
    local count=0
    while [ $count -le ${#1} ]; do
        [ "$2" = "${1:$count:1}" ] && { echo 'true'; return; }
        local count+=1
    done
    echo 'false'
}
# $1: o,oc,yn,ync
# echo:
#   (o)
#   (o/c)
#   (y/n)
#   (y/n/c)
_AnswerChars(){
    local count=0
    local chars='('
    while [ $count -le ${#1} ]; do
        local chars+="${1:$count:1}/"
        local count+=1
    done
    local chars=${chars%/}
    local chars+=")"
    echo "$chars"
}
# $1: o,oc,yn,ync
# echo:
#   ([o]k)
#   ([o]k [c]ancel)
#   ([y]es [n]o)
#   ([y]es [n]o [c]ancel)
_AnswerCharsLong(){
    local count=0
    local chars='('
    while [ $count -le ${#1} ]; do
        local label=${ConfirmLabels[${1:$count:1}]}
        local chars+='['${label:0:1}']'${label:1}' '
        local count+=1
    done
    local chars=${chars% }
    local chars+=")"
    echo "$chars"
}
ConfirmYesNo() {
    ConfirmQuestion yn $1
    [ $# -lt 2 ] && { return $?; }
    [ $# -lt 2 ] && {
        [ $? -eq ${ConfirmCodes[y]} ] && { return $?; }
        [ $? -eq ${ConfirmCodes[n]} ] && { return $?; }
        [ 'n' = "$answer" ] && { return 1; }
        { return 2;}
    }
    [ "$2" != '' -a  $? -eq ${ConfirmCodes[y]} ] && { $2; return $?; }
    [ "$3" != '' -a  $? -eq ${ConfirmCodes[n]} ] && { $3; return $?; }
    echo $?
    
    #local answer=`ConfirmQuestion yn $1`
    #[ $# -lt 2 ] && {
    #    [ 'y' = "$answer" ] && { return 0; }
    #    [ 'n' = "$answer" ] && { return 1; }
    #    { return 2;}
    #}
    #[ "$2" != '' -a 'y' = "$answer" ] && { $2; return; }
    #[ "$3" != '' -a 'n' = "$answer" ] && { $3; return; }
    #[ "$4" != '' ] && { $4; return; }
    #echo $answer
}
ConfirmYesNoCancel() {
    echo "$1 (y/n)"
    local answer
    read answer
}
ConfirmOkCancel() {
    echo
}
# 質問フォーム
# $1: 質問文
# $2: 選択肢
# $3: 回答後実行内容
QuestionYesNo() {
    echo $1
}
#a=`IsQuestionLoop yn y`
#echo $a
#ConfirmQuestion yn 質問A
ConfirmYesNo "質問文1。"
#ConfirmYesNo "質問文2。" && echo 'YES!!' || echo 'NO...'
#ConfirmYesNo "質問文3。" "echo YES!!" "echo NO..." "echo ELSE"
#ConfirmYesNo "質問文4。" "echo はい" "echo いいえ" "echo どちらでもない"
#a=`ConfirmYesNo "質問文。"`
#echo $a
