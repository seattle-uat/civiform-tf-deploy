#! /usr/bin/env bash

# CiviForm deployment configuration file.
#
# Copy this file to civiform_config.sh in the same directory and edit the copy.
#
# cp civiform_config.example.sh civiform_config.sh
#
# Configuration variables must be specified in SCREAMING_SNAKE_CASE with the
# "export" keyword preceding them. If the value contains whitespace it must be
# surrounded by quotes. There should be no spaces before or after the equals sign.

#################################################
# Global variables for all CiviForm deployments
#################################################

# REQUIRED
# One of prod or staging.
export CIVIFORM_MODE="staging"

# REQUIRED
# CiviForm server version to deploy.
#
# For dev and staging civiform modes, can be:
# - "latest"
# - A specific snapshot tag from https://hub.docker.com/r/civiform/civiform/tags
# - A version from https://github.com/civiform/civiform/releases, for example "v1.2.3".
# For prod:
# - Should usually be a version from https://github.com/civiform/civiform/releases, 
#   for example "v1.2.3".
# - In the case where you need to quickly deploy a fix, can also be
#   specific snapshot tag from https://hub.docker.com/r/civiform/civiform/tags
export CIVIFORM_VERSION="latest"

# REQUIRED
# Version of the infrastructure to use.
# Needs to be either:
# - Label from https://hub.docker.com/r/civiform/civiform-cloud-deployment if USE_DOCKER=true
# - Commit SHA or tag from https://github.com/civiform/cloud-deploy-infra if USE_DOCKER=false
# - "latest" to use latest version of either docker image or code from the repo, 
#    depending on USE_DOCKER flag.
#
# If deploy version 1.55.0 or later, setting this to the CIVIFORM_VERSION value is
# recommended in order to use the version of the deployment system tested with
# the CiviForm release.
export CIVIFORM_CLOUD_DEPLOYMENT_VERSION="${CIVIFORM_VERSION}"



# Terraform configuration
#################################################

# REQUIRED
# A supported CiviForm cloud provider, lower case.
# "aws" or "azure"
export CIVIFORM_CLOUD_PROVIDER="aws"

# REQUIRED
# The template directory for this deployment.
# For aws, use "cloud/aws/templates/aws_oidc"
# For azure, use "cloud/azure/templates/azure_saml_ses"
export TERRAFORM_TEMPLATE_DIR="cloud/aws/templates/aws_oidc"

# REQUIRED
# The docker repository name for retrieving server images.
export DOCKER_REPOSITORY_NAME="civiform"

# REQUIRED
# The docker user name for retrieving server images.
export DOCKER_USERNAME="civiform"

# REQUIRED
# The authentication protocal used for applicant and trusted intermediary accounts.
# Supported values: "oidc", "saml"
export CIVIFORM_APPLICANT_AUTH_PROTOCOL=""

# OPTIONAL
# When true, deploys Grafana and Prometheus to collect server metrics.
# Disabled by default in order to save costs. We recommend turning this
# on for production instances.
export MONITORING_STACK_ENABLED="false"

# Deployment-specific Civiform configuration
#################################################

# REQUIRED
# A link to an image of the civic entity logo that includes the entity name, to be used in the header for the "Get Benefits" page
export CIVIC_ENTITY_LOGO_WITH_NAME_URL="https://raw.githubusercontent.com/civiform/civiform-staging-deploy/main/logos/civiform-staging-long.png"

# REQUIRED
# A link to an image of the civic entity logo, to be used on the login page
export CIVIC_ENTITY_SMALL_LOGO_URL="https://raw.githubusercontent.com/civiform/civiform-staging-deploy/main/logos/civiform-staging.png"

# OPTIONAL
# A link to an 16x16 of 32x32 pixel favicon of the civic entity,
# in format .ico, .png, or .gif.
export FAVICON_URL="https://civiform.us/favicon.png"

