#! /usr/bin/env bash

# This file contains shell functions for working with the mainline project
# checkout. Almost all commands in this deployment repo delegate their
# implementation to code in the mainline CiviForm repo's cloud/ subtree.
#
# Which git revision the scripts should use for that depends on the docker image
# tag the user specifies in the command.

#######################################
# Delegates a command from a specified path to the main CiviForm repo at a 
# specific git revision.
# Expects arguments to include "--tag=<tag name>" for resolving which revsion
# to check out for the command. Then passes all arguments to the delegated
# command in the main repo.
# Arguments:
#   @: arguments for the command, must include --tag= flag
# Globals:
#   CMD_NAME: the name of the command to run
#######################################
function checkout::exec_delegated_command_at_path() {
  if [[ -z "${CMD_NAME_PATH}" ]]; then
    out::error "CMD_NAME must be set for delegated command."
    exit 1
  fi

  checkout::get_image_tag "$@"
  checkout::ensure_initialized
  if [[ "${USE_LATEST_GIT_COMMIT}" ]]; then
    checkout::at_main
  else
    checkout::from_image_tag "${IMAGE_TAG}"
  fi

  (
    cd checkout
    exec "${CMD_NAME_PATH}" "$@"
  )
}

#######################################
# Delegates a command from the shared bin to the main CiviForm repo at a 
# specific git revision.
# Expects arguments to include "--tag=<tag name>" for resolving which revsion
# to check out for the command. Then passes all arguments to the delegated
# command in the main repo.
# Arguments:
#   @: arguments for the command, must include --tag= flag
# Globals:
#   CMD_NAME: the name of the command to run
#######################################
function checkout::exec_delegated_command() {
  CMD_NAME_PATH="cloud/shared/bin/${CMD_NAME}" \
    checkout::exec_delegated_command_at_path "$@"
}

#######################################
# Retrieves the image tag from a list of aguments.
# Exits with an error message if --tag flag is not found.
# Arguments:
#   @: An arguments list
# Globals:
#   Sets the IMAGE_TAG variable
#######################################
function checkout::get_image_tag() {
  for i in "$@"; do
    case "${i}" in
      --tag=*)
        export IMAGE_TAG="${i#*=}"
        return
        ;;
    esac
  done

  out::error "--tag argument is required"
  exit 1
}

#######################################
# Sets the checkout directory to the commit corresponding
# to the provided image tag.
# Arguments:
#   1: The image tag for the server version.
#######################################
function checkout::from_image_tag() {
  local image_tag="${1}"
  if ! commit_sha=$(exec bin/lib/resolve_git_commit_sha_from_image.py --tag="${image_tag}"); then
    exit $?
  fi
  checkout::at_sha "${commit_sha}"
}

#######################################
# Checks if the checkout directory is initialized and initializes it
# if it isn't.
#######################################
function checkout::ensure_initialized() {
  printf "Ensuring checkout is initialized... "

  if cat checkout/.git/info/sparse-checkout 2> /dev/null | grep -q "\/cloud"; then
    echo "done"
  else
    echo "not initialized"
    checkout::initialize
  fi
}

#######################################
# Initializes the checkout directory by initializing a git repo, setting its
# origin to the mainline CiviForm repo, and configuring a sparse checkout
# that only contains the cloud/ directory.
#######################################
function checkout::initialize() {
  printf "Initializing checkout... "

  rm -rf checkout
  mkdir checkout

  pushd checkout > /dev/null

  git init --initial-branch=main
  git remote add origin http://github.com/civiform/civiform
  git config core.sparseCheckout true

  echo "/cloud" >> .git/info/sparse-checkout
  echo "/bin" >> .git/info/sparse-checkout

  git pull --quiet origin main

  popd > /dev/null
  echo "done"
}

#######################################
# Sets the checkout directory to the commit at the provided SHA.
# Pulls the latest git revisions first.
# Arguments:
#   1: The commit SHA to sync to.
#######################################
function checkout::at_sha() {
  local commit_sha="${1}"
  printf "Setting checkout to ${commit_sha}... "

  pushd checkout > /dev/null

  git pull --quiet origin main
  git checkout --quiet "${commit_sha}"

  popd > /dev/null
  echo "done"
}

#######################################
# Pulls the latest git revisions for the checkout directory from the mainline
# CiviForm repo.
#######################################
function checkout::at_main() {
  printf "Syncing checkout directory to latest commit... "

  pushd checkout > /dev/null

  git checkout --quiet main
  git pull --quiet origin main

  popd > /dev/null
  echo "done"
}
