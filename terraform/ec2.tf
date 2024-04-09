resource "aws_instance" "jenkins" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data = file("${path.module}/install_jenkins.sh")
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-app.id]
  tags = {
    "Name" = "Jenkins Server"
  }
}