# REQUIRED
# The email address to use for the "from" field in emails sent from CiviForm.
export SENDER_EMAIL_ADDRESS=""

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the program administrator's email, as would happen in prod.
export STAGING_PROGRAM_ADMIN_NOTIFICATION_MAILING_LIST=""

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the trusted intermediary's email, as would happen in prod.
export STAGING_TI_NOTIFICATION_MAILING_LIST=""

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the applicant's email, as would happen in prod.
export STAGING_APPLICANT_NOTIFICATION_MAILING_LIST=""

# REQUIRED
# The domain name for this CiviForm deployment, including the protocol. 
# E.g. "https://civiform.seattle.gov"
export BASE_URL=""

# OPTIONAL
# When set enables demo mode for the civiform application. Should be set for
# staging but not prod. The value is hostname without protocol and should correspond
# BASE_URl. Example: "civiform.seattle.gov"
export STAGING_HOSTNAME=""

# OPTIONAL
# The time zone to be used when rendering any times within the CiviForm
# UI. A list of valid time zone identifiers can be found at:
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
export CIVIFORM_TIME_ZONE_ID="America/Los_Angeles"

# OPTIONAL
# If enabled, allows exporting Prometheus server metrics over HTTP at "/metrics"
# Defaults to false.
# export CIVIFORM_SERVER_METRICS_ENABLED=false

# OPTIONAL
# Whether to add a robots=noindex meta tag, which causes search engines to not list the website.
# This can be removed for production deployments that should be searchable.
export STAGING_ADD_NOINDEX_META_TAG=true

# OPTIONAL
# The number of reverse proxies between the internet and the server.
# This value is used to extract the client IP address from HTTP headers.
# In typical deployments, this value is 1.
# export NUM_TRUSTED_PROXIES=1


###########################################################################
# Template variables for Azure. Skip if deploying to other cloud providers.
###########################################################################

# REQUIRED
# The Azure region to use, must be lower case.
# See https://azure.microsoft.com/en-us/global-infrastructure/geographies
export AZURE_LOCATION="eastus"

# REQUIRED
# The storage account name for the deployment log file (not the application
# server logs). Only letters and numbers allowed.
# e.g. "civiformdeploylogstorage"
export AZURE_LOG_STORAGE_ACCOUNT_NAME=""

# REQUIRED
# The Azure subscription ID for this deployment, used for billing.
export AZURE_SUBSCRIPTION=""

# REQUIRED
# The Azure resource group for this deployment.
export AZURE_RESOURCE_GROUP=""

# REQUIRED
# The AWS account username for sending emails with SES.
export AWS_USERNAME=""

# REQUIRED
# An Azure Storage Account name for storing the SAML keystore secrets.
# Only letters and numbers allowed.
# e.g. "civiformsamlkeystoresecrets"
export SAML_KEYSTORE_ACCOUNT_NAME=""

# REQUIRED
# The Azure key vault for storing application secrets.
# Only letters and numbers allowed.
# e.g. "civiformkeyvault"
export KEY_VAULT_NAME=""

# REQUIRED
# API key for the LoginRadius application. Copy from the LoginRadius dashboard.
export LOGIN_RADIUS_API_KEY=""

# REQUIRED
# URI for retrieving LoginRadius metadata. Copy from the LoginRadius dashboard.
export LOGIN_RADIUS_METADATA_URI=""

# REQUIRED
# App name for CiviForm in LoginRadius. Copy from the LoginRadius dashboard.
export LOGIN_RADIUS_SAML_APP_NAME=""

# REQUIRED
# The name of the application in Azure App Service.
# The Azure public DNS entry for the app will prepend this value.
# Can only consist of lowercase letters and numbers, and must be between 3 and 24
# characters long.
export APPLICATION_NAME=""

# REQUIRED
# The custom domain name for this CiviForm deployment, not including the
# protocol. E.g. "civiform.seattle.gov"
export CUSTOM_HOSTNAME=""



#########################################################################
# Template variables for AWS. Skip if deploying to other cloud providers.
#########################################################################

