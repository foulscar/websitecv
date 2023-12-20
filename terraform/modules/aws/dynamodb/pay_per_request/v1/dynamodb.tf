// ---
// Create the DynamoDB Table
// ---

resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key

  // Set range key if provided
  range_key = var.range_key != "" ? var.range_key : null

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  // Add range key configuration if provided
  dynamic "attribute" {
    for_each = var.range_key != "" ? [var.range_key] : []
    content {
      name = attribute.value
      type = var.range_key_type
    }
  }
}
