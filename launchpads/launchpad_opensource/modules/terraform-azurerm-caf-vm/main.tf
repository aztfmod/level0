
locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags    = merge(var.tags, local.module_tag)
  vm_name = "${var.prefix}${var.name}"
}