# REQUIRED
# AWS region where civiform server and supporting infra will be deployed.
# Unofficial list of available regions: https://gist.github.com/colinvh/14e4b7fb6b66c29f79d3
export AWS_REGION="us-east-1"

# REQUIRED
# The name to prefix all resources with.
export APP_PREFIX="my-deploy" # max 19 chars, only numbers, letters, dashes, and underscores

# REQUIRED
# ARN of the SSL certificate that will be used to handle HTTPS traffic. The certiciate
# should be created and validated before the deployment is done. Certificate can be created
# in AWS web console: https://console.aws.amazon.com/acm/home#/certificates/list
# WARNING: certificate needs to be created in the same region as AWS_REGION above, make sure
# select correct region in web AWS console when creating certificate.
export SSL_CERTIFICATE_ARN=""

# REQUIRED
# Number of Civiform server tasks to run. This value can be set to 0 to shutdown servers.
# It can be useful, for example, when server continiously fails on startup: set this to 0
# to shutdown servers while figuring out the error.
export FARGATE_DESIRED_TASK_COUNT=1

# OPTIONAL
# The AWS RDS instance type for the Postgres database. For possible values, see:
# https://github.com/civiform/cloud-deploy-infra/blob/main/cloud/aws/templates/aws_oidc/variable_definitions.json
#
# Changes to this value will result in database downtime. AWS applies the
# requested change during the next maintenance window.
# export POSTGRES_INSTANCE_CLASS="db.t3.micro"

# OPTIONAL
# The storage capacity of the AWS RDS instance in GiB. Note:
#
# - The capacity cannot be decreased after storage has been allocated.
# - Capacity increases of less than 10% are not allowed.
#
# Changes to this value will result in database downtime. AWS applies the
# requested change during the next maintenance window. Storage optimization
# will take 6+ hours, during which further storage modifications are not
# allowed.
# export POSTGRES_STORAGE_GB=5

# OPTIONAL
# Length of the random generated password to use for app_secret_key.
# Some legacy deployments may be using a shorter length, but going forward 64 will be the default.
export RANDOM_PASSWORD_LENGTH=64


# generic-oidc Auth configuration
#################################################

# REQUIRED
# Which auth provider to use for applicants to login.
# If set to a non-disabled value, you must configure the respective auth parameters
export CIVIFORM_APPLICANT_IDP="generic-oidc"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc"
# The name of the OIDC provider. Must be URL-safe.
#
# Gets appended to the auth callback URL, as in:
#   ${BASE_URL}/callback/${APPLICANT_OIDC_PROVIDER_NAME}"
#
# The callback URL may need to be provisioned in the auth provider for applicants.
export APPLICANT_OIDC_PROVIDER_NAME="OidcClient"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc"
# The discovery metadata URI provideded by the OIDC provider.
# Usually ends in .well-known/openid-configuration
export APPLICANT_OIDC_DISCOVERY_URI="https://civiform-staging.us.auth0.com/.well-known/openid-configuration"

# OPTIONAL
# The type of OIDC flow to execute, and how the data is encoded.
# See https://auth0.com/docs/authenticate/protocols/oauth#authorization-endpoint
export APPLICANT_OIDC_RESPONSE_MODE="form_post"
export APPLICANT_OIDC_RESPONSE_TYPE="id_token token"

# OPTIONAL
# Any additional claims to request, in addition to the default scopes "openid profile email"
export APPLICANT_OIDC_ADDITIONAL_SCOPES=""

# OPTIONAL
# If your OIDC provider provides the user's language preference,
# provide the profile field it's returned in.
export APPLICANT_OIDC_LOCALE_ATTRIBUTE=""

# OPTIONAL
# The name of the profile field where the user's email is stored.
# Defaults to "email"
export APPLICANT_OIDC_EMAIL_ATTRIBUTE="email"

