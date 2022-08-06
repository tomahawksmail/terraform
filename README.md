# TERRAFORM
## _install and upgrade_
- terraform version
- download terraform***.zip
- unzip terraform***.zip
- rm terraform***.zip
- sudo mv terraform***.zip /bin/

## _Credentials for AWS_
- Create AWS user with Programmatic access and Administrator's permissions (Access key & Secret key)
- Credentials file ~/.aws/credentials
- or export env
- export AWS_ACCESS_KEY_ID=MyAccesskey
- export AWS_SECRET_ACCESS_KEY=Mysecretkey
- or export aws profile
- export AWS_PROFILE=remote_state_profile
as example
```sh
[remote_state_profile]
aws_access_key_id     = AKI**************LE1
aws_secret_access_key = wJa**************EY1
[environment_profile]
aws_access_key_id     = AKI**************LE2
aws_secret_access_key = wJa**************EY2
```

## _Create a new project_
- mkdir <projectname>
- touch <main.tf>
- terraform plan
- terraform apply

  [Использование разных AWS профилей для бэкенда и деплоя](https://notessysadmin.com/terraform-different-aws-profiles-for-s3-backend-and-environment)
  
## _Main commands_
terraform validate
terraform fmt
terraform plan
terraform apply
terraform apply –auto-approve

terraform show
terraform state
terraform state list
terraform state show <instatce’s_name>

## _Variables_
  ```sh
  variables.tf
______________
variable “ami_id” { 
  type = string
  default = "default value" 
  description = "some description" 
}
  ```
 ```sh
  example
______________
variable “ami_id” { 
  type = string 
  default = "AMI_ID" 
  description = "ID of the AMI to be used. For example ami-02354e95b39ca8dec" 
}

  ```
 ```sh
  Вариант объявление переменных и их приоритетность снизу вверх

terraform.tfvars
terraform.tfvars.json
*.auto.tfvars
*.auto.tfvars.json
- var as CLI arguments
-var-file as CLI arguments
  ```
  
Передача значения переменной через CLI
terraform plan -var 'ami_id=ami-02354e95b39ca8dec' 
terraform apply -var 'ami_id=ami-02354e95b39ca8dec'

  
## _Data Sources_
```sh
Синтаксис
data “<type>” “<local_name>” {
	<argument> = <value>
	<argument> = <value>
}
  ```
    
  ```sh
Example
Добавим в main.tf (или datasources.tf)

data "aws_ami" "amzn-ami" {
 most_recent = true
 owners = ["amazon"]
 filter {
 name = "name"
 values = ["amzn2-ami-*-gp2"]
 }
 filter {
 name = "virtualization-type"
 values = [
 "hvm"]
 } 
 filter {
 name = "architecture"
 values = ["x86_64"]
 }
}

resource "aws_instance" "alpha" {
   ami = data.aws_ami.amzn-ami.image_id
   instance_type = "t2.micro"
   tags = {
 	Name = "Quickstart-alpha"
 	Purpose = "Education"
 }
}

  ```
