#!/usr/bin/env bash
set -e

if [[ -z $1 || "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Usage: backup.sh KEYID [SECUREDIR] [BACKUPDIR]\n"
    exit 1
fi

key_id=$1
SECUREDIR=${2:-secure}
BACKUPDIR=${3:-secure/backup}

if [[ ! -d $SECUREDIR ]]; then
    printf "\`%s' does not exist\n" "$SECUREDIR"
    exit 1
fi

export GNUPGHOME="$SECUREDIR/gnupg-home"
BACKUPDIR="$SECUREDIR/backup"
(umask 077; mkdir -p "$BACKUPDIR")

printf "Backing up private keys\n"
gpg --armor --output "$BACKUPDIR/$key_id.private.asc" --export-secret-keys "$key_id"

printf "Backing up public keys\n"
gpg --armor --output "$BACKUPDIR/$key_id.public.asc" --export "$key_id"


printf "Generating revocation certificate\n"
revcert_path="$BACKUPDIR/$key_id-revocation-certificate.asc"
[[ -e "$revcert_path" ]] && mv "$revcert_path" "$revcert_path.bak"
gpg --command-fd 0 --status-fd 2 --no-tty \
    --armor --output "$BACKUPDIR/$key_id-revocation-certificate.asc" \
    --gen-revoke "$key_id" 2>/dev/null << EOF
y
0
Using revocation certificate that was generated when key $key_id was first created.
It is very likely that I have lost access to the private key.

y
EOF
[[ -e "$revcert_path.bak" ]] && rm "$revcert_path.bak"
