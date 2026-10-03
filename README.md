# SihanCheng0/homebrew-tap

Homebrew casks for Sihan's macOS apps.

## Stowaway

[Stowaway](https://github.com/SihanCheng0/stowaway) keeps a MacBook awake with the lid closed. It's a menu bar app for macOS 13 (Ventura) or later.

```sh
brew install --cask SihanCheng0/tap/stowaway
```

Update with `brew upgrade --cask stowaway`.

Stowaway releases are open source but not yet notarized by Apple. The cask removes the download quarantine flag after installing, so the app opens without a Gatekeeper prompt.

On first launch Stowaway asks for your administrator password once to install `/etc/sudoers.d/stowaway`, which lets it run only `pmset -a disablesleep 0` and `pmset -a disablesleep 1` without a password. Upgrades keep that rule, so you authorize once.

Uninstalling quits Stowaway, which turns lid-closed sleep back on. To also delete the rule and Stowaway's preferences, use `--zap`:

```sh
brew uninstall --zap --cask stowaway
```

Or click **Remove authorization** in Stowaway before a plain `brew uninstall --cask stowaway`.

## Maintaining

`scripts/release.sh` in the Stowaway repo builds, signs and notarizes `Stowaway-<version>.dmg`, then rewrites the `version` and `sha256` lines of `Casks/stowaway.rb`. `scripts/publish.sh` creates the GitHub release as a draft, commits and pushes the cask here, then publishes the release. Don't edit those two lines by hand.

Before the first release the `sha256` line is 64 zeros. That's a placeholder in the format `release.sh` replaces. It makes installs fail the checksum check instead of skipping it the way `sha256 :no_check` would.

Lint after changing the cask:

```sh
brew style Casks/stowaway.rb
brew audit --cask --online SihanCheng0/tap/stowaway   # needs the tap installed
```
