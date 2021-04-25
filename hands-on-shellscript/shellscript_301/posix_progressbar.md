# Progress bar with POSIX compliant Shell script

POSIX準拠Shellコマンドでプログレスバーを表示しよう


## Introduction

- An example of displaying a progress bar in a shell script is [code like the following](https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash).
- シェルスクリプトでプログレスバーを表示する一例として、[下記のようなコード](https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash)が挙げられます。


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


## Questions

- Q1. The above code contains [Bashism](https://mywiki.wooledge.org/Bashism). Please rewrite the code to remove all warnings with `#!/bin/sh` shebang in [shellcheck](https://www.shellcheck.net/).
- Q1. 上記のコードは[Bashism](https://mywiki.wooledge.org/Bashism)が含まれています. [Shellcheck](https://www.shellcheck.net/#)で`#!/bin/sh`指定をした状態で警告がなくなるようにコードを修正してください.


- Q2. The above code only supports up to 1...100. Please rewrite it so that the progress bar can be displayed at any step
- Q2. 上記のコードは1...100までしか対応していないため、任意のステップでプログレスバーを表示できるように書き直してください

-------------------------------------------------------------------------------

## Example answers

<details>
<summary>Click here if you want...</summary>

- Q1. The above code contains [Bashism](https://mywiki.wooledge.org/Bashism). Please rewrite the code to remove all warnings with `#!/bin/sh` shebang in [shellcheck](https://www.shellcheck.net/).
- Q1. 上記のコードは[Bashism](https://mywiki.wooledge.org/Bashism)が含まれています. [Shellcheck](https://www.shellcheck.net/#)で`#!/bin/sh`指定をした状態で警告がなくなるようにコードを修正してください.

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

- Q2. The above code only supports up to 1...100. Please rewrite it so that the progress bar can be displayed at any step
- Q2. 上記のコードは1...100までしか対応していないため、任意のステップでプログレスバーを表示できるように書き直してください


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
