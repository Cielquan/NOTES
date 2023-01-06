#!/usr/bin/env bash

# Color variables for output messages
RED='\033[0;31m' # For ERROR messages
GREEN='\033[0;32m' # For SUCCESS messages
ORANGE='\033[0;33m' # For WARNING messages
CYAN='\033[0;36m' # For INFO messages
BLANK='\033[0m' # For resetting colors


# Func for showing usage string
usage_string() {
  echo -e "Usage: $0 [-i <IP address>] [-u <username>]" 1>&2;
}

# Func for showing usage
usage() {
  usage_string
  echo -e "Run $0 -h for more detailed usage."
}

# Func for showing usage help page
help() {
  usage_string
  echo ""
  echo "$0 flags:" && grep " .)\ #" "$0"
  exit 0
}

# Exit func for call errors
exit_flag_err() {
  echo -e "${RED}Please correct set flags/arguments and restart.\n${BLANK}"
  usage
  exit 1
}

# Exit func for errors
exit_err() {
  echo -e "${RED}Please correct the error that occured and restart the script.${BLANK}"
  exit 1
}


# Catching flags
while getopts ":i:u:" flag; do
  case $flag in
    i) # The IP address of the server to ssh into.
      SERVER_IP="${OPTARG}"
      ;;
    u) # The user to login as.
      LOGIN_USER="${OPTARG}"
      ;;
    h) # Shows this help page.
      help
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit_flag_err
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit_flag_err
      ;;
  esac
done


# Check if both flags are set
if ([ -n "${SERVER_IP}" ] && [ -z "${LOGIN_USER}" ]) || ([ -z "${SERVER_IP}" ] && [ -n "${LOGIN_USER}" ]); then
  echo "If one flag is set both are mandatory."
  exit_flag_err
fi


# Let user enter SERVER_IP
if [ -z "${SERVER_IP}" ]; then
  echo "Please enter the server's IP address."
  while read -p "IP address: " SERVER_IP && [ -z "${SERVER_IP}" ] ; do
    echo -e "${RED}ERROR!${BLANK} SERVER_IP could not be received.\n"
  done
fi

# Let user enter LOGIN_USER
if [ -z "${LOGIN_USER}" ]; then
  echo -e "\nPlease enter the name of the user to login with."
  while read -p "User name: " LOGIN_USER && [ -z "${LOGIN_USER}" ] ; do
    echo -e "${RED}ERROR!${BLANK} LOGIN_USER could not be received.\n"
  done
fi



# Generate new rsa key pair on local pc
echo -e "\n${CYAN}INFO${BLANK}: Creating ssh key pair."
if ! ssh-keygen -t rsa -f ~/.ssh/id_rsa_${SERVER_IP} -P ""; then
  exit_err
fi

# Send pub key to server
echo -e "\n${CYAN}INFO${BLANK}:  Sending pub key to server."
if ! cat ~/.ssh/id_rsa_${SERVER_IP}.pub | ssh ${LOGIN_USER}@${SERVER_IP} "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"; then
  echo -e "${RED}ERROR!${BLANK} Key could not be send to server."
  exit_err
fi

# Hardening security on server and restart ssh
echo -e "\n${CYAN}INFO${BLANK}:  Hardening ssh security on server."
if ! ssh -t ${LOGIN_USER}@${SERVER_IP} "sudo sed -i -e 's/.*PasswordAuthentication.*/PasswordAuthentication no/g' -e 's/.*PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config && sudo systemctl reload sshd"; then
  echo -e "${RED}ERROR!${BLANK} Security could not be enhanced."
  exit_err
fi

echo -e "\n${GREEN}done${BLANK}"
read