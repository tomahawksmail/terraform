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


