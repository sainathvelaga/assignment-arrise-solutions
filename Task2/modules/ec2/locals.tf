locals {
  protected_instances = {
    for name, cfg in var.instances : name => cfg if cfg.prevent_destroy == true
  }

  standard_instances = {
    for name, cfg in var.instances : name => cfg if cfg.prevent_destroy == false
  }
}