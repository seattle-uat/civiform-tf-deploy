#! /usr/bin/env bash

# CiviForm deployment configuration file.
#
# Copy this file to civiform_config.sh in the same directory and edit the copy.
#
# cp civiform_config.example.sh civiform_config.sh
#
# Configuration variables must be specified in SCREAMING_SNAKE_CASE with the
# "export" keyword preceding them. All values must be quoted as strings. There
# should be no spaces before or after the equals sign.

#################################################
# Global variables for all CiviForm deployments
#################################################

# REQUIRED
# One of prod, staging, or dev.
export CIVIFORM_MODE="staging"

# REQUIRED
# CiviForm server version to deploy.
#
# For dev and staging civiform modes, can be "latest". For prod, must be a version from
# https://github.com/civiform/civiform/releases, for example "v1.2.3".
export CIVIFORM_VERSION="v2.26.0"

# REQUIRED
# Version of the infrastructure to use.
# Needs to be either:
# - Label from https://hub.docker.com/r/civiform/civiform-cloud-deployment if USE_DOCKER=true
# - Commit sha from https://github.com/civiform/cloud-deploy-infra if USE_DOCKER=false
# - "latest" to use latest version of either docker image or code from the repo,
#    depending on USE_DOCKER flag.
#
# Using "latest" is recommended.
#export CIVIFORM_CLOUD_DEPLOYMENT_VERSION="latest"
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
export CIVIFORM_APPLICANT_AUTH_PROTOCOL="oidc"

# Deployment-specific Civiform configuration
#################################################

# REQUIRED
# A link to an image of the civic entity logo, to be used on the login page
export CIVIC_ENTITY_SMALL_LOGO_URL="https://raw.githubusercontent.com/seattle-civiform/civiform-deploy-tf/main/logos/civiform-small-logo.png"

# OPTIONAL
# A link to an 16x16 of 32x32 pixel favicon of the civic entity,
# in format .ico, .png, or .gif.
export FAVICON_URL="https://seattle.gov/favicon.ico"

# REQUIRED
# The email address to use for the "from" field in emails sent from CiviForm.
export SENDER_EMAIL_ADDRESS="civiform.staging@seattle.gov"

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the program administrator's email, as would happen in prod.
export STAGING_PROGRAM_ADMIN_NOTIFICATION_MAILING_LIST="civiform.staging@seattle.gov"

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the trusted intermediary's email, as would happen in prod.
export STAGING_TI_NOTIFICATION_MAILING_LIST="civiform.staging@seattle.gov"

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the applicant's email, as would happen in prod.
export STAGING_APPLICANT_NOTIFICATION_MAILING_LIST="civiform.staging@seattle.gov"

# OPTIONAL
# If this is a staging deployment and this variable is set to true, a robots
# noindex metadata tag is added to the CiviForm pages. This causes the staging
# site to not be listed on search engines.
export STAGING_ADD_NOINDEX_META_TAG=true

# REQUIRED
# The domain name for this CiviForm deployment, including the protocol.
# E.g. "https://civiform.seattle.gov"
export BASE_URL="https://civiformtest.seattle.gov"
export STAGING_HOSTNAME="civiformstage.seattle.gov"

# OPTIONAL
# The time zone to be used when rendering any times within the CiviForm
# UI. A list of valid time zone identifiers can be found at:
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
export CIVIFORM_TIME_ZONE_ID="America/Los_Angeles"

# OPTIONAL
# If enabled, allows exporting Prometheus server metrics over HTTP at "/metrics"
# Defaults to false.
export CIVIFORM_SERVER_METRICS_ENABLED=false

# Don't deploy of Prometheus and Graphana
export MONITORING_STACK_ENABLED=false

#################################################
# Template variables for: aws_oidc
#################################################

# REQUIRED
export AWS_REGION="us-west-2"

# OPTIONAL
# Database size
export POSTGRES_INSTANCE_CLASS="db.t3.micro"

# OPTIONAL
# Number of days to keep backups
export POSTGRES_BACKUP_RETENTION_DAYS=5

# REQUIRED
# The name to prefix all resources with.
export APP_PREFIX="cf-test" # max 19 chars, only numbers, letters, dashes, and underscores

export SSL_CERTIFICATE_ARN="arn:aws:acm:us-west-2:405662711265:certificate/c62046c2-ac1c-4131-8a1d-3c91d2b81a21"
export FARGATE_DESIRED_TASK_COUNT=1
export ECS_SCALE_TARGET_MIN_CAPACITY=1

# REQUIRED
# Which auth provider to use for applicants to login.
# If set to a non-disabled value, you must configure the respective auth parameters
export CIVIFORM_APPLICANT_IDP="idcs"

