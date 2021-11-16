data "aws_ssm_parameter" "user_default_password" {
  name = "/${var.unit}/${var.env}/ssm/iac/secrets/GOOGLEWORKSPACE_USER_DEFAULT_PASSWORD"
}

# resource "googleworkspace_schema" "birthday" {
#   schema_name = "birthday"

#   fields {
#     field_name = "birthday"
#     field_type = "DATE"
#   }

# }

resource "random_string" "temp_password" {
  length           = 16
  upper            = true
  lower            = true
  number           = true
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  min_lower        = 2
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
  # keepers = {
  #   rotation = var.rotation_id
  # }
}

resource "googleworkspace_user" "user" {
  primary_email                 = var.user.primary_email
  password                      = sha1(random_string.temp_password.result)
  hash_function                 = var.user.hash_function
  change_password_at_next_login = var.user.change_password_at_next_login

  name {
    given_name  = var.user.given_name
    family_name = var.user.family_name
  }

  dynamic "emails" {
    for_each = length(var.user.emails) > 0 ? var.user.emails : []
    content {
      address     = emails.value.address
      type        = emails.value.type
      custom_type = emails.value.type == "custom" ? emails.value.custom_type : null
    }
  }

  dynamic "phones" {
    for_each = length(var.user.phones) > 0 ? var.user.phones : []
    content {
      type    = phones.value.type
      value   = phones.value.value
      primary = phones.value.primary
    }
  }

  dynamic "addresses" {
    for_each = length(var.user.addresses) > 0 ? var.user.addresses : []
    content {
      # country        = addresses.value.country
      # country_code   = addresses.value.country
      # locality       = addresses.value.locality
      # po_box         = addresses.value.po_box
      # postal_code    = addresses.value.postal_code
      # region         = addresses.value.region
      # street_address = addresses.value.street_address
      # type           = addresses.value.type
      formatted            = addresses.value.formatted
      primary              = addresses.value.primary
      source_is_structured = addresses.value.source_is_structured
      type                 = addresses.value.type

    }
  }

  dynamic "external_ids" {
    for_each = length(var.user.external_ids) > 0 ? var.user.external_ids : []
    content {
      type  = external_ids.value.type
      value = external_ids.value.value
    }
  }

  dynamic "organizations" {
    for_each = length(var.user.organizations) > 0 ? var.user.organizations : []
    content {
      cost_center = organizations.value.cost_center
      department  = organizations.value.department
      description = organizations.value.description
      # full_time_equivalent = organizations.value.full_time_equivalent
      primary = organizations.value.primary
      title   = organizations.value.title
      type    = organizations.value.type
    }
  }

  dynamic "relations" {
    for_each = length(var.user.relations) > 0 ? var.user.relations : []
    content {
      type  = relations.value.type
      value = relations.value.value
    }
  }

  dynamic "locations" {
    for_each = length(var.user.locations) > 0 ? var.user.locations : []
    content {
      area          = locations.value.type
      type          = locations.value.type
      building_id   = locations.value.building_id
      floor_name    = locations.value.floor_name
      floor_section = locations.value.floor_section
    }
  }

  aliases        = var.user.aliases
  recovery_email = var.user.recovery_email
  recovery_phone = var.user.recovery_phone

  timeouts {
    create = "60m"
    update = "60m"
  }

  lifecycle {
    ignore_changes = [
      suspended,
      change_password_at_next_login,
      etag
    ]
  }
}
