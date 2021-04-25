# POSIX準拠Shellコマンドでプログレスバーを表示しよう

## はじめに

シェルスクリプトでプログレスバーを表示する一例として、[下記のようなコード](https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash)が挙げられます。


```bash
#!/bin/bash
# progress bar function
prog() {
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}
# test loop
for x in {1..100} ; do
    prog "$x" still working...
    sleep .1   # do some work here
done ; echo

```


## 問題

- 上記のコードは[Bashism](https://mywiki.wooledge.org/Bashism)が含まれています. Bashismを除いて [shellcheck](https://www.shellcheck.net/#)で`#!/bin/sh`指定をした状態で警告がなくなるようにコードを修正してください.

> なお[1秒未満のsleepはC言語を使う必要がある](https://qiita.com/richmikan@github/items/65a55a405874e655fbac)ので今回は許してください:bow:

- 上記のコードは1...100までしか対応していないため、任意のステップでプログレスバーを表示できるように書き直してください

-------------------------------------------------------------------------------

## 解答例

<details>
<summary>こちらをクリック</summary>

- 上記のコードは[Bashism](https://mywiki.wooledge.org/Bashism)が含まれています. Bashismを除いて [shellcheck](https://www.shellcheck.net/#)で`#!/bin/sh`指定をした状態で警告がなくなるようにコードを修正してください.

```sh
prog() (
  w=80
  p=$1; shift
  # create a string of spaces, then change them to dots
  dots=$(printf "%*s" "$((p*w/100 ))" "" | tr " " ".")
  # print those dots on a fixed-width space plus the percentage etc.
  printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"
)

awk 'BEGIN{for(i=1;i<=100;i++) print i}' |
while read -r x; do
  prog "$x" still working...
  sleep .1   # do some work here
done
printf "\n"
```

- 上記のコードは1...100までしか対応していないため、任意のステップでプログレスバーを表示できるように書き直してください

```sh
prog() (
  w=80
  step="$1"; shift
  p="$1"; shift
  # create a string of spaces, then change them to dots
  dots=$(printf "%*s" "$((p*w/step))" "" | tr " " ".")
  # print those dots on a fixed-width space plus the percentage etc.
  printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"
)

step=25
awk -v step="$step" 'BEGIN{for(i=1;i<=step;i++) print i}' |
while read -r x; do
  prog "$step" "$x" still working...
  sleep .1   # do some work here
done
printf "\n"
```
</details>
