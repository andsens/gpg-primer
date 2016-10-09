# GPG Masterkey management toolset #

These tools automate the creation of GPG masterkeys.  
"GnuPG modern" is required for these tools to work
(`brew install homebrew/versions/gnupg21`).

### Walkthrough ###

```sh
# Create a secure directory that GnuPG can work in
$ sudo ./create-secure-dir.sh
Creating ramdisk
Formatting ramdisk at /dev/disk2
Initialized /dev/rdisk2 as a 1024 KB case-insensitive HFS Plus volume
Creating mountpoint at .../secure
Mounting volume
Setting permissions on mountpoint
.../secure: 00 -> 0100000
Telling Spotlight to not index the volume
.../secure:
2016-10-09 10:39:35.684 mdutil[84268:21085066] mdutil disabling Spotlight: .../secure -> kMDConfigSearchLevelFSSearchOnly
	Indexing disabled.

Secure directory created at '.../secure'.
The directory can be destroyed with ./destroy-secure-dir.sh

# Generate a master & encryption key
$ ./generate-master.sh 'John Doe' 'jd@example.com'
Generating master key and encryption subkey for "John Doe" <jd@example.com>
Key ID is E22FE7692F473FA12F2BAB164046979C50C10E97

# Change the GnuPG home dir, so that we can interact with the keys we just created
$ export GNUPGHOME=$PWD/secure/gnupg-home

# Make sure gpg-agent uses the new home dir
$ killall gpg-agent

# Add a photo to key, copy the encryption key to your smartcard
# and sign the authentication & signing keys with your master key
$ gpg2 --edit-key E22FE7692F473FA12F2BAB164046979C50C10E97

# Once all keys have been created, back them up
$ ./backup.sh E22FE7692F473FA12F2BAB164046979C50C10E97
Backing up private keys
Backing up public keys
Generating revocation certificate

# Store the backup in a safe place
$ cp -r secure/backup /Volumes/encrypted-storage

# Import all public keys into your regular GPG keychain
$ unset GNUPGHOME
$ gpg2 --import secure/backup/E22FE7692F473FA12F2BAB164046979C50C10E97.public.asc

# Done! Kill the secure directory
$ sudo ./destroy-secure-dir.sh
Unmounting the volume
Volume secure on disk2 unmounted
Deleting the mountpoint
Ejecting the disk
Disk /dev/disk2 ejected
```

### Setting up SSH auth ###

Get your public SSH key with:
```sh
gpg2 --export-ssh-key E22FE7692F473FA12F2BAB164046979C50C10E97
```
Add it to wherever you want to authenticate with your GPG authentication key.

Check out [SETUP.md](SETUP.md) on how to get the gpg-agent running on macOS.
