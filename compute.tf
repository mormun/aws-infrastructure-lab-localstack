resource "aws_instance" "jenkins_server" {
  ami           = "ami-00000000"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  # Este script simula la instalación de Jenkins al arrancar
  user_data = <<-EOF
              #!/bin/bash
              echo "Instalando Docker y Jenkins..."
              EOF

  tags = { Name = "Jenkins-Server" }
}
