#AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Frontend
resource "aws_instance" "proxy" {
  count                  = 2
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.proxy_sg_id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /home/ec2-user/frontend
              EOF


  provisioner "file" {
    source      = "${path.root}/files/frontend/"
    destination = "./frontend"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash",
      ". ~/.nvm/nvm.sh",
      "nvm install 15.0.0",
      "cd ./frontend",
      "npm install",
      "npm run start  > react.log 2>&1 &",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.root}/files/key-lab.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "proxy-${count.index + 1}"
  }
}

# Backend
resource "aws_instance" "backend" {
  count                  = 2
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.backend_sg_id]
  key_name               = var.key_name
  user_data              = <<-EOF
  #!/bin/bash
  mkdir -p /home/ec2-user/backend
  cd /home/ec2-user/backend
  yum updtae -y
  yum upgrade -y

  yum install -y aws-cli || true

  aws s3 cp s3://fp-iti01/final-app/backend /home/ec2-user/backend-app/ --recursive
 
  chown -R ec2-user:ec2-user /home/ec2-user/backend
  chmod -R 755 /home/ec2-user/backend

  tee /etc/yum.repos.d/mongodb-org-6.0.repo <<REPO
  [mongodb-org-6.0]
  name=MongoDB Repository
  baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
  gpgcheck=1
  enabled=1
  gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
  REPO
  
  yum install -y mongodb-org
  systemctl start mongod
  systemctl enable mongod
  
  # Node.js installation
 curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
      . ~/.nvm/nvm.sh
      nvm install 15.0.0
  
  # Start backend
  cd /home/ec2-user/backend
  npm install
  npm run start:dev > backend.log 2>&1 &
EOF


  tags = {
    Name = "backend-${count.index + 1}"
  }
}
