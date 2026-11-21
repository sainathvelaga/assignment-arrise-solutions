
# Task 4 - Least-Privilege IAM Policy for CI

## Overview

For this task, I created a custom IAM policy for the `ci` user from Task 3.

The goal was to give the CI pipeline only the permissions it needs to perform its deployment workflow. Instead of attaching a broad managed policy such as `PowerUserAccess`, I wrote a policy that limits access to specific AWS resources.

The CI pipeline needs to perform three main tasks:

1. Push Docker images to a specific Amazon ECR repository.
2. Register a new ECS task definition and deploy it to a specific ECS service.
3. Read build artifacts from a specific S3 bucket.

## Permissions Included

### 1. Amazon ECR

The policy allows the CI pipeline to authenticate with ECR and push Docker images.

It includes:
- `ecr:GetAuthorizationToken`
- `ecr:BatchCheckLayerAvailability`
- `ecr:InitiateLayerUpload`
- `ecr:UploadLayerPart`
- `ecr:CompleteLayerUpload`
- `ecr:PutImage`

The image upload permissions are restricted to the `my-ci-app` repository.

The authorization token action uses `"Resource": "*"` because AWS requires this for ECR authentication.

### 2. Amazon ECS

The policy allows the pipeline to register a new task definition, inspect task definitions and services, and update the specified ECS service.

It includes:
- `ecs:RegisterTaskDefinition`
- `ecs:DescribeTaskDefinition`
- `ecs:DescribeServices`
- `ecs:UpdateService`

These permissions are restricted to the specified task-definition family and ECS service.

### 3. IAM PassRole

ECS task definitions can reference IAM roles for task execution and application permissions.

The pipeline therefore needs `iam:PassRole` for the required ECS task roles.

I deliberately restricted this permission to two specific role ARNs and added a condition requiring the receiving service to be `ecs-tasks.amazonaws.com`.

This prevents the CI user from passing arbitrary IAM roles to unrelated AWS services.

### 4. Amazon S3

The pipeline needs to download build artifacts from one S3 bucket.

It receives:
- `s3:ListBucket` on the specific bucket.
- `s3:GetObject` on objects inside that bucket.

The policy does not grant permission to upload, overwrite or delete objects.

## Permissions Deliberately Left Out

I avoided adding permissions that are not required for the deployment workflow.

| Permission or access | Why I left it out |
|---|---|
| `PowerUserAccess` | It grants much broader access than this pipeline needs. |
| `AdministratorAccess` | The CI pipeline should never have unrestricted AWS administration access. |
| `iam:CreateUser` and `iam:CreateRole` | The pipeline does not need to manage IAM identities or roles. |
| `iam:AttachRolePolicy` | It should not be able to modify IAM permissions. |
| General `iam:PassRole` | Passing arbitrary roles could allow privilege escalation. |
| `ecr:DeleteRepository` | The pipeline only needs to push images, not delete repositories. |
| `ecs:DeleteService` | The pipeline should deploy to the existing service, not delete it. |
| `ecs:CreateCluster` | Cluster management is outside the deployment requirement. |
| `s3:PutObject` | The pipeline only needs to read build artifacts. |
| `s3:DeleteObject` | It should not be able to delete build artifacts. |
| Access to all S3 buckets | Access is limited to the designated artifact bucket. |
| Access to all ECR repositories | Image push permissions are limited to one repository. |

## Why Least Privilege Matters

Giving a CI pipeline excessive permissions creates unnecessary security risks.

For example, if CI credentials are accidentally exposed, an attacker could potentially use those permissions to access or modify AWS resources.

By restricting the policy to the required repository, ECS service, task roles and artifact bucket, the impact of compromised credentials is reduced.

I also avoided granting general IAM administration permissions to the CI user.

## Conclusion

This policy follows the principle of least privilege.

The CI user can authenticate with ECR, push an image to the designated repository, register a task definition, update the designated ECS service, and read build artifacts from the specified S3 bucket.

It cannot administer IAM, delete the ECS service, modify S3 artifacts or access unrelated repositories and buckets.

The policy should be tested with the actual CI deployment workflow to confirm that no additional permissions are needed.