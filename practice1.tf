provider  "aws" {
    region     = "us-east-2"
    access_key = "AKIAZF2ONWCF37HKQASIFGHA"
    secret_key = "Cn3b+56ACYRuXqegBnf2hrdOut9LLhaUALIKHANPchVGiI0"
}

resource "aws_instance" "myfirstserver" {
    ami                 = "ami-0443305dabd4be2bc"
    instance_type       = "t2.micro"
    tags                =  {
        name            = "karthik"
    }
}
