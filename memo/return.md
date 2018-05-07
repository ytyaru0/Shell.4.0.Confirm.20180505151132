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

`func`として呼び出してしまうと、戻り値ではなく画面に表示されてしまう。

### echo+return

```bash
func(){
    echo 'Z' 1>&2
    echo 'A'
    echo 'Z' 1>&2
}

ret=`func`
[ 'A' = "$ret" ] && echo OK!
```

## 問題

### return,echo

数値`128`、文字列`A`を戻り値とする意図のコード。

```sh
func(){
    echo 'A'
    return 128
}
```

`return`,`echo`の両方に対応すべく上記のようにすると、`func`で呼び出したとき、`A`が画面に表示されてしまう。

どちらかに絞るべき。

#### 呼出

##### return

```sh
func
ret=$?
echo "ret=$ret"
```

画面に戻り値が表示されてしまう。(`echo 'A'`)

##### echo

```
a=`func`
ret=$?
echo "echo=$a ret=$ret"
```

`echo 'A'`の出力結果`A`は画面に表示されず、変数`a`に代入される。

### echoの戻り値と表示

画面に表示したいが戻り値にはしたくない場合どうするか。

#### stderr

`stdout`と`stderr`を使い分けることで対応できる。

```bash
func(){
    echo 'stderr' 1>&2
    echo 'A'
    return 128
}
a=`func`
[ 'A' = "$a" ] && echo OK!
```

文字列|画面表示|戻り値
------|--------|------
`stderr`|o|x
`A`|x|o

`1>&2`がポイント。`1`は`stdout`, `2`は`stderr`, `>`はリダイレクト, `&`はアドレス？

懸念：エラーメッセージでもないものを`stderr`に出力するのは好ましくないかもしれない。

https://qiita.com/laikuaut/items/e1cc312ffc7ec2c872fc

