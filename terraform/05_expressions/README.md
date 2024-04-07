# Terraform Expressions 

Provides an interact command-line console for evaluating and experimenting with expressions
```sh
terraform console
```

printing a string
```sh
"Hello World"

# output
"Hello World"
```

printing a string with a new line 
```sh
"Hello World\n"

# output 
<<EOT
Hello World

>>
```

Interpolating a string value
```sh
"Hello ${var.hello}"

# output 
"Hello World"
```

Interpolating a value using [directives](https://developer.hashicorp.com/terraform/language/expressions/strings#directives) 
```sh
"%{ if var.value == 42 }${var.value} is the secret of life%{ else }${var.value} is just a regular number%{ endif }."
# output 
"42 is the secret of life."
```
