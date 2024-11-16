terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  profile = "default"
}

resource "aws_instance" "jenkins" {
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.subnet_id_1a
  vpc_security_group_ids  = [sg-077fced5d5205d41f"]
  iam_instance_profile    = var.iam_instance_profile
  #user_data              = file("/Users/Lenovo/)
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "jenkins.cloudbinary.io"
  echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts
  sudo apt-get update
  sudo apt-get install git wget unzip curl tree -y
  sudo apt-get -y install git binutils
  sudo apt-get install openjdk-17-jdk -y
  sudo apt-get install maven -y
  sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
  echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/" >> /etc/environment
  echo "MAVEN_HOME=/usr/share/maven" >> /etc/environment
  source /etc/environment
  sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF

  tags = {
    Name        = "jenkins"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }
}

# Outputs
output "ami" {
  value = aws_instance.jenkins.ami
}
output "public_ip" {
  value = aws_instance.jenkins.public_ip
}
output "private_ip" {
  value = aws_instance.jenkins.private_ip
}

 