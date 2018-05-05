# 確認
# YES(OK),No,Cancel
#   YES/OK: 許可する
#   NO    : 許可しない
#   Cancel: 中断する
# 質問ループ
#   所定の入力値以外だったときの対応
#   * 質問をくりかえす（selectコマンドと同様）
#   * 所定の値を返して終了（やらない。簡易化のため）
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
# 確認表示と入力のループ
#   選択肢が指定値以外のときはループする。
#   `select`コマンドと同様の振る舞い。
# $1 回答タイプ o,oc,yn,ync
# $2 質問文
# $3 回答タイプの表示を短くするか否か (default:false)
ConfirmQuestion(){
    case "$1" in
        'o' | 'oc' | 'yn' | 'ync') ;;
        *) { echo 'o,oc,yn,yncのいずれかにしてください。'; exit 1; } ;;
    esac
    local answer='InvalidValue'
    local method=_AnswerCharsLong
    [ "$3" = 'true' -o "$3" = 'short' ] && local method=_AnswerChars
    #echo -n "$1 `_AnswerChars $1`: "
    #local ansChars=`_AnswerCharsLong $1`
    local ansChars=`$method $1`
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
IsQuestionLoop(){
    local count=0
    while [ $count -lt ${#1} ]; do
        [ "$2" = "${1:$count:1}" ] && { echo 'true'; return; }
        count=$((++count))
    done
    echo 'false'
}
# 入力値の表示
# $1: o,oc,yn,ync
# echo:
#   (o)
#   (o/c)
#   (y/n)
#   (y/n/c)
_AnswerChars(){
    local count=0
    local chars='('
    while [ $count -lt ${#1} ]; do
        local chars+="${1:$count:1}/"
        count=$((++count))
    done
    local chars=${chars%/}
    local chars+=")"
    echo "$chars"
}
# 入力値の表示（長め）
# $1: o,oc,yn,ync
# echo:
#   ([o]k)
#   ([o]k [c]ancel)
#   ([y]es [n]o)
#   ([y]es [n]o [c]ancel)
_AnswerCharsLong(){
    local count=0
    local chars='('
    echo $1
    while [ $count -lt ${#1} ]; do
        echo "****** ${1:$count:1} $count"
        local label=${ConfirmLabels[${1:$count:1}]}
        local chars+='['${label:0:1}']'${label:1}' '
        count=$((++count))
    done
    local chars=${chars% }
    local chars+=")"
    echo "$chars"
}
ConfirmYesNo() {
    ConfirmQuestion yn $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq ${ConfirmCodes[y]} ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq ${ConfirmCodes[n]} ] && { $3; return $answer; }
    echo $answer
}
ConfirmYesNoCancel() {
    ConfirmQuestion ync $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq ${ConfirmCodes[y]} ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq ${ConfirmCodes[n]} ] && { $3; return $answer; }
    [ "$4" != '' -a $answer -eq ${ConfirmCodes[c]} ] && { $4; return $answer; }
    echo $answer
}
ConfirmOkCancel() {
    ConfirmQuestion oc $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq ${ConfirmCodes[o]} ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq ${ConfirmCodes[c]} ] && { $3; return $answer; }
    echo $answer
    echo
}
ConfirmOk() {
    ConfirmQuestion oc $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq ${ConfirmCodes[o]} ] && { $2; return $answer; }
    echo $answer
    echo
}
# 確認フォーム
# $1  : 選択肢(o,oc,yn,ync)
# $2  : 質問文
# $3..: 回答後実行内容
Confirm() {
    ConfirmQuestion $1 $2
    local answer=$?
    [ $# -lt 3 ] && { return $answer; }
    [ "$3" != '' -a $answer -eq ${ConfirmCodes[y]} ] && { $3; return $answer; }
    [ "$3" != '' -a $answer -eq ${ConfirmCodes[o]} ] && { $3; return $answer; }
    [ "$4" != '' -a $answer -eq ${ConfirmCodes[n]} ] && { $4; return $answer; }
    [ "$4" != '' -a $answer -eq ${ConfirmCodes[c]} ] && { $4; return $answer; }
    [ "$5" != '' -a $answer -eq ${ConfirmCodes[c]} ] && { $5; return $answer; }
    echo $answer
}
#a=`IsQuestionLoop yn y`
#echo $a
#ConfirmQuestion yn 質問A
#ConfirmYesNo "質問文1。"
#ConfirmYesNo "質問文2。" && echo 'YES!!' || echo 'NO...'
#ConfirmYesNo "質問文3。" "echo YES!!" "echo NO..." "echo ELSE"
ConfirmYesNoCancel "質問文YNC"
[ $? -eq 0 ] && echo 'YES!!'
[ $? -eq 1 ] && echo 'NO...'
[ $? -eq 2 ] && echo 'Cancel'
#ConfirmYesNo "質問文3-1。" "echo YES!!" "echo NO..."
#Confirm ync "質問文ync。" "echo YES!!" "echo NO..." "echo ELSE"
#Confirm yn "質問文yn。" "echo YES!!" "echo NO..."
#Confirm oc "質問文oc。" "echo OK!!" "echo CANCEL..."
#Confirm o "質問文o。" "echo OK!!"
