#!/usr/bin/env bash
set -e

if [[ -z $1 || "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Restore a GPG key that was backed up by backup.sh\n\n"
    printf "Usage: restore.sh KEYID [SECUREDIR] [BACKUPDIR]\n"
    exit 1
fi

key_id=$1
SECUREDIR=${2:-secure}
BACKUPDIR=${3:-secure/backup}

if [[ ! -d $BACKUPDIR ]]; then
    printf "\`%s' does not exist\n" "$BACKUPDIR"
    exit 1
fi

export GNUPGHOME="$SECUREDIR/gnupg-home"
(umask 077; mkdir -p "$GNUPGHOME")

gpg --import "$BACKUPDIR/$key_id.public.asc"
gpg --import "$BACKUPDIR/$key_id.private.asc"
gpg --import "$BACKUPDIR/$key_id.private-subkeys.asc"
