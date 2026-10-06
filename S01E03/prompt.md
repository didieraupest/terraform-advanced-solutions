You are a senior Terraform and Google Cloud Platform engineer.
Your task is to create a production-ready Terraform module that deploys a .NET application as a Google Cloud Function on GCP, as part of a migration from Azure to GCP.
The solution must be deterministic, minimal, maintainable, and directly usable. Do not introduce architecture or resources that are not required for the stated requirements.

1. Objective
Create a reusable Terraform module that:
Deploys a GCP Cloud Function running a .NET application.
Uses an HTTP trigger so the function can be invoked from outside GCP.
Creates the required Cloud Storage bucket used to host the function source code.
Uploads/packages the application source code appropriately for the Cloud Function deployment.
Creates all GCP resources and IAM permissions required for the function to operate.
Allows the function to be deployed independently for the following environments:
- dev
- uat
- pprd
- prod
Uses West Europe as the default GCP region.
Uses only GCP resources. Do not provide Azure, AWS, or multi-cloud abstractions.

2. Cloud Function generation
Use the current recommended Google Cloud Functions architecture supported by Terraform.
Prefer Cloud Functions 2nd generation unless there is a concrete technical reason to use 1st generation.
The function must:
Run a .NET application.
Be triggered through HTTP.
Be deployable using Terraform.
Have a configurable function name.
Have a configurable runtime.
Have a configurable region, defaulting to europe-west1.
Have configurable memory and timeout with sensible defaults.
Use a dedicated service account where appropriate rather than relying on overly broad default permissions.
Expose the minimum IAM permissions required to invoke the HTTP function.
Do not add API Gateway, Cloud Run, Load Balancers, Pub/Sub, Eventarc, Secret Manager, VPC connectors, databases, monitoring infrastructure, or other services unless they are strictly required by the Cloud Function deployment itself.

3. Source code and Cloud Storage
The Terraform solution must create the Cloud Storage bucket required to store the function deployment source.
The bucket must:
Be created by Terraform.
Have a deterministic name based on the project/function/environment where appropriate.
Use the configured GCP region/location.
Enable appropriate protection against accidental deletion where practical.
Follow GCP and Terraform best practices.
Avoid unnecessary bucket configuration.
The function source archive should be generated/uploaded using Terraform-compatible mechanisms.
Do not assume that the source code already exists in a manually created bucket.
Make the source path configurable.
If Terraform needs to package the .NET application into a ZIP archive, implement this using Terraform's standard mechanisms rather than requiring an external deployment script.

4. Terraform module structure
Create a reusable Terraform module with this structure:
.
├── environment/
│   ├── environment.dev.tfvars
│   ├── environment.uat.tfvars
│   ├── environment.pprd.tfvars
│   └── environment.prod.tfvars
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── providers.tf
├── README.md
│
└── modules/
    └── cloud-function/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── versions.tf
        └── README.md
If you determine that a simpler structure is more appropriate, prefer the simpler structure and explain why. Do not create additional files or directories without a concrete reason.

5. Environment configuration
There must be no environment subdirectories.
Do not create:
environment/dev/
environment/uat/
environment/pprd/
environment/prod/
Instead, all environment variable files must be directly under:
environment/
Use exactly these filenames:
environment/environment.dev.tfvars
environment/environment.uat.tfvars
environment/environment.pprd.tfvars
environment/environment.prod.tfvars
Each environment file must contain only the values that are environment-specific.
Avoid duplicating Terraform resource definitions between environments.

6. Variables
Expose only variables that are genuinely useful for reusing the module.
At minimum, consider:
GCP project ID
environment
region
function name
runtime
source directory/path
memory
timeout
maximum instances, if appropriate
service account configuration, if appropriate
For every variable:
Provide a description.
Define an appropriate type.
Provide a sensible default when a default is appropriate.
Avoid unnecessary variables.
Add validation where it materially improves correctness.
Do not expose implementation details as variables unless there is a real use case.

7. Provider configuration
Use the official Google Terraform provider.
Pin the Terraform and Google provider versions to sensible compatible versions.
Do not use deprecated provider syntax.
Do not configure credentials directly in Terraform code.
Assume authentication is handled externally through standard Google Cloud authentication mechanisms.
The default region must be:
europe-west1
Do not confuse the human-readable name "West Europe" with the actual GCP region identifier.

