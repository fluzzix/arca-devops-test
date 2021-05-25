# ARCA COMMUNICATE DEVOPS TEST

## Requirements

Download and install the following packages:

- Docker software (https://docs.docker.com/get-docker/)
- Docker-compose utility (https://docs.docker.com/compose/install/)
- Git (https://git-scm.com/downloads)
- Terraform (https://www.terraform.io/downloads.html)
- Python (https://www.python.org/downloads/release/python-382/)
- AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Start Development

```bash
# Kindly clone the repo
$ git clone https://github.com/fluzzix/arca-devops-test.git

# Change directory
$ cd arca-devops-test

```

---

## TEST 1 - Docker And Bash

### Running

```bash
# Change directory to arca-docker folder
$ cd arca-docker

# Make file executable
$ chmod +x start_and_stop.sh

# To start containers
$ ./start_and_stop.sh start

# To stop containers
$ ./start_and_stop.sh stop

```

---

## TEST 2 - Terraform And Python

### Running

```bash
# Change directory to arca-infras folder
$ cd arca-infras

# Configure AWS by executing below command and give the required details
$ aws configure

# Change AWS_KEY in main.tf
key_name = "AWS_KEY"

# To initiate terraform
$ terraform init

# To provision resources
$ terraform apply

```

## TEST 2B - Terraform And Python

### Requirements
