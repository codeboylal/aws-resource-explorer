#!/bin/bash

# Global Services 
echo "==== Global Services ===="

# S3 Buckets (Global)
echo "S3 Buckets (Global):"
aws s3api list-buckets --query "Buckets[*].[Name, CreationDate]" --output table

# KMS Keys (Global)
echo "KMS Key List (Global):"
aws kms list-keys --query "Keys[*].[KeyId]" --output table

# IAM Users (Global)
echo "IAM Users (Global):"
aws iam list-users --query "Users[*].[UserName, CreateDate]" --output table

# CloudFront Distributions (Global)
echo "CloudFront Distributions (Global):"
aws cloudfront list-distributions --query "DistributionList.Items[*].[Id, DomainName, Status]" --output table

# Route 53 Hosted Zones (Global)
echo "Route 53 Hosted Zones (Global):"
aws route53 list-hosted-zones --query "HostedZones[*].[Name, Id]" --output table

echo ""

# Loop through each regions to find all the services
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "==== Region: $region ===="
    
    # EC2 Instances
    echo "EC2 Instances:"
    aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId, InstanceType, State.Name]" --output table

    # EBS Volumes
    echo "EBS Volumes:"
    aws ec2 describe-volumes --region $region --query "Volumes[*].[VolumeId, Size, State]" --output table

    # RDS Databases
    echo "RDS Databases:"
    aws rds describe-db-instances --region $region --query "DBInstances[*].[DBInstanceIdentifier, DBInstanceClass, DBInstanceStatus]" --output table

    # Lambda Functions
    echo "Lambda Functions:"
    aws lambda list-functions --region $region --query "Functions[*].[FunctionName, Runtime]" --output table

    # ECS Clusters and Fargate Tasks
    echo "ECS Clusters and Fargate Tasks:"
    for cluster in $(aws ecs list-clusters --region $region --query "clusterArns[]" --output text); do
        echo "Cluster: $cluster"
        aws ecs list-tasks --cluster $cluster --region $region --query "taskArns[]" --output table
    done

    # ECR Repositories
    echo "ECR Repositories:"
    aws ecr describe-repositories --region $region --query "repositories[*].[repositoryName, repositoryUri]" --output table

    # VPCs
    echo "VPCs:"
    aws ec2 describe-vpcs --region $region --query "Vpcs[*].[VpcId, CidrBlock, State]" --output table

    # Subnets
    echo "Subnets:"
    aws ec2 describe-subnets --region $region --query "Subnets[*].[SubnetId, CidrBlock, AvailabilityZone]" --output table

    # Security Groups
    echo "Security Groups:"
    aws ec2 describe-security-groups --region $region --query "SecurityGroups[*].[GroupId, GroupName, Description]" --output table

    # Elastic Load Balancers
    echo "Elastic Load Balancers:"
    aws elbv2 describe-load-balancers --region $region --query "LoadBalancers[*].[LoadBalancerName, DNSName, State.Code]" --output table

    # CloudWatch Alarms
    echo "CloudWatch Alarms:"
    aws cloudwatch describe-alarms --region $region --query "MetricAlarms[*].[AlarmName, StateValue]" --output table

    # CloudFormation Stacks
    echo "CloudFormation Stacks:"
    aws cloudformation describe-stacks --region $region --query "Stacks[*].[StackName, StackStatus]" --output table

    # SQS Queues
    echo "SQS Queues:"
    aws sqs list-queues --region $region --query "QueueUrls" --output table

    # SNS Topics
    echo "SNS Topics:"
    aws sns list-topics --region $region --query "Topics[*].TopicArn" --output table

    # DynamoDB Tables
    echo "DynamoDB Tables:"
    aws dynamodb list-tables --region $region --query "TableNames" --output table

    # Step Functions
    echo "Step Functions:"
    aws stepfunctions list-state-machines --region $region --query "stateMachines[*].[name, stateMachineArn]" --output table

    # Elastic Beanstalk Applications
    echo "Elastic Beanstalk Applications:"
    aws elasticbeanstalk describe-applications --region $region --query "Applications[*].[ApplicationName, DateCreated]" --output table

    # Redshift Clusters
    echo "Redshift Clusters:"
    aws redshift describe-clusters --region $region --query "Clusters[*].[ClusterIdentifier, NodeType, ClusterStatus]" --output table

    # SageMaker Endpoints
    echo "SageMaker Endpoints:"
    aws sagemaker list-endpoints --region $region --query "Endpoints[*].[EndpointName, EndpointStatus]" --output table

    # Glue Jobs
    echo "Glue Jobs:"
    aws glue list-jobs --region $region --query "JobNames" --output table

    # Secrets Manager Secrets
    echo "Secrets Manager Secrets:"
    aws secretsmanager list-secrets --region $region --query "SecretList[*].[Name, ARN]" --output table

    # CodePipeline Pipelines
    echo "CodePipeline Pipelines:"
    aws codepipeline list-pipelines --region $region --query "pipelines[*].[name, version]" --output table

    # CodeBuild Projects
    echo "CodeBuild Projects:"
    aws codebuild list-projects --region $region --query "projects" --output table

    # CodeDeploy Applications
    echo "CodeDeploy Applications:"
    aws deploy list-applications --region $region --query "applications" --output table

    # EFS File Systems
    echo "EFS File Systems:"
    aws efs describe-file-systems --region $region --query "FileSystems[*].[FileSystemId, CreationTime, LifeCycleState]" --output table

    # Spacing between regions
    echo ""
done
