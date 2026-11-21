
# Task 3 - AWS IAM and Cross-Account Role Access

## 1. Architecture

This task implements an AWS IAM architecture across two AWS accounts.

### Account A

- group1 contains engine and ci.
- group2 contains Ram and Sainath.
- roleA provides administrative access to AWS services except IAM.
- roleB can assume only roleC in Account B.

### Account B

- roleC provides access to one designated S3 bucket.
- roleC trusts only the exact roleB ARN from Account A.
- The S3 bucket has public access blocked.

## 2. IAM Users and Groups

### group1

Contains:
- engine
- ci

These are service/programmatic identities. They should not have console login profiles.

### group2

Contains:
- Ram
- Sainath

These are human identities and require console access and CLI access as specified in the assignment.

For production environments, prefer IAM Identity Center and short-lived credentials instead of long-lived IAM user access keys.

## 3. IAM Roles

### roleA

roleA has an Allow statement for all AWS actions and an explicit Deny statement for all IAM actions.

The explicit Deny takes precedence over Allow.

Therefore:
- Non-IAM AWS actions are allowed, subject to other AWS restrictions.
- IAM actions are denied.

### roleB

roleB has permission to call sts:AssumeRole only on the Account B roleC ARN.

It does not have direct S3 permissions.

### roleC

roleC trusts only the exact roleB ARN from Account A.

Its permissions allow S3 actions only on the designated bucket and its objects.

## 4. Cross-Account Trust: Root ARN vs Specific Role ARN

Trusting the Account A root ARN:

arn:aws:iam::ACCOUNT_A_ID:root

does not mean that only the root user can assume the role.

It delegates trust to the AWS account. Principals in that account still need permission to assume the role.

Trusting a specific role ARN is narrower:

arn:aws:iam::ACCOUNT_A_ID:role/roleB

This limits the trusted principal to that role.

For this task, roleC trusts the exact roleB ARN.

## 5. Production Best Practices

### Avoid long-lived IAM user access keys

Long-lived access keys can be leaked, copied, or misused.

Prefer:

- IAM roles for applications running on AWS.
- OIDC federation for CI/CD systems.
- IAM Identity Center for human users.
- Short-lived AWS STS credentials.
- Regular credential rotation and removal of unused credentials.

### Least privilege

Grant only the permissions required for a task.

roleB can assume only roleC.

roleC can access only the designated S3 bucket.

Public access to the bucket is blocked.

## 6. Testing

The following tests should be performed:

1. Verify IAM users and group memberships.
2. Assume roleB from Account A.
3. Assume roleC using roleB credentials.
4. Verify roleC can list objects in the designated S3 bucket.
5. Verify roleC can upload, retrieve, and delete an object.
6. Verify roleA can perform a non-IAM action.
7. Verify roleA is denied an IAM action such as iam:ListUsers.

## 7. Account Setup and Validation

The Terraform configuration uses two AWS CLI profiles:

- account-a
- account-b

The AWS caller identity should be checked for both providers before deployment.

A single-account simulation can validate IAM policy behavior and the role-assumption sequence, but it does not demonstrate genuine cross-account isolation.

The final cross-account deployment must be tested using two separate AWS accounts.