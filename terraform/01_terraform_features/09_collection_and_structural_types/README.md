# Complex Data Types 

```sh
terraform console
```

### object type 
```sh
var.plan

# output
{
  "PlanAmount" = 10
  "PlanName" = "Basic"
}
```

### map type
```sh
var.plans

# output
tomap({
  "PlanA" = "10 USD"
  "PlanB" = "50 USD"
  "PlanC" = "100 USD"
})
```

### list type
```sh
var.planets

# output 
tolist([
  "earth",
  "mars",
  "moon",
])
```

### tuple type
```sh
var.random

# output 
[
  "hello",
  22,
  false,
]
>
```

