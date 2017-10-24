#!/usr/bin/env bash
set -e

if [[ -z $1 || "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Export your GPG keys to unencrypted files\n\n"
    printf "Usage: export.sh KEYID [SECUREDIR] [EXPORTDIR]\n"
    exit 1
fi

function log {
    local msg="\e[34m${1}%s\e[0m\n"
    shift
    # shellcheck disable=SC2059
    printf "$msg" "$@"
}

key_id=$1
SECUREDIR=${2:-secure}
EXPORTDIR=${3:-$SECUREDIR/export}

if [[ ! -d $SECUREDIR ]]; then
    printf "\`%s' does not exist\n" "$SECUREDIR"
    exit 1
fi

export GNUPGHOME="$SECUREDIR/gnupg-home"
(umask 077; mkdir -p "$EXPORTDIR")

log "Exporting private keys"
gpg --armor --output "$EXPORTDIR/$key_id.private.asc" \
    --export-options export-backup --export-secret-keys "$key_id"

log "Exporting public keys"
gpg --armor --output "$EXPORTDIR/$key_id.public.asc" --export "$key_id"


log "Generating revocation certificate"
revcert_path="$EXPORTDIR/$key_id-revocation-certificate.asc"
[[ -e "$revcert_path" ]] && mv "$revcert_path" "$revcert_path.bak"
gpg --command-fd 0 --status-fd 2 --no-tty \
    --armor --output "$EXPORTDIR/$key_id-revocation-certificate.asc" \
    --gen-revoke "$key_id" 2>/dev/null << EOF
y
0
Using revocation certificate that was generated when key $key_id was first created.
It is very likely that I have lost access to the private key.

y
EOF
[[ -e "$revcert_path.bak" ]] && rm "$revcert_path.bak"
exit 0
