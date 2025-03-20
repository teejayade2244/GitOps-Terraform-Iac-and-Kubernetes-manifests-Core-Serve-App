# reads the private key from AWS SSM Parameter Store and uses it to establish an SSH connection with the EC2 instance.
data "aws_ssm_parameter" "private_key" {
  name = "tope.pem" # Replace with your parameter name
}


resource "aws_instance" "ec2_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]  # Note: This expects a single ID, not a list
  tags = {
    Name = var.server_name
  }
}

 resource "null_resource" "provisioner" {
  count = var.enable_provisioner ? 1 : 0
  # Establish SSH connection to the EC2 instance
  connection {
    type        = "ssh"
    private_key = data.aws_ssm_parameter.private_key.value
    user        = "ubuntu"
    host        = aws_instance.ec2_instance.public_ip
  }

  # Run the provisioner commands
  provisioner "remote-exec" {
      inline = [
        # Install AWS CLI
        # Ref: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
        "sudo apt install unzip -y",
        "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
        "unzip awscliv2.zip",
        "sudo ./aws/install",

        # Install Docker
        # Ref: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
        "sudo apt-get update -y",
        "sudo apt-get install -y ca-certificates curl",
        "sudo install -m 0755 -d /etc/apt/keyrings",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc",
        "sudo chmod a+r /etc/apt/keyrings/docker.asc",
        "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "sudo apt-get update -y",
        "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
        "sudo usermod -aG docker ubuntu",
        "sudo chmod 777 /var/run/docker.sock",
        "docker --version",

        # Install SonarQube (as container)
        # "docker run -d --name sonarqube -p 9000:9000 -v sonarqube_data:/opt/sonarqube/data -v sonarqube_logs:/opt/sonarqube/logs -v sonarqube_extensions:/opt/sonarqube/extensions sonarqube:lts",

        # Install Trivy
        # Ref: https://aquasecurity.github.io/trivy/v0.18.3/installation/
        "sudo apt-get install -y wget apt-transport-https gnupg",
        "wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null",
        "echo 'deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main' | sudo tee -a /etc/apt/sources.list.d/trivy.list",
        "sudo apt-get update -y",
        "sudo apt-get install trivy -y",

        # Install Kubectl
        # Ref: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html#kubectl-install-update
        "curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.4/2024-09-11/bin/linux/amd64/kubectl",
        "curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.4/2024-09-11/bin/linux/amd64/kubectl.sha256",
        "sha256sum -c kubectl.sha256",
        "openssl sha1 -sha256 kubectl",
        "chmod +x ./kubectl",
        "mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH",
        "echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc",
        "sudo mv $HOME/bin/kubectl /usr/local/bin/kubectl",
        "sudo chmod +x /usr/local/bin/kubectl",
        "kubectl version --client",

        # Install Helm
        # Ref: https://helm.sh/docs/intro/install/
        # Ref (for .tar.gz file): https://github.com/helm/helm/releases
        "wget https://get.helm.sh/helm-v3.16.1-linux-amd64.tar.gz",
        "tar -zxvf helm-v3.16.1-linux-amd64.tar.gz",
        "sudo mv linux-amd64/helm /usr/local/bin/helm",
        "helm version",

        # Install ArgoCD
        # Ref: https://argo-cd.readthedocs.io/en/stable/cli_installation/
        "VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)",
        "curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64",
        "sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd",
        "rm argocd-linux-amd64", 

        # Install Java 17
        # Ref: https://www.rosehosting.com/blog/how-to-install-java-17-lts-on-ubuntu-20-04/
        "sudo apt update -y",
        "sudo apt install openjdk-17-jdk openjdk-17-jre -y",
        "java -version",

        # Install Jenkins
        # Ref: https://www.jenkins.io/doc/book/installing/linux/#debianubuntu
        "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
        "echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
        "sudo apt-get update -y",
        "sudo apt-get install -y jenkins",
        "sudo systemctl start jenkins",
        "sudo systemctl enable jenkins",

        # Get Jenkins initial login password
        "ip=$(curl -s ifconfig.me)",
        "pass=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)",

        # Output
        "echo 'Access Jenkins Server here --> http://'$ip':8080'",
        "echo 'Jenkins Initial Password: '$pass''",
        # "echo 'Access SonarQube Server here --> http://'$ip':9000'",
        # "echo 'SonarQube Username & Password: admin'",
      ]
   }
}

