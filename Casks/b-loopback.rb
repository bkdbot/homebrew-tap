cask "b-loopback" do
  version "2.2.12"
  sha256 :no_check

  url "https://rogueamoeba.com/loopback/download/Loopback.zip"
  name "Loopback"
  desc "Cable-free audio router"
  homepage "https://rogueamoeba.com/loopback/"

  livecheck do
    url "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.loopback&system=12321&platform=osx&version=#{version.no_dots}8000"
    strategy :sparkle
  end

  auto_updates true
  conflicts_with "loopback"
  depends_on macos: ">= :catalina"

  app "Loopback.app"
  installer script: {
    executable: "Loopback.app/Contents/Resources/aceinstaller",
    args:       ["install", "--silent"],
    sudo:       true,
  }

  uninstall script: {
    executable: "Loopback.app/Contents/Resources/aceinstaller",
    args:       ["uninstall", "--silent"],
    sudo:       true,
  }

  zap trash: [
    "~/Library/Application Support/Loopback",
    "~/Library/Caches/com.rogueamoeba.Loopback",
    "~/Library/Caches/com.rogueamoeba.loopbackd",
    "~/Library/LaunchAgents/com.rogueamoeba.loopbackd.plist",
    "~/Library/Preferences/com.rogueamoeba.Loopback.plist",
    "~/Library/Preferences/com.rogueamoeba.loopbackd.plist",
    "~/Library/WebKit/com.rogueamoeba.Loopback",
  ]
end
