# Essentia

**Essentia** is a simple stack-based programming language created just for fun.

## Features

### Arithmetic

- `add`, `sub`, `mul`, `div`

```
2 3 add
# 5
```

- `mod`

```
10 2 mod
# 0
```

- `inc`, `dec`

```
6 inc
# 7
```

- `flt`, `inc` convert between integers and float

```
10 flt
# 10.0
```

- `dup` duplicates the top element of the stack

```
2 dup mul
# 4
```

- `:` swap the top two elements of the stack
- `drop` pops the top element of the stack
- `clear` / `clean` to empty the stack
- `eql`, `lt`, `lte`, `gt`, `gte`

- `and`, `or`, `xor`, `not`

```
12 12 ==
# true
```

### Output

- `.` pop and print the top element of the stack

- `.c`, `.h`, `.b`, `.o` pop and print the top element formatted as char, hexadecimal, binary, or octal

```
5 .b
# 101
```

### Conditional

`if`, `ife` conditional execution

```
-1 1 12 12 == ife
# if 12 == 12 then 1 else -1
```

### Strings

- `$` to push a string to the top element of the stack

```
$test
# "test"
```

- `concat` concat the top two elements of the stack
- `emptys` is the equivalent of `" "`

### Looping

- `for - end` loop (currently wip)

```
end 1 3 for
# 1 1 1
```
