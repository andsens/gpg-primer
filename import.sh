#!/usr/bin/env bash
set -e

if [[ -z $1 || "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Import a GPG key that was exported by export.sh\n\n"
    printf "Usage: import.sh KEYID [SECUREDIR] [EXPORTDIR]\n"
    exit 1
fi

key_id=$1
SECUREDIR=${2:-secure}
EXPORTDIR=${3:-secure/export}

if [[ ! -d $EXPORTDIR ]]; then
    printf "\`%s' does not exist\n" "$EXPORTDIR"
    exit 1
fi

export GNUPGHOME="$SECUREDIR/gnupg-home"
(umask 077; mkdir -p "$GNUPGHOME")

gpg --import "$EXPORTDIR/$key_id.private.asc"
gpg --import "$EXPORTDIR/$key_id.private-subkeys.asc"
