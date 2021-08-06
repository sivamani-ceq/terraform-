provider "aws" {
    region     = "us-east-1"
    access_key = "AKIAZF2ONWCF5R24IBASIFALIMZ"
    secret_key = "INfesi4Fe4N4d+zLrAJ5m3294XByrpeaxQx0mQZALIKHANO"
}

resource "aws_instance" "my-first-server" {
    ami                 = "ami-0c2b8ca1dad447f8a"
    instance_type       = "t2.micro"
    tags = {
        name = "karthik"
    }
}

resource "aws_vpc" "karthik" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "karthik"
    }
}

resource "aws_internet_gateway" "gw" {
   vpc_id = aws_vpc.karthik.id
}

resource "aws_route_table" "karthik-route-table" {
    vpc_id = aws_vpc.karthik.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        name = "karthik1"
    }
}

resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.karthik.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        name = "karthik-subnet"
    }
}

resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.karthik-route-table.id
}

resource "aws_security_group" "allow_web"  {
    name       = "allow_web_traffic"
    description = "Allow web inbound traffic"
    vpc_id     = aws_vpc.karthik.id

    ingress {
        description        = "https"
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    ingress {
        description       = "http"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description    = "ssh"
        from_port      = 22
        to_port        = 22
        protocol       = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    tags = {
        name = "allow_web"
    } 
}

resource "aws_network_interface" "web-server-nic" {
    subnet_id        = aws_subnet.subnet-1.id
    private_ips      = ["10.0.1.50"]
    security_groups  = [aws_security_group.allow_web.id]
}


resource "aws_instance" "web-server-instance" {
    ami               = "ami-0c2b8ca1dad447f8a"
    instance_type     = "t2.micro"
    availability_zone = "us-east-1a"
    key_name          = "cloudeq"
    network_interface  {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }

}
