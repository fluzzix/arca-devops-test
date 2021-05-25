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
    description = "This firewall allows SSH and HTTP"
    vpc_id = "${aws_default_vpc.arca_networks_vpc.id}"
 
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
    vpc_id = "${aws_default_vpc.arca_networks_vpc.id}"
    cidr_block = "192.168.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "arca_networks_pub_sub"
    } 
}


# To establish communication between vpc and the internet
resource "aws_internet_gateway" "arca_network_gateway" {
    vpc_id = "${aws_default_vpc.arca_networks_vpc.id}"
    tags = { 
        Name = "arca_network_gateway"
    }
}

# Create a route table allowing access to the IGW.
resource "aws_route_table" "arca_networks_rt_table" {
    vpc_id = "${aws_default_vpc.arca_networks_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.arca_networks_gateway.id}"
    }
    tags = {
        Name = "arca_networks_rt_table"
    }
}

# Associate route table to subnet
resource "aws_route_table_association" "public-subnet" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.arca_networks_rt_table.id}"
}


resource "aws_instance" "ec2" {
    ami = "ami-03a115bbd6928e698"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.arca_networks_sg.id}"]
    subnet_id = "${aws_subnet.public.id}"
    tags = {
        Name = "ec2_instance"
    }
}

