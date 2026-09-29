cask "kanata-menubar" do
  version "0.3.0"
  sha256 "e8d989dbdef316272e6329cd0a8bf85fdb85bfedec2dad3a6d77d2730fdfdf84"

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

  postflight_steps do
    # The app is ad-hoc signed, not notarized: drop the download quarantine so Gatekeeper opens it.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/KanataMenubar.app"], must_succeed: false
    # After an upgrade, relaunch the login agent (if Start at Login is on) so the new version is running.
    run "/bin/sh",
        args:         ["-c", "launchctl kickstart gui/$(id -u)/io.github.zepocas.kanata-menubar 2>/dev/null"],
        must_succeed: false
  end

  # Upgrades run this too, so it must not remove the login agent; `zap` does that.
  uninstall quit: "io.github.zepocas.kanata-menubar"

  zap launchctl: "io.github.zepocas.kanata-menubar",
      trash:     [
        "~/Library/LaunchAgents/io.github.zepocas.kanata-menubar.plist",
        "~/Library/Logs/kanata-menubar.log",
      ]

  caveats <<~EOS
    To start Kanata Menubar at login, open it and pick "Start at Login" from its menu.
  EOS
end
