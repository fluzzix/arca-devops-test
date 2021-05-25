# Define provider and region
provider "aws" {
    region = "us-east-1"
}



# create default vpc
resource "aws_default_vpc" "default" {
    enable_dns_hostnames = true
    tags = {
        Name = "arca_networks_vpc"
    }
}

# create security group
resource "aws_security_group" "arca_networks_sg" {
    name = "arca_networks_sg"
    description = "This firewall allows SSH, HTTP and HTTPS"
    vpc_id = "${aws_default_vpc.default.id}"
 
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    ingress { 
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    tags = {
        Name = "arca_networks_sg"
    }
}

# Create public subnet
resource "aws_subnet" "public" {
    vpc_id = "${aws_default_vpc.default.id}"
    cidr_block = "192.168.0.0/16"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "arca_networks_public_subnet"
    } 
}


# To establish communication between vpc and the internet
resource "aws_internet_gateway" "arca_networks_IG" {
    vpc_id = "${aws_default_vpc.default.id}"
    tags = { 
        Name = "arca_networks_internet_gateway"
    }
}

# Create a route table allowing access to the IGW.
resource "aws_route_table" "arca_networks_rt_table" {
    vpc_id = "${aws_default_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.arca_networks_IG.id}"
    }
    tags = {
        Name = "arca_networks_route_table"
    }
}

# Associate route table to subnet
resource "aws_route_table_association" "public-subnet" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.arca_networks_rt_table.id}"
}


resource "aws_instance" "arca_server" {
    ami = "ami-0b69ea66ff7391e80"
    instance_type = "t2.micro"
    key_name = "AWS_KEY"
    vpc_security_group_ids = ["${aws_security_group.arca_networks_sg.id}"]
    subnet_id = "${aws_subnet.public.id}"
    tags = {
        Name = "arca_server_instance"
    }
}

