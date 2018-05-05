# このソフトウェアについて

GitHub簡易アップローダ。

連想配列を用いているため、動作環境はBash4.0以降。

# 使い方

## 準備

アカウントデータファイルを用意する。

Accounts.csv
```csv
Username,MailAddress,Password
```

複数のアカウントがあるなら、同様に1行ずつ記入すること。

### Token

#### Tokenの取得

GitHubの[設定ページ](https://github.com/settings/tokens)にて取得する。

Tokenのscopeは`public_repo`を持たせること。

#### TokenのCSV設定

```csv
Username,MailAddress,Password,AccessToken
```

##### パスワード隠蔽

AccessTokenがあればパスワードが無くても動く。以下のように空値や`*`など無効値にして隠すことができる。

```csv
Username,MailAddress,,AccessToken
```

##### 二要素認証

二要素認証を有効にしたGitHubアカウントでAPIを使う場合はパスワードのほかに、ワンタイムパスワードも必要。

ただし、TokenがあればTokenのみでAPIを使えるはず。もし二要素認証を有効化したアカウントで本ツールを使いたいなら、AccessTokenが必要である。

## 実行

### リポジトリ作成 / コミット

```sh
$ push
```
```sh
$ push some_username
```

* `push`ファイルを環境変数`PATH`が通っている所に配置する。
* カレントディレクトリをリポジトリと想定する

## 確認表示

### JSON

[リモートリポジトリ生成API](https://developer.github.com/v3/repos/#create)の応答。何か変わっても知れるように。（デバッグ）

### ReadMe

```sh
カレントディレクトリに ReadMe.md が存在しません。作成してください。
```

間違ってカレントディレクトリが`/`などだった場合も、少しは安心。

### User

```sh
ユーザを選択してください。
1) user1  3) user3  5) user5
2) user2  4) user4  6) user6
```

起動引数がなければ、CSVから全ユーザ名を取得して選択肢を出す。辞書順。

```sh
指定されたユーザ名はDBに登録されていません。
```

起動引数でユーザ名を指定しても、DBになければエラーになる。

### リポジトリ作成

```sh
リポジトリを作成しますか？ (y/n)
```

`y`入力後`Enter`キー押下で実行する。`git init`により`.git`ディレクトリ一式が作成される。また、WebAPIによりリモートリポジトリを作成する。

この確認は`.git`が無い場合に限る。

### add前

* `git status -s`
* `git add -n .`

`git status`を追加。`git rm some.py`などで削除だけしたときも変化がわかるようにした。

### commitメッセージ入力

上記を表示後、入力待ちとなる。ここでコミットメッセージを入力し、Enterキー押下すると、`git (add, commit, push)`コマンドが一気に実行される。

もし中断したいなら、何も入力せずに`Enter`キー押下する。

### push出力

`git push`コマンドがstderrにパスワードやトークンを含むURLを出していたのを抑制した。

```sh
To https://{user}:{pass}@github.com/{user}/{repo}.git
```

```sh
To https://{user}:{token}@github.com/{user}/{repo}.git
```

なお、URLにパスワードやトークンを設定するのは、pushする度に求められるそれらの入力を省くためである。

SSH通信であればURLにパスワードやトークンを設定せずとも入力を省略できるが、ここでは実装を簡略化するためHTTPS通信に限定する。

# 未実装だが欲しい機能

## リポジトリ削除

* ローカルリポジトリ(`.git`ディレクトリ)を削除する
* リモートリポジトリを削除する(WebAPIにより)
    * AccessTokenを使うなら`delete_repo`のscopeが必要

```sh
$ push -d
```

削除対象のユーザ名とリポジトリ名は、`.git/config`から取得する。

# 開発環境

* [Raspberry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 3 Model B
    * [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) GNU/Linux 8.0 (jessie)
        * bash 4.3.30

# ライセンス

このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)

利用ライブラリは以下。

Library|License|Copyright
-------|-------|---------
[assert.sh](https://github.com/lehmannro/assert.sh)|[LGPL-3.0](https://github.com/lehmannro/assert.sh/blob/master/COPYING.LESSER)|[Copyright (C) 2007 Free Software Foundation, Inc. http://fsf.org/](https://github.com/lehmannro/assert.sh/blob/master/COPYING)

