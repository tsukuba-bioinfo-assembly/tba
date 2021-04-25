# Multiprocessing

## Questions

- Parallelize the `sleep` command

```sh
echo 'start'
sleep 3
sleep 3
sleep 3
echo 'finish!'
```

- Parallelize the `sleep` command with **no side effects**.

* No side-effects means no output (standard output, standard error, redirect to file).

```sh
echo 'start'
sleep 3
sleep 3
sleep 3
echo 'finish!'
```

-------------------------------------------------------------------------------

## Example answers

<details>
<summary>Click here if you want...</summary>

- Parallelize the `sleep` command

```sh
echo 'start'
sleep 3 &
sleep 3 &
sleep 3 &
wait
echo 'finish!'
```

- Parallelize the `sleep` command with **no side effects**.

```sh
echo 'start'
{
  sleep 3 &
  sleep 3 &
  sleep 3 &
  wait
} 1>/dev/null 2>&1
echo 'finish!'
```


</details>

