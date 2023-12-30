// ---
// Use the IONOS Developer API to Change the Domain Name Servers
// ---

data "aws_secretsmanager_secret" "ionos_developer_key" {
  arn = var.IONOS_KEY_ARN
}

data "aws_secretsmanager_secret_version" "ionos_developer_key_ver" {
  secret_id = data.aws_secretsmanager_secret.ionos_developer_key.id
}

resource "null_resource" "get_ionos_data" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -X 'GET' \n
      'https:/api.hosting.ionos.com/domains/v1/domainitems/${var.IONOS_DOMAIN_ID}/nameservers' \n
      -H 'accept: application/json' \n
      -H 'X-Api-Key: ${data.aws_secretsmanager_secret_version.ionos_developer_key_ver.secret_string}'
    EOT
  }
}
