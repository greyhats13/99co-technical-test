resource "aws_iam_user" "user" {
  count         = length(var.user.account.aws) > 0 ? 1 : 0
  name          = googleworkspace_user.user.primary_email
  path          = var.user.account.aws.path
  force_destroy = var.user.account.aws.force_destroy
  tags = {
    "Name"  = googleworkspace_user.user.name[0].full_name
    "Phone" = googleworkspace_user.user.phones[0].value
    "Employee_ID" = googleworkspace_user.user.external_ids[0].value
    "Cost_Centre" = googleworkspace_user.user.organizations[0].cost_center
    "Department" = googleworkspace_user.user.organizations[0].department
    "Employee_Type" = googleworkspace_user.user.organizations[0].description
    "Job_Title" = googleworkspace_user.user.organizations[0].title
    "Superior" = googleworkspace_user.user.relations[0].value
  }
}
