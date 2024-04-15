# Functions 


### `split()`
```sh
split(",", var.example)

# output 
tolist([
  "!hello",
  "world!",
])
```

### `trim()`
```sh
trim(var.example, "!")

# output 
"hello, world"
```

#### `uuid()`
```sh
uuid()

# output 
"74c66ca2-d8da-c075-8750-2ff84b0b7c1f"
```

#### `bcrypt()`
```sh
bcrypt(var.example)

# output 
"$2a$10$hyUVTdkDJ0ghLud9Mn6doOKRPActnY9OM9xxfHRQ.c6klErodPBri"
```

#### `cidrsubnet()`
```sh
cidrsubnet("172.16.0.0/12", 4, 2)
```

#### `tobool()`
```sh
tobool("true")

# output 
true
```

#### `coalesce()` and the `...` operator 
Takes any number of arguments and returns the first one that isn't null or an empty string.

To perform the `coalesce()` operation with a list of strings use the `...` symbol to expand that list as arguments. 

```sh
coalesce(var.items...)

# output 
"false"
```


### `keys()`

```sh
keys(var.info)

# output 
tolist([
  "Count",
  "Name",
  "Provider",
])
```

### `reverse()`

```sh
reverse([1, 2, 3])

# output 
[
    3,
    2, 
    1
]
```

### `abspath()`
```sh
path.root 

# output 
"/Users/user/the/absolute/path/to/the/current/directory"
```



#### Resources
- [Built-in Functions](https://developer.hashicorp.com/terraform/language/functions)

