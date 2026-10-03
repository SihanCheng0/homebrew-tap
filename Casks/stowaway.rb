cask "stowaway" do
  version "1.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/SihanCheng0/stowaway/releases/download/v#{version}/Stowaway-#{version}.dmg"
  name "Stowaway"
  desc "Menu bar utility that keeps laptops awake with the lid closed"
  homepage "https://github.com/SihanCheng0/stowaway"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Stowaway.app"

  # Releases aren't notarized yet (no paid Apple Developer account), so Gatekeeper would
  # block the first launch. Remove this once releases are notarized.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Stowaway.app"]
  end

  # Quitting the app restores sleep. This backs that up without a password prompt: it
  # matches Stowaway's own NOPASSWD rule and quietly does nothing if the rule is gone.
  # The rule itself is removed only by zap, so upgrades don't force re-authorizing.
  uninstall quit:   "com.sihan.stowaway",
            script: {
              executable:   "/usr/bin/sudo",
              args:         ["-n", "/usr/bin/pmset", "-a", "disablesleep", "0"],
              must_succeed: false,
            }

  zap delete: "/private/etc/sudoers.d/stowaway",
      trash:  [
        "~/Library/Caches/com.sihan.stowaway",
        "~/Library/HTTPStorages/com.sihan.stowaway",
        "~/Library/Preferences/com.sihan.stowaway.plist",
      ]

  caveats <<~EOS
    On first launch, Stowaway asks for your administrator password once to install
    /etc/sudoers.d/stowaway. That rule lets it run only
      /usr/bin/pmset -a disablesleep 0
      /usr/bin/pmset -a disablesleep 1
    without a password.

    Upgrades keep the rule. To remove it, click "Remove authorization" in Stowaway
    before uninstalling, or uninstall with: brew uninstall --zap --cask stowaway
  EOS
end
