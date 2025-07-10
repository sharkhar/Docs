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
