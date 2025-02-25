import boto3
import json
from user_profile import ODDWUserProfile
from space import ODDWSpace

sagemaker_client = boto3.client('sagemaker')
ec2_client = boto3.client('ec2')

def lambda_handler(event, context):
    source_domain_id = event['source_domain_id']
    target_domain_id = event['target_domain_id']
    user_profile_name = event['user_profile_name']

    # Step 1: Get the specific SageMaker User Profile in the source Domain
    user_profile = sagemaker_client.describe_user_profile(DomainId=source_domain_id, UserProfileName=user_profile_name)
    user_profile_obj = ODDWUserProfile(user_profile_name)

    spaces = sagemaker_client.list_spaces(DomainId=source_domain_id, UserProfileName=user_profile_name)['Spaces']
    for space in spaces:
        space_name = space['SpaceName']
        space_obj = ODDWSpace(space_name)

        ebs_volumes = sagemaker_client.list_ebs_volumes(DomainId=source_domain_id, UserProfileName=user_profile_name, SpaceName=space_name)['Volumes']
        for volume in ebs_volumes:
            volume_id = volume['VolumeId']
            space_obj.ebs_volumes.append(volume_id)

        user_profile_obj.spaces.append(space_obj)

    # Step 2: Re-create the user in the target SageMaker Domain
    user_profile_obj.recreate_in_target_domain(target_domain_id)

    return {
        'statusCode': 200,
        'body': json.dumps('Migration completed successfully')
    }