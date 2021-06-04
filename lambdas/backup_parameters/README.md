# Daily Parameter Backup Lambda Function

## Overview

This Lambda function automatically copies any parameters in SSM Parameter Store that are *not* SecureString parameters into the the Disaster Recovery region. This Lambda function is triggered daily, and by default it will copy those parameters to us-west-2.

## Terraform

This Lambda function is included as part of the Terraform `infrastructure` stack.
