## Progress bar with POSIX compliant Shell script

## Introduction

An example of displaying a progress bar in a shell script is [code like the following](https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash).


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

-The above code contains [Bashism](https://mywiki.wooledge.org/Bashism). Please rewrite the code to remove all warnings with `#!/bin/sh` shebang in [shellcheck](https://www.shellcheck.net/).


- The above code only supports up to 1...100. Please rewrite it so that the progress bar can be displayed at any step

-------------------------------------------------------------------------------

## Example answers

<details>
<summary>Click here if you want...</summary>

- The above code contains [Bashism](https://mywiki.wooledge.org/Bashism). Please rewrite the code to remove all warnings with `#!/bin/sh` shebang in [shellcheck](https://www.shellcheck.net/).

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

- The above code only supports up to 1...100. Please rewrite it so that the progress bar can be displayed at any step

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
