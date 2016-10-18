# macOS Sierra gpg agent setup #

## Software installation ##

```sh
brew tap homebrew/version
brew install homebrew/versions/gnupg21 pinentry-mac
clone git@github.com:andsens/gpg-automation gpg
# Check README for a full walkthrough
```

## `$HOME/.gnupg/gpg-agent.conf` ##
```sh
enable-ssh-support
pinentry-program /usr/local/bin/pinentry-mac
```

## rc file ##
```sh
SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
```

## `$HOME/Library/LaunchAgents/gpg.agent.daemon.plist` ##
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>gpg.agent.daemon.plist</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/bin/gpgconf</string>
		<string>--launch</string>
		<string>gpg-agent</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
```

# Further resources #

* https://www.rempe.us/blog/yubikey-gnupg-2-1-and-ssh/
