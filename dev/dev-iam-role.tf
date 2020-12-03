module "dev-iam-role" {
    source = "../"
    iam_user = "DEV"
    iam_role = ["DeveloperAccessRole", "DevopsAccessRole"]
}

output "role" {
    value = module.dev-iam-role.role
}