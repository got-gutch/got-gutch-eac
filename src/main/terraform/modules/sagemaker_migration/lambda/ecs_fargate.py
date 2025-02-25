import boto3

ecs_client = boto3.client('ecs')

def create_task_definition():
    response = ecs_client.register_task_definition(
        family='data-copy-task',
        networkMode='awsvpc',
        containerDefinitions=[
            {
                'name': 'data-copy-container',
                'image': 'amazonlinux',  # Use a suitable image
                'essential': True,
                'entryPoint': ['sh', '-c'],
                'command': [
                    'mkfs -t ext4 /dev/xvdf && mkfs -t ext4 /dev/xvdg && '
                    'mkdir -p /mnt/source && mkdir -p /mnt/target && '
                    'mount /dev/xvdf /mnt/source && mount /dev/xvdg /mnt/target && '
                    'rsync -a /mnt/source/ /mnt/target/ && '
                    'umount /mnt/source && umount /mnt/target && '
                    'shutdown -h now'
                ],
                'mountPoints': [
                    {
                        'sourceVolume': 'source-volume',
                        'containerPath': '/dev/xvdf',
                        'readOnly': False
                    },
                    {
                        'sourceVolume': 'target-volume',
                        'containerPath': '/dev/xvdg',
                        'readOnly': False
                    }
                ]
            }
        ],
        volumes=[
            {
                'name': 'source-volume',
                'host': {
                    'sourcePath': '/dev/xvdf'
                }
            },
            {
                'name': 'target-volume',
                'host': {
                    'sourcePath': '/dev/xvdg'
                }
            }
        ],
        requiresCompatibilities=['FARGATE'],
        cpu='256',
        memory='512'
    )
    return response['taskDefinition']['taskDefinitionArn']


def create_fargate_service(cluster_name, task_definition_arn, subnet_id, security_group_id):
    response = ecs_client.create_service(
        cluster=cluster_name,
        serviceName='data-copy-service',
        taskDefinition=task_definition_arn,
        desiredCount=1,
        launchType='FARGATE',
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': [subnet_id],
                'securityGroups': [security_group_id],
                'assignPublicIp': 'ENABLED'
            }
        }
    )
    return response['service']['serviceArn']

def main():
    cluster_name = 'your-cluster-name'
    subnet_id = 'your-subnet-id'
    security_group_id = 'your-security-group-id'

    task_definition_arn = create_task_definition()
    service_arn = create_fargate_service(cluster_name, task_definition_arn, subnet_id, security_group_id)

    print(f'Task Definition ARN: {task_definition_arn}')
    print(f'Service ARN: {service_arn}')

if __name__ == '__main__':
    main()