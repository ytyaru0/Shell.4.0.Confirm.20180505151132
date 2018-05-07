# bashの戻り値

http://kinokinoppy.hateblo.jp/entry/2015/05/17/003434

## 方法

方法|説明|問題
----|----|----
`exit`,`return`|0..255の整数値のみ。`$?`で直前の値を取得する|すぐ取得しないと変化してしまう
global変数|グローバル変数でやり取りする|名前重複によるバグが生じうる
`echo`|`func(){echo 'A'}`,`a=`func`で取得。stdout(標準出力)の値を戻り値として得られる|戻り値以外のstdoutまで取得されてしまう

## 解法

`echo`の出力先をstderr,stdoutで使い分ける。

出力先|内容
------|----
stdout|戻り値にしたい文字列|`echo "戻り値にしたい文字列"`
stderr|表示したい文字列|`echo "表示したい文字列" 1>&2`

### return

```bash
func(){ return 128; }

func
ret=$?
[ 128 -eq $ret ] && echo OK!
```

### echo

```bash
func(){
    echo 'Z' 1>&2
    echo 'A'
    echo 'Z' 1>&2
}

ret=`func`
[ 'A' = "$ret" ] && echo OK!
```

* `func`として呼び出してしまうと、戻り値ではなく画面に表示されてしまう
* 戻り値にしたくないものは`1>&2`で`stderr`に出力する
    * 懸念：エラーメッセージでもないものを`stderr`に出力するのは好ましくないか
    * https://qiita.com/laikuaut/items/e1cc312ffc7ec2c872fc

### echo+return

```bash
func(){
    echo 'Z' 1>&2
    echo 'A'
    echo 'Z' 1>&2
    return 128
}

ret=`func`
code=$?
echo "code=$code ret=$ret"
[ 'A' = "$ret" -a 128 -eq $code ] && echo OK!
```

`func`として呼び出してしまうと、戻り値ではなく画面に表示されてしまう。

