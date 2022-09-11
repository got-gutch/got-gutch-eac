from python_terraform import *
import os
import boto3
import shutil
import stat


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


def onerror(func, path, exc_info):
    """
    Error handler for ``shutil.rmtree``.

    If the error is due to an access error (read only file)
    it attempts to add write permission and then retries.

    If the error is for another reason it re-raises the error.

    Usage : ``shutil.rmtree(path, onerror=onerror)``
    """
    # Is the error an access error?
    if not os.access(path, os.W_OK):
        os.chmod(path, stat.S_IWUSR)
        func(path)
    else:
        raise


def clean_layer(working_dir):
    working_files = [
        working_dir + "\\tfplan.json",
        working_dir + "\\terraform.tfstate",
        working_dir + "\\terraform.tfstate.backup",
        working_dir + "\\.terraform.lock.hcl"
    ]
    for file_to_remove in working_files:
        if os.path.isfile(file_to_remove):
            print('Deleting file ' + os.path.basename(file_to_remove))
            os.remove(file_to_remove)
    dir_to_remove = working_dir + '\\.terraform'
    if os.path.isdir(dir_to_remove):
        print('Deleting dir .terraform')
        shutil.rmtree(dir_to_remove, onerror=onerror)


def destroy_backend(working_dir, variables):
    tf = Terraform(working_dir=working_dir, variables=variables)
    tf.destroy(capture_output='no', no_color=IsNotFlagged, force=IsNotFlagged, auto_approve=True)
    clean_layer(tf.working_dir)


def get_backend_config(tf_output):
    return f"""
terraform {{
  backend "s3" {{
    bucket         = "{tf_output['backend']['value']['config']['bucket']}"
    key            = "{tf_output['backend']['value']['config']['bucket'].removesuffix('-state-bucket') + '/terraform.tfstate'}"
    region         = "{tf_output['backend']['value']['config']['region']}"
    dynamodb_table = "{tf_output['backend']['value']['config']['dynamodb_table']}"
    role_arn       = "{tf_output['backend']['value']['config']['role_arn']}"
  }}
}}
"""


def switch_to_workspace(layer_name):
    tf = Terraform(get_layer_home(layer_name), get_layer_vars())
    wksp_cmd = 'workspace'
    list_rc, list_stdout, list_stderr = tf.cmd(wksp_cmd, 'list')
    if list_rc == 0:
        if layer_name not in list_stdout.split():
            print(f"Creating {layer_name} " + wksp_cmd)
            new_rc, new_stdout, new_stderr = tf.cmd(wksp_cmd, 'new', layer_name)
            if list_rc != 0:
                raise TerraformCommandError(new_rc, wksp_cmd, new_stdout, new_stderr)
        else:
            print(f"Using {layer_name} " + wksp_cmd)
            select_rc, select_stdout, select_stderr = tf.cmd(wksp_cmd, 'select', layer_name)
            if select_rc != 0:
                raise TerraformCommandError(select_rc, wksp_cmd, select_stdout, select_stderr)
    else:
        raise TerraformCommandError(list_rc, wksp_cmd, list_stdout, list_stderr)


def create_backend_config(layer_name):
    tf = Terraform(get_layer_home('bootstrap'), get_layer_vars())
    with open(get_layer_home(layer_name) + '\\backend.tf', 'w') as f:
        f.write(get_backend_config(tf.output()))
    print('Backend config written to ' + get_layer_home(layer_name) + '\\backend.tf')


def apply_layer(layer_name):
    create_backend_config(layer_name)
    tf = Terraform(get_layer_home(layer_name), get_layer_vars())
    init_rc, stdout, stderr = tf.init()
    if init_rc != 0:
        raise TerraformCommandError(init_rc, 'init', stdout, stderr)
    print('Layer initialized')
    switch_to_workspace(layer_name)
    apply_rc, stdout, stderr = tf.apply(skip_plan=False, var=None, auto_approve=IsFlagged, input=False,
                                        capture_output='No')
    if apply_rc != 0:
        raise TerraformCommandError(apply_rc, 'apply', stdout, stderr)
    return tf.output()


def destroy_layer(layer_name):
    create_backend_config(layer_name)
    tf = Terraform(get_layer_home(layer_name), get_layer_vars())
    tf.init(capture_output='no')
    print('Layer initialized')
    switch_to_workspace(layer_name)
    tf.destroy(capture_output='no', no_color=IsNotFlagged, force=IsNotFlagged, auto_approve=IsFlagged)
    clean_layer(tf.working_dir)
