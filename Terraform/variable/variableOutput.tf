variable "username" {
  
}

output "name" {
  value = "hello ${var.username}"
}


# terraform plan -var "username=shardul"
