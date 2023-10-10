# variable "whitelist" {
#   type = list(string)
# }
# variable "web_image_id" {
#   type = string
# }
# variable "web_instance_type" {
#   type=string
# }
# variable "web_desired_capacity" {
# type=number
# }
# variable "web_max_size" {
# type=number
# }
# variable "web_min_size" {
# type=number
# }
                                                                                                                         



resource "aws_s3_bucket" "tf_bucket" {
  bucket = "tf-exercise-bucket"
  acl	   = "private"
}


data "aws_vpc" "project-vpc2" {id ="vpc-0741cc79be2adf011"}

data "aws_subnet" "my_subnet" {id ="subnet-04f383a68762fc487"}
data "aws_subnet" "my_subnet2" {id ="subnet-059436c6453a77ceb"}

resource "aws_security_group" "security_group_exercise" {
  name        = "security_group_exercise"
  description = "Allow standard http and https ports inbound and everything outbound"
  vpc_id      = data.aws_vpc.project-vpc2.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }

}

# module "web_app" {
#   source = "./.modules/web_app/main.tf"

# }


resource "aws_instance" "instance_exercise" {
  # count = 2

  ami           = "ami-0626e196bb518cfaa"
  instance_type = "t2.micro"
  subnet_id      = data.aws_subnet.my_subnet.id

  vpc_security_group_ids = [
    aws_security_group.security_group_exercise.id
]

  tags = {
    "Terraform" : "true"
    Name          = "terraform instance exercise"
  }
}

# resource "aws_eip_association" "prod_web" {
#   instance_id   = aws_instance.prod_web.0.id
#   allocation_id = aws_eip.prod_web.id
# }

# #decoupling the creation of the ip and it's assignment

# resource "aws_eip" "prod_web" {
# #  instance = aws_instance.prod_web.id
#     tags = {
#     "Terraform" : "true"
#   }
# }

# resource "aws_elb" "prod_web"{
#   name = "prod-web"
#   # instances = aws_instance.prod_web.*.id
#   subnets = [data.aws_subnet.my_subnet.id, data.aws_subnet.my_subnet2.id]
#   security_groups = [aws_security_group.my_security_group.id]

#   listener {
#     instance_port = 80
#     instance_protocol = "http"
#     lb_port = 80
#     lb_protocol = "http"
#   }
#   tags = {
#     "Terraform" : "true"
#   }
# }

# resource "aws_launch_template" "prod_web" {
#   name_prefix   = "prod-web"
#   image_id      = var.web_image_id
#   instance_type = var.web_instance_type
# }

# resource "aws_autoscaling_group" "prod_web" {
#   # availability_zones = ["eu-west-2a", "eu-west-2b"]
#   vpc_zone_identifier = [data.aws_subnet.my_subnet.id, data.aws_subnet.my_subnet2.id]
#   desired_capacity   = var.web_desired_capacity
#   max_size           = var.web_max_size
#   min_size           = var.web_min_size

#   launch_template {
#     id      = aws_launch_template.prod_web.id
#     version = "$Latest"
#   }
#   tag {
#   key                 = "Terraform"
#   value               = "true"
#   propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_attachment" "prod_web" {
#   autoscaling_group_name = aws_autoscaling_group.prod_web.id
#   elb                    = aws_elb.prod_web.id
# }

# module "web_app" {
#   source= "../modules/web_app"

# web_image_id         =var.web_image_id
# web_instance_type    = var.web_instance_type
# web_desired_capacity = var.web_desired_capacity
# web_max_size         = var.web_max_size
# web_min_size         = var.web_min_size
# subnets              = [data.aws_subnet.my_subnet.id, data.aws_subnet.my_subnet2.id]
# security_groups      = [aws_security_group.my_security_group]
# web_app              = "prod"

# }



