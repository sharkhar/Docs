variable "test" {
  default = "India"
  type = string
}


output test {
  value = "hello, ${var.test}" 
}


# terraform plan
#    Changes to Outputs:
#          + test   = "hello, India"


# terraform plan -var test=shardul
#    Changes to Outputs:
#          + test   = "hello, shardul"
