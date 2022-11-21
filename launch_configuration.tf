# Launch configuration for backend web server.
resource "aws_launch_configuration" "web" {
  name_prefix = "web-"
image_id = "ami-070dfe9103fd1bb1b"
  instance_type = "t2.micro"
  key_name = "jideola_macbookpro"
security_groups = [aws_security_group.private_sg.id]
lifecycle {
    create_before_destroy = true
  }
}