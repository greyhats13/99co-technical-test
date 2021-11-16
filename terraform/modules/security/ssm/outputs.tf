output "ssm_arn" {
  value    = tomap(
    {
      for ssm_key, ssm in aws_ssm_parameter.ssm : ssm_key => ssm.arn
    }
  )
}

output "ssm_id" {
  value    = tomap(
    {
      for ssm_key, ssm in aws_ssm_parameter.ssm : ssm_key => ssm.id
    }
  )
}