# generic-oidc Auth configuration
#################################################

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc"
# The name of the OIDC provider. Must be URL-safe.
# Gets appended to the auth callback URL.
export APPLICANT_OIDC_PROVIDER_NAME="OidcClient"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc"
# The discovery metadata URI provideded by the OIDC provider.
# Usually ends in .well-known/openid-configuration
export APPLICANT_OIDC_DISCOVERY_URI="https://idcs-f582fefb879b4db5a88a370e8f2f6013.identity.oraclecloud.com/.well-known/openid-configuration"
export IDCS_DISCOVERY_URI="https://idcs-f582fefb879b4db5a88a370e8f2f6013.identity.oraclecloud.com/.well-known/openid-configuration"

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
# The name of the profile field where the user's name is stored.
# If there is only one name field(the display name) use APPLICANT_OIDC_FIRST_NAME_ATTRIBUTE.
# If the name is split into multiple fields, use the APPLICANT_OIDC_MIDDLE_NAME_ATTRIBUTE
# and APPLICANT_OIDC_LAST_NAME_ATTRIBUTE as necessary.
export APPLICANT_OIDC_FIRST_NAME_ATTRIBUTE="name"
export APPLICANT_OIDC_MIDDLE_NAME_ATTRIBUTE=""
export APPLICANT_OIDC_LAST_NAME_ATTRIBUTE=""

# REQUIRED
export APPLICANT_REGISTER_URI="https://qalogin.seattle.gov:12443/#/registration?appName=CIVIFORM_TEST"
export APPLICANT_OIDC_OVERRIDE_LOGOUT_URL="https://qalogin.seattle.gov:12443/#/logout?appName=CIVIFORM_TEST"
export APPLICANT_OIDC_POST_LOGOUT_REDIRECT_PARAM=""
export APPLICANT_OIDC_PROVIDER_LOGOUT=true

# ADFS and Azure AD configuration
# More information on https://docs.civiform.us/contributor-guide/developer-guide/authentication-providers
#########################################################################################################

# REQUIRED
# The discovery metadata URI provideded by the ADFS provider.
# Usually ends in .well-known/openid-configuration
export ADFS_DISCOVERY_URI="https://login.microsoftonline.com/78e61e45-6beb-4009-8f99-359d8b54f41b/v2.0/.well-known/openid-configuration"

# OPTIONAL
# Should be set to "allatclaims" for ADFS and empty value for Azure AD.
export ADFS_ADDITIONAL_SCOPES=""

# OPTIONAL
# Should be set to "group" for ADFS and "groups" for Azure AD.
export AD_GROUPS_ATTRIBUTE_NAME="groups"

# OPTIONAL
# The ADFS group name for specifying CiviForm admins. If using Azure AD this is
# the group's object ID
export ADFS_ADMIN_GROUP="5909e7f3-3f4c-4ad1-93e8-17e6ba6ab8a3"

#################################################
# Additional settings
#################################################

# Caching
export VERSION_CACHE_ENABLED=true
export PROGRAM_CACHE_ENABLED=true
export QUESTION_CACHE_ENABLED=true

# Evolutions
export DATABASE_APPLY_DESTRUCTIVE_CHANGES=true

# Analytics
export MEASUREMENT_ID="G-HXM0Y35TGE"

# ESRI
export ESRI_FIND_ADDRESS_CANDIDATES_URLS="https://gisdata.seattle.gov/cosgis/rest/services/locators/AddressPoints/GeocodeServer/findAddressCandidates, https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_URLS="https://gisdata.seattle.gov/server/rest/services/COS/Seattle_City_Limits/MapServer/1/query"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_LABELS="Seattle"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_IDS="Seattle"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_ATTRIBUTES="CITYNAME"
export ESRI_WELLKNOWN_ID_OVERRIDE="2926"

# Additional Customization
export FILE_UPLOAD_ALLOWED_FILE_TYPE_SPECIFIERS="image/*,.pdf,.xlsx"

# Language Settings
export CIVIFORM_SUPPORTED_LANGUAGES="en-US, am, zh-TW, ko, so, es-US, tl, vi"
export CIVIFORM_APPLICANT_ENABLED_LANGUAGES="en-US, am, zh-TW, ko, so, es-US, tl, vi"

# Feature Flags
export ADMIN_OIDC_ENHANCED_LOGOUT_ENABLED=true
export APPLICANT_OIDC_ENHANCED_LOGOUT_ENABLED=true
export NEW_APPLICANT_URL_SCHEMA_ENABLED=true
