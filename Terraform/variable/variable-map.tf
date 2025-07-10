variable "age" {
  type = map
  default = {
  john = "52"
  shardul  = 29
}
}

variable "username" {
  type = string
}


output "print" {
  value = "hello, ${var.username} and age is ${lookup(var.age, "${var.username}")}"
}


```
terraform plan 

var.username
  Enter a value: john


Changes to Outputs:
  + print  = "hello, john and age is 52"
```
