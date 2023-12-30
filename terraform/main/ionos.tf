// ---
// Use the IONOS Developer API to Change the Domain Name Servers
// ---

data "aws_secretsmanager_secret" "secrets" {
  arn = var.IONOS_KEY_ARN
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

resource "null_resource" "get_ionos_data" {
  provisioner "local-exec" {
    command = "curl -X 'GET' 'https:/api.hosting.ionos.com/domains/v1/domainitems/${var.IONOS_DOMAIN_ID}/nameservers' -H 'accept: application/json' -H 'X-Api-Key: ${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)}'"
  }
}
