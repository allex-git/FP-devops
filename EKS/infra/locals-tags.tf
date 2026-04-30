locals {
  common_tags = merge(
    var.tags,
    {
      created_by = "Allex-DevOps"
    }
  )
}