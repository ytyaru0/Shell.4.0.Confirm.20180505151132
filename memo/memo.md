﻿# Confirm

CUIにおける確認ダイアログ。

## 既存

* command
    * whiptail
    * dialog
    * tput
* C-Lib
    * ncurses

### whiptail

https://orebibou.com/2018/01/ubuntu%E3%82%84centos%E3%81%AB%E5%85%A5%E3%81%A3%E3%81%A6%E3%82%8Bwhiptail%E3%81%A7tui%E3%81%A3%E3%81%BD%E3%81%84%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99/

```sh
$ whiptail
```

### tput

`tput`は[ANSIエスケープコード](https://en.wikipedia.org/wiki/ANSI_escape_code)を出力するコマンド。

http://vorfee.hatenablog.jp/entry/2015/03/17/173635

```
$ tput
```

* `tput [-V] [-S] [-T term] capname`

`capname`は以下`infocmp`コマンドで取得できる。

```
$ infocmp
```

```sh
$ infocmp
#	Reconstructed via infocmp from file: /lib/terminfo/x/xterm
xterm|xterm-debian|X11 terminal emulator,
	am, bce, km, mc5i, mir, msgr, npc, xenl,
	colors#8, cols#80, it#8, lines#24, pairs#64,
	acsc=``aaffggiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~,
	bel=^G, blink=\E[5m, bold=\E[1m, cbt=\E[Z, civis=\E[?25l,
	clear=\E[H\E[2J, cnorm=\E[?12l\E[?25h, cr=^M,
	csr=\E[%i%p1%d;%p2%dr, cub=\E[%p1%dD, cub1=^H,
	cud=\E[%p1%dB, cud1=^J, cuf=\E[%p1%dC, cuf1=\E[C,
	cup=\E[%i%p1%d;%p2%dH, cuu=\E[%p1%dA, cuu1=\E[A,
	cvvis=\E[?12;25h, dch=\E[%p1%dP, dch1=\E[P, dim=\E[2m,
	dl=\E[%p1%dM, dl1=\E[M, ech=\E[%p1%dX, ed=\E[J, el=\E[K,
	el1=\E[1K, flash=\E[?5h$<100/>\E[?5l, home=\E[H,
	hpa=\E[%i%p1%dG, ht=^I, hts=\EH, ich=\E[%p1%d@,
	il=\E[%p1%dL, il1=\E[L, ind=^J, indn=\E[%p1%dS,
	invis=\E[8m, is2=\E[!p\E[?3;4l\E[4l\E>, kDC=\E[3;2~,
	kEND=\E[1;2F, kHOM=\E[1;2H, kIC=\E[2;2~, kLFT=\E[1;2D,
	kNXT=\E[6;2~, kPRV=\E[5;2~, kRIT=\E[1;2C, kb2=\EOE,
	kbs=\177, kcbt=\E[Z, kcub1=\EOD, kcud1=\EOB, kcuf1=\EOC,
	kcuu1=\EOA, kdch1=\E[3~, kend=\EOF, kent=\EOM, kf1=\EOP,
	kf10=\E[21~, kf11=\E[23~, kf12=\E[24~, kf13=\E[1;2P,
	kf14=\E[1;2Q, kf15=\E[1;2R, kf16=\E[1;2S, kf17=\E[15;2~,
	kf18=\E[17;2~, kf19=\E[18;2~, kf2=\EOQ, kf20=\E[19;2~,
	kf21=\E[20;2~, kf22=\E[21;2~, kf23=\E[23;2~,
	kf24=\E[24;2~, kf25=\E[1;5P, kf26=\E[1;5Q, kf27=\E[1;5R,
	kf28=\E[1;5S, kf29=\E[15;5~, kf3=\EOR, kf30=\E[17;5~,
	kf31=\E[18;5~, kf32=\E[19;5~, kf33=\E[20;5~,
	kf34=\E[21;5~, kf35=\E[23;5~, kf36=\E[24;5~,
	kf37=\E[1;6P, kf38=\E[1;6Q, kf39=\E[1;6R, kf4=\EOS,
	kf40=\E[1;6S, kf41=\E[15;6~, kf42=\E[17;6~,
	kf43=\E[18;6~, kf44=\E[19;6~, kf45=\E[20;6~,
	kf46=\E[21;6~, kf47=\E[23;6~, kf48=\E[24;6~,
	kf49=\E[1;3P, kf5=\E[15~, kf50=\E[1;3Q, kf51=\E[1;3R,
	kf52=\E[1;3S, kf53=\E[15;3~, kf54=\E[17;3~,
	kf55=\E[18;3~, kf56=\E[19;3~, kf57=\E[20;3~,
	kf58=\E[21;3~, kf59=\E[23;3~, kf6=\E[17~, kf60=\E[24;3~,
	kf61=\E[1;4P, kf62=\E[1;4Q, kf63=\E[1;4R, kf7=\E[18~,
	kf8=\E[19~, kf9=\E[20~, khome=\EOH, kich1=\E[2~,
	kind=\E[1;2B, kmous=\E[M, knp=\E[6~, kpp=\E[5~,
	kri=\E[1;2A, mc0=\E[i, mc4=\E[4i, mc5=\E[5i, meml=\El,
	memu=\Em, op=\E[39;49m, rc=\E8, rev=\E[7m, ri=\EM,
	rin=\E[%p1%dT, ritm=\E[23m, rmacs=\E(B, rmam=\E[?7l,
	rmcup=\E[?1049l, rmir=\E[4l, rmkx=\E[?1l\E>, rmso=\E[27m,
	rmul=\E[24m, rs1=\Ec, rs2=\E[!p\E[?3;4l\E[4l\E>, sc=\E7,
	setab=\E[4%p1%dm, setaf=\E[3%p1%dm,
	setb=\E[4%?%p1%{1}%=%t4%e%p1%{3}%=%t6%e%p1%{4}%=%t1%e%p1%{6}%=%t3%e%p1%d%;m,
	setf=\E[3%?%p1%{1}%=%t4%e%p1%{3}%=%t6%e%p1%{4}%=%t1%e%p1%{6}%=%t3%e%p1%d%;m,
	sgr=%?%p9%t\E(0%e\E(B%;\E[0%?%p6%t;1%;%?%p5%t;2%;%?%p2%t;4%;%?%p1%p3%|%t;7%;%?%p4%t;5%;%?%p7%t;8%;m,
	sgr0=\E(B\E[m, sitm=\E[3m, smacs=\E(0, smam=\E[?7h,
	smcup=\E[?1049h, smir=\E[4h, smkx=\E[?1h\E=, smso=\E[7m,
	smul=\E[4m, tbc=\E[3g, u6=\E[%i%d;%dR, u7=\E[6n,
	u8=\E[?1;2c, u9=\E[c, vpa=\E[%i%p1%dd,
```

#### 例

```
$ tput setab 1 && echo 赤い背景
```

```
$ tput setab 1 && echo 赤い背景 && tput sgr0
```

## 表示

```
確認メッセージ [y/n]: {入力値}
```

### 確認パターン

パターン名|表示例|備考
----------|------|----
`o`|`[OK]`|事実上、入力値は何でも良い。タイムアウト可
`oc`|`[OK][Cancel]`|キャンセルしたいときに。タイムアウト可
`yn`|`[Yes][No]`|二択。
`ync`|`[Yes][No][Cancel]`|二択＋キャンセルしたいとき

