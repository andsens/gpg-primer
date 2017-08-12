#!/usr/bin/env bash
set -e

if [[ "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Remove a directory created by create-secure-dir.sh\n\n"
    printf "Usage: destroy-secure-dir.sh [MOUNTPOINT]\n"
    exit 1
fi

if [[ $(id -u) != 0 ]]; then
    printf "Must be root to run\n"
    exit 1
fi

mountpoint=${1:-secure}
ramdisk_path=$(cat "$mountpoint/ramdisk_path")

printf "Unmounting the volume\n"
umount "$mountpoint"

printf "Deleting the mountpoint\n"
rmdir "$mountpoint"

printf "Ejecting the disk\n"
diskutil eject "$ramdisk_path"
