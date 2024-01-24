# websitecv

This is a 3-tier serverless website portfolio:
- It is deployed on AWS via Terraform Cloud
- Version Controlled IAC, CICD, and multi-account/stages using Terraform Modules
- The web files within the S3 bucket use a different pipeline (GitHub Actions) for pushing front-end code without triggering Terraform Cloud
- Caches CloudWatch Metrics and allows users to see them with a refresh/invalidation rate of one hour via the website
- Contains DNS Records for using a third-party email service

## FrontEnd

##### Technologies:
- Basic HTML & CSS
- HTMX AJAX used in nav.js for single-page navigation
  - Injects HTML pages fetched from CloudFront into a main content wrapper
- MarkedD for the blog page
  - Converts markdown files into HTML
- Formspree.io acts as the middleman between my contact forms and my emails
- Fetches metric data from API Gateway for the metrics page
  - 1 hour refresh rate of CloudWatch metrics

## BackEnd

##### Technologies:
- GitHub/GitHub Actions for version control and CICD
- Terraform Cloud for automatic deployments
  - Triggered by changes in the /Terraform directory
  - Uses Terraform Modules and separate AWS Accounts/Roles for different stages/environments
- AWS Route53 as the DNS Resolver for the root domain, subdomains, and mailing records
  - The "Main" account hosts the root domain and mailing records, as well as nameservers pointing to other Hosted Zones for subdomains
  - Each stage account hosts a different subdomain ( {stage}.corbingrossen.me, api.{stage}.corbingrossen.me )
  - Remember, each stage is a separate Terraform Module, so module variables and outputs get used for pointing Name Servers
- AWS S3 for hosting the static web files
  - GitHub Actions pushes to this when a change in the HTML/{stage} directory is detected
- AWS CloudFront as the CDN
  - The GitHub Actions Pipeline invalidates this when triggered
- AWS API Gateway
  - A public HTTP API used as a proxy:
    - Triggers a Lambda function that retrieves data from the private REST API
  - A private REST API:
    - Triggers a Lambda function that retrieves data from DynamoDB
    - Uses a cache with a 1 hour TTL
    - The cache gets invalidated as well by the lambda function triggered by EventBridge
- AWS EventBridge/EventBridge Scheduler
  - Uses a rule that triggers every hour
  - Triggers a Lambda function that grabs metrics from CloudWatch, pushes them to DynamoDB, and then invalidates the private REST API cache
