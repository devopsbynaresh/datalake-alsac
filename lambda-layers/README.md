# GCM Data Extractor Lambda Layers

AWS Lambdas allow the idea of Layers to be applied to your code.  This is most often used for library deployment, and two layers are used by this project.

## Layers in use

### AWS Data Wrangler

The first layer is [AWS Data Wrangler](https://github.com/awslabs/aws-data-wrangler), a [publicly available](https://github.com/awslabs/aws-data-wrangler/releases) layer.  While the core functionality of AWS Data Wrangler is not used by this project, this layer provides Pandas and PyArrow (two required data processing libraries) in a small enough footprint to be used by AWS Lambda.

### Common

The second layer is a custom-built common code library for the Google API and AWS required libraries (Google API Python Client, OAuth Client, AWS Boto3).

### Facebook

The third layer is a custom-built code library for the Facebook Business API and its dependences.

## Custom Layer creation

The `create_lambda_layer.bat` batch script can be used to build custom layers in subfolders of this project; it defaults to the `common` layer, as that is the only one currently.  This script requires Docker to be installed and running, as the libraries themselves require a specific Linux image matching the Lambda runtime to be used.

Each layer requires a `requirements.txt` file for the libraries to load.  When the batch script is run, it will update `freeze.txt` with the installed libraries and create a ZIP file containing the layer in the appropriate subfolder. 

Keep in mind that when you create a Lambda Layer, the code files must be executable (`chmod -R 744`) in order to be deployed properly.

## Deployment

AWS Lambdas Layers are deployed by Terraform.
