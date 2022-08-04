locals {
  enabled = module.this.enabled
}

resource "aws_lakeformation_resource" "default" {
  count = local.enabled ? 1 : 0

  arn      = var.s3_bucket_arn
  role_arn = var.role_arn
}

resource "aws_lakeformation_data_lake_settings" "default" {
  count = local.enabled ? 1 : 0

  catalog_id              = var.catalog_id
  admins                  = var.admin_arn_list
  trusted_resource_owners = var.trusted_resource_owners

  dynamic "create_database_default_permissions" {
    for_each = var.database_default_permissions
    content {
      permissions = create_database_default_permissions.value.permissions
      principal   = create_database_default_permissions.value.principal
    }
  }

  dynamic "create_table_default_permissions" {
    for_each = var.table_default_permissions
    content {
      permissions = create_table_default_permissions.value.permissions
      principal   = create_table_default_permissions.value.principal
    }
  }
}

resource "aws_lakeformation_lf_tag" "default" {
  for_each = local.enabled ? var.lf_tags : {}

  catalog_id = var.catalog_id

  key    = each.key
  values = each.value

  depends_on = [aws_lakeformation_data_lake_settings.default]
}

resource "aws_lakeformation_resource_lf_tags" "default" {
  for_each = local.enabled ? var.resources : {}

  catalog_id = var.catalog_id

  dynamic "database" {
    for_each = (each.key == "database") ? ["true"] : []
    content {
      name       = each.value.name
      catalog_id = try(each.value.catalog_id, null)
    }
  }

  dynamic "table" {
    for_each = (each.key == "table") ? ["true"] : []
    content {
      database_name = each.value.database_name
      name          = each.value.name
      wildcard      = try(each.value.wildcard, null)
      catalog_id    = try(each.value.catalog_id, null)
    }
  }

  dynamic "table_with_columns" {
    for_each = (each.key == "table_with_columns") ? ["true"] : []
    content {
      database_name = each.value.database_name
      name          = each.value.name
      wildcard      = try(each.value.wildcard, null)
      column_names  = try(each.value.column_names, null)

      catalog_id            = try(each.value.catalog_id, null)
      excluded_column_names = try(each.value.excluded_column_names, null)
    }
  }

  dynamic "lf_tag" {
    for_each = each.value.tags
    content {
      key   = aws_lakeformation_lf_tag.default[lf_tag.key].key
      value = lf_tag.value
    }
  }

  depends_on = [aws_lakeformation_data_lake_settings.default]
}
