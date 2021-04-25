# Subshell

## Questions

- The following code uses the bash-dependent `local` command. Please define local variables without using `local`.

```bash
var="HOGE"
change_var() {
  local var="FUGA"
  echo var="$var"
}
change_var
echo var="$var"
```

- Run the following command without moving from the current directory on the current shell

```sh
suffix="$(date "+%Y%m%d-%H%M%S")"
mkdir -p ./test_TBA_"$suffix"/test1/test2/test3
cd  ./test_TBA_"$suffix"/test1/test2/test3
echo 'Hello Subshell!' > test.txt
cat test.txt
rm -rf ./test_TBA_"$suffix"
```

-------------------------------------------------------------------------------

## Example answers

<details>
<summary>Click here if you want...</summary>

- The following code uses the bash-dependent `local` command. Please define local variables without using `local`.

```bash
var="HOGE"
change_var() (
  var="FUGA"
  echo var="$var"
)
change_var
echo var="$var"
```

- Run the following command without moving from the current directory on the current shell

```sh
suffix="$(date "+%Y%m%d-%H%M%S")"
mkdir -p ./test_TBA_"$suffix"/test1/test2/test3
(
  cd  ./test_TBA_"$suffix"/test1/test2/test3
  echo 'Hello Subshell!' > test.txt
  cat test.txt
)
rm -rf ./test_TBA_"$suffix"
```

</details>

