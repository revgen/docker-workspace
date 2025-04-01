# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PATH="${HOME}/.local/bin:/opt/apache-maven:$PATH"
alias ll='ls -ahl'

"${HOME}/.local/bin/welcome-banner"

# [[ -e /opt/oracle-cli/lib/python3.10/site-packages/oci_cli/bin/oci_autocomplete.sh]]
# source /root/lib/oracle-cli/lib/python3.10/site-packages/oci_cli/bin/oci_autocomplete.sh

. "${HOME}/.bash_env"
