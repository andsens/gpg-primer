#!/usr/bin/env bash
set -e

if [[ -z $1 || -z $2 || "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Generate a GPG master and encryption subkey\n\n"
    printf "Usage: generate-master.sh NAME EMAIL [SECUREDIR]\n"
    exit 1
fi

key_name=$1
key_email=$2
SECUREDIR=${3:-secure}

if [[ ! -d $SECUREDIR ]]; then
    printf "\`%s' does not exist\n" "$SECUREDIR"
    exit 1
fi

export GNUPGHOME="$SECUREDIR/gnupg-home"
(umask 077; mkdir -p "$GNUPGHOME")

printf 'Generating master key for "%s" <%s>\n' "$key_name" "$key_email"
gpg_output=$(gpg --command-fd 0 --status-fd 2 --no-tty \
    --gen-key --batch 2>&1 << EOF
Key-Type: RSA
Key-Length: 4096
Key-Usage: ,
Name-Real: $key_name
Name-Email: $key_email
Expire-Date: 0
%commit
EOF
)
key_id=$(sed -n 's/.*gpg: key \([A-F0-9]\{8\}\) marked as ultimately trusted.*/\1/p' <<<"$gpg_output")
printf "Key ID is %s\n" "$key_id"

printf "Generating encryption subkey\n"
gpg --command-fd 0 --status-fd 2 --no-tty \
    --edit-key "$key_id" addkey 2>/dev/null << EOF
6
2048
5y
save
EOF
