variable "registry_server" {
  type = string
  default = "docker.io"
}

variable "registry_username" {
  type = string
}

variable "registry_email" {
  type = string
}

variable "registry_password" {
  type = string
}

variable "deploy_image" {
  type = string
  default = "prudnitskiy/pprivate"
}

variable "deploy_version" {
  type = string
  default = "noversion"
}
