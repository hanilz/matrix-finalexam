provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
}
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = ["vpc-044604d0bfb707142"]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

data "aws_subnet" "public_subnet" {
  id = tolist(data.aws_subnets.public_subnets.ids)[0]
}

# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

# Save the private key locally
resource "local_file" "private_key" {
    content         = tls_private_key.ssh_key.private_key_pem
    filename        = "${path.module}/hanilz-finalexam-builder_key.pem"
    file_permission = "0600"
}

# Create an AWS key pair using the public key
resource "aws_key_pair" "builder_key" {
    key_name   = "hanilz-finalexam-builder_key"
    public_key = tls_private_key.ssh_key.public_key_openssh
}

# Output the necessary details
output "ssh_private_key_path" {
    value       = local_file.private_key.filename
    description = "Path to the generated private SSH key"
    sensitive   = true
}

output "ssh_key_name" {
  value       = aws_key_pair.builder_key.key_name
  description = "Name of the AWS SSH key pair"
}

resource "aws_security_group" "sg" {
    vpc_id = "vpc-044604d0bfb707142"

    # for SSH
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["199.203.122.29/32"]
    }

    # for Jenkins
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["199.203.122.29/32"]
    }

    # for python app
    ingress {
        from_port   = 5001
        to_port     = 5001
        protocol    = "tcp"
        cidr_blocks = ["199.203.122.29/32"]
    }

    # for outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web_server" {
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t3.medium"
    subnet_id       = data.aws_subnet.public_subnet.id
    security_groups = [aws_security_group.sg.id]
    associate_public_ip_address = true
    key_name = aws_key_pair.builder_key.key_name
    tags = { Name = "hanil-finalexam-builder-ec2" }
}

resource "time_sleep" "wait_for_ip" {
    create_duration = "1m"
}

resource "null_resource" "validate_ip" {
    provisioner "local-exec" {
        command = <<EOT
        retries=4
        interval=30
        for i in $(seq 1 $retries); do
        if [ -z "${aws_instance.web_server.public_ip}" ]; then
            echo "Attempt $i: Public IP address not assigned yet, retrying in $interval seconds..."
            sleep $interval
        else
            echo "Public IP address assigned: ${aws_instance.web_server.public_ip}"
            exit 0
        fi
        done
        echo "ERROR: Public IP address was not assigned after $retries attempts." >&2
        exit 1
        EOT
    }
    depends_on = [time_sleep.wait_for_ip]
}

output "instance_public_ip" {
    description = "Public IP of the EC2 instance"
    value       = aws_instance.web_server.public_ip
}

output "sg_id" {
    description = "Security Group ID"
    value       = aws_security_group.sg.id
}
