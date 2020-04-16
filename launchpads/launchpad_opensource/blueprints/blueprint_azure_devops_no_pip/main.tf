locals {
  blueprint_tag = {
    "blueprint" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.blueprint_tag)
}


