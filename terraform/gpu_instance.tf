data "template_file" "user_data" {
  template = "${file("terraform/user-data.tpl")}"
}

data "aws_ami" "udacity" {
  most_recent = true
  filter {
    name = "name"
    values = ["udacity-dl"]
  }
  filter {
    name = "description"
    values = ["The official AMI of Udacity's Deep Learning Foundations"]
  }
}

resource "aws_instance" "gpu" {
  ami = "${data.aws_ami.udacity.id}"
  instance_type = "g2.2xlarge"
  connection {
    type     = "ssh"
    user     = "udacity"
    password = "udacity"
  }
  provisioner "file" {
    source      = "dlnd_tv_script_generation.ipynb"
    destination = "~/dlnd_tv_script_generation.ipynb"
  }
  provisioner "file" {
    source      = "helper.py"
    destination = "~/helper.py"
  }
  provisioner "file" {
    source      = "problem_unittests.py"
    destination = "~/problem_unittests.py"
  }
  provisioner "file" {
    source      = "data"
    destination = "~/"
  }
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.allow_traffic.id}"]
  user_data = "${data.template_file.user_data.rendered}"
}

output "public_ip" {
  value = "${aws_instance.gpu.public_ip}"
}
output "public_dns" {
  value = "${aws_instance.gpu.public_dns}"
}
