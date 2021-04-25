# Shellscript Questions for Beginner

## Targets

- Those who can open terminal
- (Optional) Those who know [BED format](https://m.ensembl.org/info/website/upload/bed.html).

## Preparation

Execute the following code.


```sh
TAB="$(printf '\t')"

cat << EOF > test.bed
1${TAB}100${TAB}1000${TAB}geneA${TAB}20
1${TAB}100${TAB}1000${TAB}geneA${TAB}200
1${TAB}900${TAB}2000${TAB}geneB${TAB}100
1${TAB}1000${TAB}2200${TAB}geneB${TAB}10
2${TAB}100${TAB}1500${TAB}geneC${TAB}1000
10${TAB}100${TAB}1000${TAB}geneD${TAB}2000
1${TAB}100${TAB}1000${TAB}geneA${TAB}200
EOF
```

## Questions

### Environments

- Execute `pwd`
- Execute `ls`

### Directory

- Execute `mkdir test_TBA`, then `ls`
- Execute `cd test_TBA`, then `pwd`, then `ls`
- Execute `cd ../`, then `pwd`, then `ls`
- Execute `rm -rf test_TBA`, then `ls`

### Input/Output

- Display `test.bed` (`cat`)
- Display the first 3 lines (`head`)
- Display the 2 lines from the end (`tail`)
- Display 3 lines from the beginning and 2 lines from the end（`head`, `tail`, `|`: pipe)
- Display the first 3 lines and save to `test2.bed` (`head`, `>`:redirect)

### sort, uniq

- Sort `test.bed` by lexicographic order (`sort`)
- Sort `test.bed` by numerical order (`sort -n`)
- Sort `test.bed` by numerical order based on column 5 (`sort -k`)
- Remove the duplicate lines in `test.bed` (`sort -u`)
- Count the number of dupilicate lines in `test.bed` (`sort`, `uniq -c`)

### grep

- Display the lines containing `geneB` (`grep`)
- Display the lines tat do not containing `geneB` (`grep -v`)
- Display the lines containing `geneA` or `geneB` (`grep -e`)
- Display the lines containing `geneA` or `geneB`, and score `20` (`grep -e`, `|`)

### sed

- Replace `gene` to `Gene` (`sed`)
- Add a `chr` at the beginning of the first row (`sed`, regular expression)
- Replace tab delimited to comma delimited (`sed`, escape sequence)

-------------------------------------------------------------------------------

## Example answers

<details>
<summary>Click here if you want to see...</summary>

### Environments

- Execute `pwd`

```sh
pwd
```

- Execute `ls`

```sh
ls
```

### Directory

- Execute `mkdir test_TBA`, then `ls`

```sh
mkdir test_TBA
ls
```

- Execute `cd test_TBA`, then `pwd`, then `ls`

```sh
cd test_TBA
pwd
ls
```

- Execute `cd ../`, then `pwd`, then `ls`

```sh
cd ../
pwd
ls
```

- Execute `rm -rf test_TBA`, then `ls`

```sh
rm -rf test_TBA
ls
```

### Input/Output

- Display `test.bed` (`cat`)

```sh
cat test.bed
```

- Display the first 3 lines (`head`)

```sh
head -n 3 test.bed
```

- Display the 2 lines from the end (`tail`)

```sh
tail -n 2 test.bed
```

- Display 3 lines from the beginning and 2 lines from the end（`head`, `tail`, `|`: pipe)

```sh
head -n 3 test.bed | tail -n 2
```

- Display the first 3 lines and save to `test2.bed` (`head`, `>`:redirect)

```sh
head -n 3 test.bed > test2.bed
```


### sort, uniq

- Sort `test.bed` by lexicographic order (`sort`)

```sh
sort test.bed
```

- Sort `test.bed` by numerical order (`sort -n`)

```sh
sort -n test.bed
```

- Sort `test.bed` by numerical order based on column 5 (`sort -k`)

```sh
sort -k 5,5n test.bed
```

- Remove the duplicate lines in `test.bed` (`sort -u`)

```sh
sort -u test.bed
# または
sort test.bed | uniq
```

- Count the number of dupilicate lines in `test.bed` (`sort`, `uniq -c`)

```sh
sort test.bed | uniq -c
```

### grep

- Display the lines containing `geneB` (`grep`)

```sh
grep "geneB" test.bed
```

- Display the lines tat do not containing `geneB` (`grep -v`)

```sh
grep -v "geneB" test.bed
```

- Display the lines containing `geneA` or `geneB` (`grep -e`)

```sh
grep -e "geneA" -e "geneB" test.bed
```

- Display the lines containing `geneA` or `geneB`, and score `20` (`grep -e`, `|`)

```sh
grep -e "geneA" -e "geneB" test.bed | grep "20$"
```

- * `AWK` alternative

```sh
awk '($4=="geneA" || $4=="geneB") && $5==20' test.bed
```

### sed

- Replace `gene` to `Gene` (`sed`)

```sh
sed "s/gene/Gene/g" test.bed
```

- Add a `chr` at the beginning of the first row (`sed`, regular expression)

```sh
sed "s/^/chr/g" test.bed
```

</details>
