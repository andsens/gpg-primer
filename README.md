# GPG Masterkey management toolset

These tools automate the creation of GPG masterkeys on macOS.  
The intended audience is people using a [YubiKey](https://www.yubico.com/products/yubikey-hardware/)
or other smartcard.

## Dependencies

The only dependency is GnuPG modern. Install it with `brew install gnupg` and
make sure to check out [the notes on how to setup GnuPG](SETUP.md) before
continuing.

## Resources

[Offline GnuPG Master Key and Subkeys on YubiKey NEO Smartcard](https://blog.josefsson.org/2014/06/23/offline-gnupg-master-key-and-subkeys-on-yubikey-neo-smartcard/)  
[PGP and SSH keys on a Yubikey NEO](https://www.esev.com/blog/post/2015-01-pgp-ssh-key-on-yubikey-neo/)  
The two primary sources for this guide.

[Yubikey, GnuPG 2.1 Modern, and SSH on macOS](https://www.rempe.us/blog/yubikey-gnupg-2-1-and-ssh/)  
The source for [SETUP.md](SETUP.md).

[drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)  
Extensive guide on how to get GnuPG working with your YubiKey

## Walkthrough

You will be creating a secure directory that is exempt from spotlight indexing,
general system access; it is only readable by you.  
This is the poor man's version of an airgapped machine.

Inside that secure directory you will be creating a masterkey and three
usage specific subkeys key (take a look at [MANAGEKEYS.md](MANAGEKEYS.md) for a
full guide).
You will need to back these keys up to some secure storage, since the keys
are unencrypted (e.g. [VeraCrypt](https://www.veracrypt.fr/en/Home.html)).  
Just remember to keep backups of your backups, _USB flash drives are not a
reliable storage medium_ (unless they are using SLC tech).

Only run the commands with the `$` in front. The rest is output, so you can see
where you went wrong if something doesn't work.

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

# Generate a master key, an encryption subkey will be created at the same automatically
$ ./generate-master.sh 'John Doe' 'jd@example.com'
Generating master key for "John Doe" <jd@example.com>
Key ID is E22FE7692F473FA12F2BAB164046979C50C10E97

# Make sure there is no gpg-agent running
$ gpgconf --kill gpg-agent

# Change the GnuPG home dir, so that you can interact with the keys you just created
$ export GNUPGHOME=$PWD/secure/gnupg-home

# Create authentication and signing subkeys and copy them together with
# the encryption key to your YubiKey.
$ gpg --expert --edit-key E22FE7692F473FA12F2BAB164046979C50C10E97
# Go to MANAGEKEYS.md to see the full list of commands
# The guide will also show you how to back up those keys

# Once you are done make sure once again there is no gpg-agent running
$ gpgconf --kill gpg-agent

# Import all public keys into your regular GPG keychain
$ unset GNUPGHOME
$ gpg --import /Volumes/encrypted-storage/E22FE7692F473FA12F2BAB164046979C50C10E97.public.asc

# Done! Kill the secure directory
$ sudo ./destroy-secure-dir.sh
Unmounting the volume
Volume secure on disk2 unmounted
Deleting the mountpoint
Ejecting the disk
Disk /dev/disk2 ejected
```

## Other tools

### SSH auth

Check out [SETUP.md](SETUP.md) on how to get the gpg-agent running on macOS.

Get your public SSH key with:

```sh
gpg --export-ssh-key E22FE7692F473FA12F2BAB164046979C50C10E97
```

Add it to wherever you want to authenticate with your GPG authentication key.

### git signing

-  `commit.gpgSign = true`: Always sign commits
-  `push.gpgSign = if-asked`: Enable signing of pushes

### GitHub commit signature verification

Export your public key with:

```sh
gpg --armor --export E22FE7692F473FA12F2BAB164046979C50C10E97
```

And paste it into into the GPG field on https://github.com/settings/keys

### Fallback private key

For DB editors that do not support ssh agents, add a restricted normal
private key auth.  
`$HOME/.ssh/authorized_keys`

```
no-pty,no-X11-forwarding,permitopen="127.0.0.1:5432",command="/bin/echo do-not-send-commands" ssh-rsa private_key jd+postgres-only@example.com
```

### Lock screen on YubiKey removal

@shtirlic made a nifty little tool called (yubikeylockd)[https://github.com/shtirlic/yubikeylockd]
that locks the screen automatically when a YubiKey is removed from its USB port.  
Install it with `brew install https://raw.githubusercontent.com/shtirlic/yubikeylockd/master/yubikeylockd.rb`  
and enable with `sudo brew services start yubikeylockd`.

The screen also wakes up when the key is plugged in again!
