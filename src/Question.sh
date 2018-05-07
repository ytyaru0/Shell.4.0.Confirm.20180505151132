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
decho() { echo "$1" 1>&2; }
dechon() { echo -n "$1" 1>&2; }
# 確認表示と入力のループ
#   選択肢が指定値以外のときはループする。
#   `select`コマンドと同様の振る舞い。
# $1 回答タイプ o,oc,yn,ync
# $2 質問文
# $3 回答タイプの表示を短くするか否か (default:false)
# 戻り値
#   return
#     0: OK/YES
#     1: NO
#     2: Cancel
#   echo: $1のうちreadで入力された1文字
ConfirmQuestion(){
    IsValidAnswerChars "$1"
    #case "$1" in
    #    'o' | 'oc' | 'yn' | 'ync') ;;
    #    'o-' | 'oc-' | 'yn-' | 'ync-') ;;
    #    *) { echo 'o,oc,yn,ync,のいずれかにしてください。または末尾に"-"を付与できます（短文化）。'; exit 1; } ;;
    #esac
    local answer='InvalidValue'
    #local method=_AnswerCharsLong
    #[ "$3" = 'true' -o "$3" = 'short' ] && local method=_AnswerChars
    #local ansChars=`$method $1`
    local ansChars=`_AnswerChars $1`
    local isLoop='false'
    while [ 'false' = "$isLoop" ]; do
        #echo -n "$2 $ansChars: "
        dechon "$2 $ansChars: "
        read -n 1 answer
        # ESCキー押下で異常終了 (矢印、F1キー等でも終了してしまう）
        #[[ $'\e' == "$answer" ]] && { echo 'Escape'; exit 255; }
        #echo ''
        decho ''
        local isLoop=`IsQuestionLoop "$1" "$answer"`
    done
    #echo "*********** answer: $answer ${ConfirmCodes[$answer]}"
    echo "$answer"
    #echo `expr length \( $1 : "\(.*\)$answer" \)`
    #echo `expr length \( $1 : '\(.*\)'"$answer"'' \)`
    #echo `expr length \( $1 : '\(.*\)$answer' \)`
    # $1の文字列インデックス値(ync-でcを入力したら2を返す)
    return `expr length \( $1 : "\(.*\)$answer" \)`
    #return ${ConfirmCodes[$answer]}
}
# 確認タイプ文字列の妥当性確認
# $1 o,oc,yn,ync
#    末尾にハイフン-が付いている場合もOK
#    各文字は大文字小文字どちらでもOK（入力要求値になる）
IsValidAnswerChars() {
    local lastIdx=`expr ${#1} - 1`
    local last="${1:$lastIdx}"
    local chars=$1
    [ '-' = "$last" ] && chars="${1:0:lastIdx}"
    # 小文字化
    chars=${chars,,}
    #echo $chars
    case "$chars" in
        'o' | 'oc' | 'yn' | 'ync') ;;
        *) { decho 'o,oc,yn,ync,のいずれかにしてください。または末尾に"-"を付与できます（短文化）。'; exit 1; } ;;
    esac
}
# $1: o,oc,yn,ync
# $2: 入力値(read)
IsQuestionLoop(){
    local count=0
    while [ $count -lt ${#1} ]; do
        [ "$2" = "${1:$count:1}" ] && { echo 'true'; return; }
        ((count++))
    done
    echo 'false'
}
_AnswerChars(){
    #local last=${1:`expr ${#1} - 1`}
    local lastIdx=`expr ${#1} - 1`
    local last="${1:$lastIdx}"
    if [ '-' = "$last" ]; then
        _AnswerCharsShort "${1:0:lastIdx}"
    else
        _AnswerCharsLong "${1}"
    fi
}
# 入力値の表示
# $1: o,oc,yn,ync
# echo:
#   (o)
#   (o/c)
#   (y/n)
#   (y/n/c)
_AnswerCharsShort(){
    local count=0
    local chars='('
    while [ $count -lt ${#1} ]; do
        local chars+="${1:$count:1}/"
        ((count++))
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
    #echo $1
    while [ $count -lt ${#1} ]; do
        local label=${ConfirmLabels[${1:$count:1}]}
        local chars+='['${label:0:1}']'${label:1}' '
        ((count++))
    done
    local chars=${chars% }
    local chars+=")"
    echo "$chars"
}
ConfirmYesNo() {
    ConfirmQuestion yn $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq 0 ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq 1 ] && { $3; return $answer; }
    echo $answer
}
ConfirmYesNoCancel() {
    ConfirmQuestion ync $1
    local answer=$?
    #echo "=========== $answer ${ConfirmCodes[n]} ${ConfirmCodes[c]}"
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq 0 ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq 1 ] && { $3; return $answer; }
    [ "$4" != '' -a $answer -eq 2 ] && { $4; return $answer; }
    echo $answer
}
ConfirmOkCancel() {
    ConfirmQuestion oc $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq 0 ] && { $2; return $answer; }
    [ "$3" != '' -a $answer -eq 1 ] && { $3; return $answer; }
    echo $answer
    echo
}
ConfirmOk() {
    ConfirmQuestion oc $1
    local answer=$?
    [ $# -lt 2 ] && { return $answer; }
    [ "$2" != '' -a $answer -eq 0 ] && { $2; return $answer; }
    echo $answer
    echo
}
# 確認フォーム
# $1  : 選択肢(o,oc,yn,ync)
# $2  : 質問文
# $3..: 回答後実行内容
Confirm() {
    [ $# -lt 2 ] && { _ConfirmHelp; return 255; }
    local char=`ConfirmQuestion $1 $2`
    local code=$?
    [ 2 -lt $# -a "$3" != '' -a $code -eq 0 ] && { $3; return $code; }
    [ $# -eq 4 -a "$4" != '' -a $code -eq 1 ] && { $4; return $code; }
    [ $# -eq 5 -a  "$5" != '' -a $code -eq 2 ] && { $5; return $code; }
    echo $char
    return $code
}
_ConfirmHelp() {
    decho '引数エラー: Confirm type message [action ...]'
    decho '===== 引数 ====='
    decho '引数は最低でも2つ必要。3つ目からの[action]は任意。'
    decho '[action]: 回答後に実行する1文を文字列で与える。[type]の位置順序に対応。'
    decho '[type]: o,oc,yn,ync (OK,Cancel,Yes,No)'
    decho '  * 各値は大文字にすることも可'
    decho '  * 末尾に-を付与すると表示を短文化できる'
    decho '例1) Confirm yN どうする？'
    decho '  どうする？ ([y]es [N]o): '
    decho '例2) Confirm ync- どうする？'
    decho '  どうする？ (y/n/c): '
    decho '例3) Confirm oc- 実行する？ "echo OK!" "echo Cancel..."'
    decho '  実行する？ (o/c): o'
    decho '  OK!'
    decho '===== 返り値 ====='
    decho '  echo: [type]の文字列のうち入力した文字'
    decho '    例4) ans=`Confirm yN- どうする？`'
    decho '         [ "y" = "$ans" ] && echo Yes!!'
    decho '         [ "N" = "$ans" ] && echo No...'
    decho '  return: [type]の文字列のうち入力した文字のインデックス値'
    decho '    0: Yes or Ok'
    decho '    1: No or Cancel'
    decho '    2: Cancel'
    decho '    例5) Confirm yN- どうする？'
    decho '         ret=$?'
    decho '         [ 0 -eq $ret ] && { echo Yes!!; return $ret; }'
    decho '         [ 1 -eq $ret ] && { echo No...; return $ret; }'

}
#a=`IsQuestionLoop yn y`
#echo $a
#ConfirmQuestion yn 質問A
#ConfirmYesNo "質問文1。"
#ConfirmYesNo "質問文2。" && echo 'YES!!' || echo 'NO...'
#ConfirmYesNo "質問文3。" "echo YES!!" "echo NO..." "echo ELSE"
Confirm 
a=`Confirm Yn- "質問文Yn-"`
ret=$?
echo "入力値: $a $ret"
Confirm yN- "質問文yN。" "echo YES!!" "echo NO..."
ConfirmYesNoCancel "質問文YNC"
a=$?
[ $a -eq 0 ] && echo 'YES!!'
[ $a -eq 1 ] && echo 'NO...'
[ $a -eq 2 ] && echo 'Cancel'
ConfirmYesNoCancel "質問文3-1。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm ync- "質問文ync-。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm yn- "質問文yn-。" "echo YES!!" "echo NO..."
Confirm oc- "質問文oc-。" "echo OK!!" "echo CANCEL..."
Confirm o- "質問文o-。" "echo OK!!"
Confirm ync "質問文ync。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm yn "質問文yn。" "echo YES!!" "echo NO..."
Confirm oc "質問文oc。" "echo OK!!" "echo CANCEL..."
Confirm o "質問文o。" "echo OK!!"
#Confirm o "質問文o複数行実行文。" "{ echo 'OK1!!'; echo 'OK2!!'}"
Confirm o "質問文o複数行実行。"
a=$?
[ $a -eq 0 ] && { echo 'OK1!!'; echo 'OK2!!'; }
