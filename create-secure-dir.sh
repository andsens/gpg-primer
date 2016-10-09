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

undo=""
trap 'eval "$undo"' ERR EXIT

volname=${1:-secure}
mountpoint="$PWD/$volname"

printf "Creating ramdisk\n"
ramdisk_path=$(hdik -nomount ram://2048)
# hdik outputs trailing spaces and tabs for some reason
ramdisk_path=${ramdisk_path//[[:space:]]}

undo="diskutil eject \"$ramdisk_path\"
$undo"

printf "Formatting ramdisk at %s\n" "$ramdisk_path"
newfs_hfs -v "$volname" -U "$SUDO_UID" -G "$SUDO_GID" -M 700 -P "$ramdisk_path"

printf "Creating mountpoint at %s\n" "$mountpoint"
(umask 077; mkdir "$mountpoint")
undo="rmdir \"$mountpoint\"
$undo"

chown "$SUDO_UID":"$SUDO_GID" "$mountpoint"

printf "Mounting volume\n" "$mountpoint"
mount_hfs -u "$SUDO_UID" -m 700 -o noatime,nosuid,nobrowse "$ramdisk_path" "$mountpoint"
undo="diskutil unmount \"$mountpoint\"
$undo"

printf "Setting permissions on mountpoint\n"
chmod -P -R go-rwx "$mountpoint"
chflags -P -R -v -v hidden "$mountpoint"
acl="user:$SUDO_USER:allow delete,readattr,writeattr"
acl="$acl,readextattr,writeextattr,readsecurity,writesecurity"
acl="$acl,chown,list,search,add_file,add_subdirectory,delete_child"
acl="$acl,read,write,execute,append,file_inherit,directory_inherit"
acl="$acl
everyone:deny delete,readattr,writeattr"
acl="$acl,readextattr,writeextattr,readsecurity,writesecurity"
acl="$acl,chown,list,search,add_file,add_subdirectory,delete_child"
acl="$acl,read,write,execute,append,file_inherit,directory_inherit"
chmod -P -R -E "$mountpoint" <<<"$acl"

printf "Telling Spotlight to not index the volume\n"
mdutil -Ed "$mountpoint"

printf "%s" "$ramdisk_path" > "$mountpoint/ramdisk_path"
cat > "$mountpoint/CLEANUP" <<EOF
# Run the following when you're done:

sudo diskutil unmount '$mountpoint' && \
rmdir '$mountpoint' && \
diskutil eject '$ramdisk_path'
EOF

undo=""
printf "\nSecure directory created at \`%s'.\n" "$mountpoint"
printf "The directory can be destroyed with ./destroy-secure-dir.sh\n"
