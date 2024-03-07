variable "git-name" {
  default = "amagne"
}

# TODO : Enter your git token here. 
# For simplicity reason, we hard coded sensitive data,
# but in a production level project we'd use mechanism that does'nt imply to hardcode sensitive data
variable "git-token" {
  default = "xxxxx"  
}

variable "git-repo" {
  default = "phonebook-terraform"
}

# TODO : Enter your AWS key name here. 
# For simplicity reason, we hard coded sensitive data,
# but in a production level project we'd use mechanism that does'nt imply to hardcode sensitive data
variable "key-name" {
  default = "xxxx" 
}

# TODO : Enter your domain name here. 
variable "hosted-zone" {
  default = "xxxx"
}