variable "username" {
  default = "Shardul"
  type = string
}

variable "age" {
  type = number
}

output "print" {
  value = "hello, ${var.username} and age is ${var.age}"
}
