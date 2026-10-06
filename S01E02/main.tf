module "gcp_run_function" {
  source        = "./modules/gcp_run_function"
  project_id    = var.project_id
  region        = var.region
  function_name = var.function_name
  runtime       = "dotnet10"
  entry_point   = var.entry_point
  source_dir    = "function_src"
}
