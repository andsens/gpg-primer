#!/usr/bin/env bash
set -e

if [[ -z $1 || -z $2 ]]; then
    printf "Usage: backup.sh SECUREDIR KEYID\n"
    exit 1
fi

SECUREDIR=$1
key_id=$2

if [[ ! -d $SECUREDIR ]]; then
    printf "\`%s' does not exist\n" "$SECUREDIR"
    exit 1
fi

export GNUPGHOME="$SECUREDIR/gnupg-home"
export BACKUPDIR="$SECUREDIR/backup"
(umask 077; mkdir -p "$BACKUPDIR")

printf "Backing up private keys\n"
gpg --armor --output "$BACKUPDIR/$key_id.private.asc" --export-secret-keys "$key_id"

printf "Backing up public keys\n"
gpg --armor --output "$BACKUPDIR/$key_id.public.asc" --export "$key_id"

printf "Generating revocation certificate\n"
gpg --command-fd 0 --status-fd 2 --no-tty \
    --armor --output "$BACKUPDIR/$key_id-revocation-certificate.asc" \
    --gen-revoke "$key_id" 2>/dev/null << EOF
y
0
Using revocation certificate that was generated when key $key_id was first created.
It is very likely that I have lost access to the private key.

y
EOF
