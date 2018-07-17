Only run the commands with `$`, `gpg>` or `gpg/card>` in front.
The rest is output, so you can see where you went wrong if something doesn't work.
Keep in mind that you do not need to copy any of the input values 1:1, if you
are fine with 2096 bit keys or a key expiration of 5 years just use that.

We will start by editing the key we created with `./generate-master.sh`.  
We are going to add a secondary ID (e.g. work email address) and two new subkeys
(authentication, signing).  
After that we will configure the YubiKey preferences (name, preferred language, gender, PINs...).  
Finally we will copy the subkeys to the YubiKey.

```sh
$ gpg --expert --edit-key E22FE7692F473FA12F2BAB164046979C50C10E97
gpg (GnuPG/MacGPG2) 2.2.8; Copyright (C) 2018 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: next trustdb check due at 2017-10-09
sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
[ultimate] (1). John Doe <jd@example.com>

gpg> adduid
Real name: John Doe
Email address: john.doe@company.com
Comment:
You selected this USER-ID:
    "John Doe <john.doe@company.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
[ultimate] (1)  John Doe <jd@example.com>
[ unknown] (2). John Doe <john.doe@company.com>

# Select the first user ID
gpg> uid 1

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
[ultimate] (1)* John Doe <jd@example.com>
[ unknown] (2). John Doe <john.doe@company.com>

# Set that user ID as the primary one
# (adduid causes the new UID to become the primary UID)
gpg> primary

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
[ultimate] (1)* John Doe <jd@example.com>
[ unknown] (2)  John Doe <john.doe@company.com>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
Your selection? 4
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
# When the key expires you can just extend its validity period using the master key.
# This is a good way to ensure that you check your backups.
Key is valid for? (0) 1y
Key expires at Wed Oct 09 11:31:58 2017 CEST
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
[ultimate] (1). John Doe <jd@example.com>
[ unknown] (2)  John Doe <john.doe@company.com>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? e

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions:

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? a

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Authenticate

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Wed Oct 09 11:31:58 2017 CEST
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ unknown] (2)  John Doe <john.doe@company.com>

gpg> quit
Save changes? (y/N) y

# Edit your YubiKey preferences. Set your name, language, sex, and the 3 PINs.
$ gpg --edit-card

Reader ...........: Yubico Yubikey 4 OTP U2F CCID
Application ID ...: D0123456789012345678901234567890
Version ..........: 2.1
Manufacturer .....: Yubico
Serial number ....: 12345678
Name of cardholder: [not set]
Language prefs ...: [not set]
Sex ..............: unspecified
URL of public key : [not set]
Login data .......: [not set]
Signature PIN ....: forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 0 0 0
PIN retry counter : 0 0 0
Signature counter : 0
Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]
General key info..: [none]

# Enter admin mode, the default admin PIN is 12345678
gpg/card> admin
Admin commands are allowed

gpg/card> name
Cardholder's surname: Doe
Cardholder's given name: John

gpg/card> lang
Language preferences: en

gpg/card> sex
Sex ((M)ale, (F)emale or space): m

gpg/card> passwd
gpg: OpenPGP card no. D0123456789012345678901234567890 detected

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 1
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 3
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 4
Reset Code set.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? q

gpg/card> q

# Before copying the keys we created to they YubiKey we will need to back them up.
# This is because GPG actually "moves" the secret keys, i.e. they are deleted
# from your local machine.

$ ./export.sh E22FE7692F473FA12F2BAB164046979C50C10E97 secure /Volumes/encrypted-storage
Exporting private keys
Exporting public keys
Generating revocation certificate

# Now we copy the subkeys to the smartcard
$ gpg --expert --edit-key E22FE7692F473FA12F2BAB164046979C50C10E97
gpg (GnuPG/MacGPG2) 2.2.8; Copyright (C) 2018 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

# Select the keys one by one and copy them to the card
gpg> key 1

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb* rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

# Enter the admin PIN to authenticate the copy operation
gpg> keytocard
Please select where to store the key:
   (2) Encryption key
Your selection? 2

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb* rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> key 1

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> key 2

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb* rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> keytocard
Please select where to store the key:
   (1) Signature key
   (3) Authentication key
Your selection? 1

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb* rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> key 2

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb  rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> key 3

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb* rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> keytocard
Please select where to store the key:
   (3) Authentication key
Your selection? 3

sec  rsa4096/4046979C50C10E97
     created: 2016-10-09  expires: 2017-10-09  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/92C010EE6A904096
     created: 2016-10-09  expires: 2017-10-09  usage: E
ssb  rsa4096/033B5B9E8AB46B9F
     created: 2016-10-09  expires: 2017-10-09  usage: S
ssb* rsa4096/C8B4D8DF68694A26
     created: 2016-10-09  expires: 2017-10-09  usage: A
[ultimate] (1). John Doe <jd@example.com>
[ultimate] (2)  John Doe <john.doe@company.com>

gpg> quit
Save changes? (y/N) y
```
