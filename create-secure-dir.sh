#!/usr/bin/env bash
set -e

# Check out https://github.com/coruus/osx-tmpfs/blob/master/main.go for more

if [[ "$1" == '-h' || "$1" == '--help' ]]; then
    printf "Create a temporary secure directory for sensitive files\n\n"
    printf "Usage: create-secure-dir.sh [NAME]\n"
    exit 1
fi

if [[ $(id -u) != 0 || -z $SUDO_USER || -z $SUDO_UID || -z $SUDO_GID ]]; then
    printf "Must be run via sudo\n"
    exit 1
fi

function log {
    local msg="\e[34m${1}%s\e[0m\n"
    shift
    # shellcheck disable=SC2059
    printf "$msg" "$@"
}

undo=""
trap 'eval "$undo"' ERR EXIT

volname=${1:-secure}
mountpoint="$PWD/$volname"

log "Creating ramdisk"
ramdisk_path=$(hdik -nomount ram://2048)
# hdik outputs trailing spaces and tabs for some reason
ramdisk_path=${ramdisk_path//[[:space:]]}

undo="diskutil eject \"$ramdisk_path\"
$undo"

log "Formatting ramdisk at %s" "$ramdisk_path"
newfs_hfs -v "$volname" -U "$SUDO_UID" -G "$SUDO_GID" -M 700 -P "$ramdisk_path"

log "Creating mountpoint at %s" "$mountpoint"
(umask 077; mkdir "$mountpoint")
undo="rmdir \"$mountpoint\"
$undo"

log "Changing ownership of the mountpoint to %s:%s" "$SUDO_UID" "$SUDO_GID"
chown "$SUDO_UID":"$SUDO_GID" "$mountpoint"

log "Mounting volume to %s" "$mountpoint"
mount_hfs -u "$SUDO_UID" -m 700 -o noatime,nosuid,nobrowse "$ramdisk_path" "$mountpoint"
undo="umount \"$mountpoint\"
$undo"

log "Preventing file system event storage"
mkdir "$mountpoint/.fseventsd"
touch "$mountpoint/.fseventsd/no_log"

log "Removing permissions for group and others"
chmod -R go-rwx "$mountpoint"

log "Hiding contents from the GUI"
chflags -R hidden "$mountpoint"

acl=$(cat <<EOA
user:$SUDO_USER:allow delete,readattr,writeattr,readextattr,writeextattr,\
readsecurity,writesecurity,chown,list,search,add_file,add_subdirectory,\
delete_child,read,write,execute,append,file_inherit,directory_inherit
everyone:deny delete,readattr,writeattr,\
readextattr,writeextattr,readsecurity,writesecurity,\
chown,list,search,add_file,add_subdirectory,delete_child,\
read,write,execute,append,file_inherit,directory_inherit
EOA
)
log "Setting ACL to deny everything for everyone except %s" "$SUDO_USER"
chmod -P -R -E "$mountpoint" <<<"$acl"

log "Telling Spotlight to not index the volume (if it says \"unknown indexing state\" that's ok)"
mdutil -E -i off -d "$mountpoint"

log "Writing instructions for manual cleanup"
printf "%s" "$ramdisk_path" > "$mountpoint/ramdisk_path"
cat > "$mountpoint/CLEANUP" <<EOF
# If destroy-secure-dir.sh does not work,
# these are the commands you need to run:

sudo umount '$mountpoint' && \\
rmdir '$mountpoint' && \\
diskutil eject '$ramdisk_path'
EOF

undo=""
log "\nSecure directory created at \`%s'." "$mountpoint"
log "The directory can be destroyed with ./destroy-secure-dir.sh"
