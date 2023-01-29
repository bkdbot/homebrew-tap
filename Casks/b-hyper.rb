cask "b-hyper" do
  arch arm: "arm64", intel: "x64"

  version "4.0.0-canary.3"
  sha256 arm:   "8c0583b11741d72236241fcb977ad59e7d2f752df7a125119554d3aba9626a3a",
         intel: "d1879f618a9c6eaff25e7de41df92f6b0431548bef00e380fad84b0594711bf2"

  url "https://github.com/vercel/hyper/releases/download/v#{version}/Hyper-#{version}-mac-#{arch}.zip",
      verified: "github.com/vercel/hyper/"
  name "Hyper"
  desc "Terminal built on web technologies"
  homepage "https://hyper.is/"

  livecheck do
    url :url
    strategy :git
    regex(/(\d+(?:\.\d+)+(?:-canary\.(\d+))?)/i)
  end

  auto_updates true
  conflicts_with cask: ["homebrew/cask-versions/hyper-canary", "hyper"]

  app "Hyper.app"
  binary "#{appdir}/Hyper.app/Contents/Resources/bin/hyper"

  zap trash: [
    "~/.hyper.js",
    "~/.hyper_plugins",
    "~/Library/Application Support/Hyper",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/co.zeit.hyper.sfl*",
    "~/Library/Caches/co.zeit.hyper",
    "~/Library/Caches/co.zeit.hyper.ShipIt",
    "~/Library/Cookies/co.zeit.hyper.binarycookies",
    "~/Library/Logs/Hyper",
    "~/Library/Preferences/ByHost/co.zeit.hyper.ShipIt.*.plist",
    "~/Library/Preferences/co.zeit.hyper.plist",
    "~/Library/Preferences/co.zeit.hyper.helper.plist",
    "~/Library/Saved Application State/co.zeit.hyper.savedState",
  ]
end
