# Splat

```sh
var.company_info

# output 
tolist([
  {
    "ceo" = "Tim Cook"
    "company" = "Apple"
  },
  {
    "ceo" = "Sam Altman"
    "company" = "OpenAI"
  },
  {
    "ceo" = "Elon Musk"
    "company" = "Tesla"
  },
  {
    "ceo" = "Jensen Huang"
    "company" = "Nvidia"
  },
])
```

```sh
[for c in var.company_info : c.ceo ]

# output 
[
  "Tim Cook",
  "Sam Altman",
  "Elon Musk",
  "Jensen Huang",
]
```

```sh
[for c in var.company_info : c.company]

# output

[
  "Apple",
  "OpenAI",
  "Tesla",
  "Nvidia",
]
```

Splats allow you to use a shorter syntax to access properties
```sh
var.company_info[*].company

# output
tolist([
  "Apple",
  "OpenAI",
  "Tesla",
  "Nvidia",
])
```

Here's another example
```sh
var.company_info[*].ceo

# output
tolist([
  "Tim Cook",
  "Sam Altman",
  "Elon Musk",
  "Jensen Huang",
])
```

