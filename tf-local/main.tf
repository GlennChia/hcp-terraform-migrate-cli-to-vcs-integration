resource "random_string" "this" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "random_output" {
  description = "Random output generated"
  value       = random_string.this.result
}
