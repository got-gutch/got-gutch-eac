# got-gutch-eac
The initial Everything As Code repository deploying infrastructure using Terraform

### Requirements

#### PYTHON

| Min Version | Location                      | Download Link                                                                                                                        |
|:------------|:------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| \>=3.9.5    | /c/dev/Python/Python39/python | [Guide](https://www.python.org/downloads/windows/) - [Archive](https://www.python.org/ftp/python/3.9.5/python-3.9.5-embed-amd64.zip) |

![Python Required Modules](/src/site/assets/python_requirements.png "Required Python Modules")

#### AWSCLI

| Min Version | Location                   | Download Link                                                                                                                                 |
|:------------|:---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| \>=2.7.6    | /c/dev/Amazon/AWSCLIV2/aws | [Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - [Archive](https://awscli.amazonaws.com/AWSCLIV2.msi) |

#### TERRAFORM

| Min Version | Location                       | Download Link                              |
|:------------|:-------------------------------|--------------------------------------------|
| \>=1.2.2    | /c/dev/terraform/bin/terraform | [Link](https://www.terraform.io/downloads) |

#### INTELLIJ

| Min Version | Location                                                            | Download Link                                                    |
|:------------|:--------------------------------------------------------------------|------------------------------------------------------------------|
| Community   | /C/Program Files/JetBrains/IntelliJ IDEA Community Edition 2020.1.1 | [Link](https://www.jetbrains.com/idea/download/#section=windows) |

Don't forget to install the AWS, Terraform, and Python plug-ins !

### Create Backend for Terraform

```shell
python bootstrap_create.py
```

### Destroy Backend for Terraform

```shell
python bootstrap_delete.py
```
