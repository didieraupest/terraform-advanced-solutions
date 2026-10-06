module "gcp_run_function" {
  source = "../S01E02/modules/gcp_run_function"
  
  project_id = var.project_id
  region     = var.region
  function_name = "invoice-function"
  runtime = "dotnet8"
  entry_point = "main"
  source_dir = "../S01E02/code/"
}