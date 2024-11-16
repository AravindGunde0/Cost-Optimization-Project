variable "ami" {
  default = "ami-005fc0f236362e99f" //Ubuntu 22.04
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "Mykeypair"
}

variable "subnet_id_1a" {
  default = "subnet-015700f52fbfd0c75"
}
variable "iam_instance_profile" {
  default = "p1"
}