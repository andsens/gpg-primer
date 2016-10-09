# GPG Masterkey management toolset #

These tools automate the creation of GPG masterkeys.  
"GnuPG modern" is required for these tools to work
(`brew install homebrew/versions/gnupg21`).

### `create-secure-disk.sh` ###

Avoid writing keys to disk, `create-secure-disk.sh` creates
and mounts a secure ramdisk for you.

### `destroy-secure-disk.sh` ###

Counterpart to `create-secure-disk.sh`, this tool removes
the secure directory.

### `generate-master.sh` ###

Generates a master key and an encryption subkey.

### `backup.sh` ###

Exports the private and public keys.
A master revocation certificate is also created.

### `restore.sh` ###

Imports keys that were backed up with `backup.sh`.
