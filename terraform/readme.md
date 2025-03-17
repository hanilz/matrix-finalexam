# Hanil Zarbailov Final Exam Repo - Terraform
This folder includes the `main.tf` file that configures and deploys all the necessary resources for deploying an EC2 instance on AWS.

*NOTE:* We rely on an existing VPC and an existing public subnet.

## Running the Terraform
### init
```bash
terraform init
```
### plan
```bash
terraform plan
```
### apply
```bash
terraform apply
```
Type `yes` when prompted.
### destroy
```bash
terraform destroy
```
Type `yes` when prompted.

## Outputs
The `terraform apply` command outputs the following data:
```json
[
    instance_public_ip, // the public-ip of the instance for connecting to it later with SSH 
    sg_id, // security group ID for validation
    ssh_key_name, // pem key name
    ssh_private_key_path // // pem key local path
]
```

## Connecting with SSH
```bash
ssh -i "<PRIVATE KEY PATH>" ubuntu@<EC2 PUBLIC IP>
```

## Installing Docker and Docker-Compose using SSH
### Step 1: Update the Package Manager
```sh
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install Docker
```sh
sudo apt install -y docker.io
```
Start and Enable Docker
```sh
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 3: Install Docker Compose
```sh
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
Make It Executable
```sh
sudo chmod +x /usr/local/bin/docker-compose
```

### Step 4: Add User to the Docker Group
To avoid using sudo every time you run Docker:
```sh
sudo usermod -aG docker $USER
newgrp docker
```

### Step 5: Verify the Installation
```sh
docker --version
docker-compose --version
```