# Homebrew cask template. scripts/bump-cask.sh fills in 0.1 and a465cb4d96e61084df46e5a70fa8b891edb47a4c0c15f582ebf987c0b061e61f and writes it
# to zepocas/homebrew-tap as Casks/komorebi-menubar.rb.
cask "komorebi-menubar" do
  version "0.1"
  sha256 "a465cb4d96e61084df46e5a70fa8b891edb47a4c0c15f582ebf987c0b061e61f"

  url "https://github.com/zepocas/komorebi-menubar/releases/download/v#{version}/KomorebiMenubar-#{version}.zip"
  name "Komorebi Menubar"
  desc "Menu bar workspace indicator for the komorebi tiling window manager"
  homepage "https://github.com/zepocas/komorebi-menubar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "KomorebiMenubar.app"

  # The app is ad-hoc signed, not notarized: drop the download quarantine so Gatekeeper opens it.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/KomorebiMenubar.app"], must_succeed: false
  end

  uninstall launchctl: "io.github.zepocas.komorebi-menubar",
            quit:      "io.github.zepocas.komorebi-menubar"

  zap trash: [
    "~/Library/Application Support/komorebi/komorebi-menubar.sock",
    "~/Library/Logs/komorebi-menubar.log",
  ]

  caveats <<~EOS
    To start komorebi, skhd and Komorebi Menubar at login (needed for Restart in the menu),
    install the LaunchAgents from a clone of the repo:
      git clone https://github.com/zepocas/komorebi-menubar
      komorebi-menubar/scripts/install-agents.sh
  EOS
end
