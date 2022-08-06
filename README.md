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

```sh
[remote_state_profile]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE1
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY1
[environment_profile]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE2
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY2
```

## _Create a new project_
- mkdir <projectname>
- touch <main.tf>
- terraform plan
- terraform apply


