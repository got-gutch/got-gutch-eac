from python_terraform import *
import os
import boto3
import shutil


def get_account_id():
    client = boto3.client('sts')
    return client.get_caller_identity()['Account']


def get_layer_home(layer_name):
    layer_home = os.getcwd() + '\\src\\main\\terraform\\layers\\' + layer_name
    if not os.path.isdir(layer_home):
        raise NotADirectoryError(layer_home)
    return layer_home


def get_layer_vars():
    admin_arn = "arn:aws:iam::" + get_account_id() + ":user/administrator"
    return {
        "region": "us-east-1",
        "namespace": "got-gutch",
        "principal_arns": [admin_arn]
    }


def create_backend(working_dir, variables):
    tf = Terraform(working_dir=working_dir, variables=variables)
    tf.fmt(diff=True, capture_output='no')
    tf.init(capture_output='no')
    tf.plan(out="tfplan.json", capture_output='no')
    tf.apply("tfplan.json", var=None, capture_output='no')
    return tf.output()


def destroy_backend(working_dir, variables):
    tf = Terraform(working_dir=working_dir, variables=variables)
    tf.destroy(capture_output='no', no_color=IsNotFlagged, force=IsNotFlagged, auto_approve=True)
    working_files = [
        tf.working_dir + "\\tfplan.json",
        tf.working_dir + "\\terraform.tfstate",
        tf.working_dir + "\\terraform.tfstate.backup",
        tf.working_dir + "\\.terraform.lock.hcl"
    ]
    for file_to_remove in working_files:
        if os.path.isfile(file_to_remove):
            print('Deleting file ' + os.path.basename(file_to_remove))
            os.remove(file_to_remove)
    dir_to_remove = tf.working_dir + '\\.terraform'
    if os.path.isdir(dir_to_remove):
        print('Deleting dir .terraform')
        shutil.rmtree(dir_to_remove)


def get_backend_config(tf_output):
    return f"""
terraform {{
  backend "s3" {{
    bucket         = "{tf_output['backend']['value']['config']['bucket']}"
    region         = "{tf_output['backend']['value']['config']['region']}"
    dynamodb_table = "{tf_output['backend']['value']['config']['dynamodb_table']}"
    role_arn       = "{tf_output['backend']['value']['config']['role_arn']}"
  }}
}}
"""


def create_backend_config(layer_name):
    tf = Terraform(get_layer_home('bootstrap'), get_layer_vars())
    with open(get_layer_home(layer_name) + '\\backend.tf', 'w') as f:
        f.write(get_backend_config(tf.output()))
    print('Backend config written to ' + get_layer_home(layer_name) + '\\backend.tf')
