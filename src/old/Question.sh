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
# 確認表示と入力のループ
#   選択肢が指定値以外のときはループする。
#   `select`コマンドと同様の振る舞い。
# $1 質問タイプ o,oc,yn,ync
# $2 質問文
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
IsQuestionLoop(){
    local count=0
    while [ $count -le ${#1} ]; do
        [ "$2" = "${1:$count:1}" ] && { echo 'true'; return; }
        local count+=1
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
    while [ $count -le ${#1} ]; do
        local chars+="${1:$count:1}/"
        local count+=1
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
# $1: 選択肢(o,oc,yn,ync)
# $2: 質問文
# $3: 回答後実行内容
Confirm() {
    ConfirmQuestion $1 $2
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq ${ConfirmCodes[y]} ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq ${ConfirmCodes[n]} ] && { $3; return $answer; }
    [ "$4" != '' -a $answer -eq ${ConfirmCodes[c]} ] && { $4; return $answer; }
    echo $answer
}
#a=`IsQuestionLoop yn y`
#echo $a
#ConfirmQuestion yn 質問A
#ConfirmYesNo "質問文1。"
#ConfirmYesNo "質問文2。" && echo 'YES!!' || echo 'NO...'
#ConfirmYesNo "質問文3。" "echo YES!!" "echo NO..." "echo ELSE"
ConfirmYesNo "質問文3-1。" "echo YES!!" "echo NO..."
#ConfirmYesNo "質問文4。" "echo はい" "echo いいえ" "echo どちらでもない"
#a=`ConfirmYesNo "質問文。"`
#echo $a