8. IAM and security
Follow the principle of least privilege.
Create only the IAM permissions required for:
deploying the Cloud Function,
accessing the function's source,
executing the function,
invoking the HTTP function.
For public HTTP invocation, explicitly configure the required invoker permission.
Do not grant broad project-level roles when a resource-level permission is sufficient.
Do not create public access to the Cloud Storage bucket.
Do not expose credentials, service account keys, or secrets in Terraform code.

9. Naming
Use deterministic and Terraform-friendly resource names.
Environment-specific resources should be distinguishable between:
- dev
- uat
- pprd
- prod

Avoid random suffixes unless GCP requires uniqueness.
Use Terraform naming conventions consistently:
Terraform resource names: snake_case
GCP resource names: lowercase and GCP-compatible
Variables: snake_case
Outputs: snake_case

10. Outputs
Expose useful outputs only.
At minimum, consider outputs for:
Cloud Function name
Cloud Function URI
Cloud Function region
source bucket name
service account email, if one is created
Do not expose outputs that provide no useful information to consumers of the module.

11. Terraform best practices
Follow standard Terraform best practices:
Keep resources logically separated.
Use variables instead of hardcoded environment-specific values.
Use locals where they improve readability.
Avoid unnecessary locals and abstractions.
Avoid duplicated resource definitions.
Use explicit dependencies only when Terraform cannot infer them.
Avoid provisioners unless there is no reasonable Terraform-native alternative.
Use for_each or count only when they genuinely simplify the implementation.
Keep the module focused on one responsibility.
Make the module idempotent.
Ensure a second terraform apply does not unnecessarily recreate resources.
Avoid deprecated Terraform/GCP resources.
Use lifecycle rules only when there is a concrete reason.

12. Validation
The generated solution must be syntactically valid Terraform.
Include commands showing how to validate and test the configuration:
terraform fmt -check
terraform init
terraform validate
terraform plan
If possible, also explain how to test each environment using the corresponding .tfvars file.
For example:
terraform plan -var-file="environment/environment.dev.tfvars"

13. Documentation
Create a concise README.md explaining:
What the module does.
Prerequisites.
Required GCP APIs.
Authentication assumptions.
Module inputs.
Module outputs.
How to deploy each environment.
How the .NET source code is packaged.
How the HTTP endpoint is exposed.
Any important assumptions or limitations.
Include a minimal usage example.

14. Required output format
Return the solution as a complete file-by-file implementation.
For every generated file, use this format:
### path/to/file.tf
followed by the complete contents of that file in a Terraform code block.
For example:
### modules/cloud-function/main.tf
# complete file contents
Do not omit sections with comments such as:
# implementation omitted
# add your configuration here
Every file must contain its complete implementation.
After the files, provide:
Architecture summary
Briefly explain the resources created and how they interact.
Assumptions
List only assumptions that were necessary to implement the solution.
Validation
List the exact Terraform commands that should be executed to validate the implementation.

15. Important constraints
Do NOT:
introduce Azure resources;
introduce AWS resources;
use Cloud Run instead of Cloud Functions;
add API Gateway unless strictly required;
add unnecessary networking infrastructure;
add unnecessary databases, queues, schedulers, or monitoring systems;
create one Terraform configuration per environment;
create environment subdirectories;
hardcode project IDs;
hardcode credentials;
create service-account keys;
over-engineer the module;
provide multiple alternative architectures;
leave implementation placeholders;
invent requirements that are not stated above.
When there are multiple technically valid implementations, select one implementation based on current GCP and Terraform best practices and use it consistently throughout the solution.
Before producing the final files, internally verify that:
All referenced Terraform variables exist.
All referenced resources exist.
Resource dependencies are valid.
Provider/resource versions are compatible.
The Cloud Function can actually be deployed from the configured source.
The HTTP trigger is correctly configured.
Required IAM permissions are present.
The source bucket is correctly connected to the function deployment.
All four .tfvars files use the same module/configuration structure.
There are no unnecessary resources or abstractions.
The final result must be a minimal, complete, internally consistent Terraform implementation for GCP Cloud Functions running a .NET application.
