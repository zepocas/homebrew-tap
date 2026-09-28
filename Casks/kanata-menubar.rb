cask "kanata-menubar" do
  version "0.1.0"
  sha256 "77ca55b166badeba67720ef4ba8899c6cb12eb8dbb5b435657ea22c2ec43b3e8"

  url "https://github.com/zepocas/kanata-menubar/releases/download/v#{version}/KanataMenubar.app.zip"
  name "Kanata Menubar"
  desc "Menu bar app to track, stop and restart kanata"
  homepage "https://github.com/zepocas/kanata-menubar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "KanataMenubar.app"

  # The app is ad-hoc signed, not notarized: drop the download quarantine so Gatekeeper opens it.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/KanataMenubar.app"], must_succeed: false
  end

  uninstall launchctl: "io.github.zepocas.kanata-menubar",
            quit:      "io.github.zepocas.kanata-menubar"

  zap trash: [
    "~/Library/LaunchAgents/io.github.zepocas.kanata-menubar.plist",
    "~/Library/Logs/kanata-menubar.log",
  ]

  caveats <<~EOS
    To start Kanata Menubar at login, install the LaunchAgent from a clone of the repo:
      git clone https://github.com/zepocas/kanata-menubar
      kanata-menubar/scripts/install-agents.sh
  EOS
end
