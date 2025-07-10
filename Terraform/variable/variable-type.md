```
terraform plan

var.age
    Enter a value: 20

Changes to Outputs:
      + print  = "hello, Shardul and age is 20"
```

```
terraform plan -var age=30

Changes to Outputs:
      + print  = "hello, Shardul and age is 30"
```

```
terraform plan

var.age
  Enter a value: test

Changes to Outputs:

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.
╷
│ Error: Invalid value for input variable
│ 
│   on variable-default.tf line 6:
│    6: variable "age" {
│ 
│ Unsuitable value for var.age set using an interactive prompt: a number is required.
```

----

## Types
- string: "hello"
- number: 15 or  6.283185
- bool: true or false
- list: ["us-west-1a", "us-west-1c"]
- map: {name = "Mabel", age = 52}

--- 

# variables from machine env variables 

export TF_VAR_age=20


