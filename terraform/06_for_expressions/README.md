# For Expressions

```sh
terraform console
```

iterating over the values of a list
```sh
[for c in var.companies : lower(c)]

# output 
[
  "nvidia",
  "openai",
  "google",
]
```

getting a list with the keys of a map
```sh
[for k,v in var.ceos : upper(k)]

# output
[
  "GOOGLE",
  "NVIDIA",
  "OPENAI",
]
```

getting a list of with the values of a map
```sh
[for k,v in var.ceos : upper(v)]

# output 
[
  "SUNDAR PICHAI",
  "JENSEN HUANG",
  "SAM ALTMAN",
]
```

Use the hash rocket operator to show map
```sh
{for k,v in var.ceos : "${k}" => upper(v)}

# output 
{
  "google" = "SUNDAR PICHAI"
  "nvidia" = "JENSEN HUANG"
  "openai" = "SAM ALTMAN"
}

```