# OPTIONAL
# The name of the profile field where the user's name is stored.
# If there is only one name field(the display name) use APPLICANT_OIDC_FIRST_NAME_ATTRIBUTE.
# If the name is split into multiple fields, use the APPLICANT_OIDC_MIDDLE_NAME_ATTRIBUTE
# and APPLICANT_OIDC_LAST_NAME_ATTRIBUTE as necessary.
export APPLICANT_OIDC_FIRST_NAME_ATTRIBUTE="name"
export APPLICANT_OIDC_MIDDLE_NAME_ATTRIBUTE=""
export APPLICANT_OIDC_LAST_NAME_ATTRIBUTE=""

# OPTIONAL
# This setting should *only* be enabled if the applicant identity provider supports the
# id_token_hint parameter in OIDC logout requests.
#
# ADFS: supported
# Auth0: supported
# IDCS: supported
# Login.gov: not supported
# Okta: required
#
# export APPLICANT_OIDC_ENHANCED_LOGOUT_ENABLED="false"

# OPTIONAL
# Identity provider to use to authenticate and authorize admins.
# Valid values are "adfs" and "generic-oidc-admin". Default is "adfs".
# export CIVIFORM_ADMIN_IDP="adfs"

# ADFS and Azure AD configuration
# More information on https://docs.civiform.us/contributor-guide/developer-guide/authentication-providers
#########################################################################################################

# REQUIRED
# The discovery metadata URI provideded by the ADFS provider.
# Usually ends in .well-known/openid-configuration
export ADFS_DISCOVERY_URI="https://civiform-staging.us.auth0.com/.well-known/openid-configuration"

# OPTIONAL
# Should be set to "allatclaims" for ADFS and empty value for Azure AD.
export ADFS_ADDITIONAL_SCOPES="allatclaims"

# OPTIONAL
# Should be set to "group" for ADFS and "groups" for Azure AD.
export AD_GROUPS_ATTRIBUTE_NAME="group"

# OPTIONAL
# The ADFS group name for specifying CiviForm admins. If using Azure AD this is
# the group's object ID
export ADFS_ADMIN_GROUP=""

# REQUIRED if CIVIFORM_ADMIN_IDP="generic-oidc-admin"
# The name of the OIDC provider. Must be URL-safe.
#
# Gets appended to the auth callback URL, as in:
#   ${BASE_URL}/callback/${ADMIN_OIDC_PROVIDER_NAME}"
#
# The callback URL may need to be provisioned in the auth provider.
# export ADMIN_OIDC_PROVIDER_NAME=""

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc-admin"
# The discovery metadata URI provideded by the OIDC provider for admins.
# Usually ends in .well-known/openid-configuration
# export ADMIN_OIDC_DISCOVERY_URI=""

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc-admin"
# The type of OIDC flow to execute, and how the data is encoded.
# See https://auth0.com/docs/authenticate/protocols/oauth#authorization-endpoint
# export ADMIN_OIDC_RESPONSE_MODE="form_post"
# export ADMIN_OIDC_RESPONSE_TYPE="id_token token"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc-admin"
#
# Set to "true" if the identity provider should protect against CSRF attacks
# by setting the "state" parameter.
# export ADMIN_OIDC_USE_CSRF="true"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc-admin"
#
# The name of the attribute that holds the list of groups/roles associated with
# the account.
# export ADMIN_OIDC_ID_GROUPS_ATTRIBUTE_NAME=""

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc-admin"
#
# The value of the group/role that must be present for the account to be
# considered an administrator.
# export ADMIN_OIDC_ADMIN_GROUP_NAME=""

# OPTIONAL if CIVIFORM_APPLICANT_IDP="generic-oidc-admin"
#
# Additional scopes should be retrieved as part of the request to the identity
# provider. If present, should be space-separated values.
# export ADMIN_OIDC_ADDITIONAL_SCOPES=""

# OPTIONAL
# This setting should *only* be enabled if the admin identity provider supports the
# id_token_hint parameter in OIDC logout requests.
#
# ADFS: supported
# Auth0: supported
# IDCS: supported
# Login.gov: not supported
# Okta: required
#
# export ADMIN_OIDC_ENHANCED_LOGOUT_ENABLED="false"
