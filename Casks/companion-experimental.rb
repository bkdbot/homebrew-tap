cask "companion-experimental" do
  arch arm: "arm64", intel: "x64"

  version "3.99.0+6619-develop-b8c77f2b"
  sha256 arm:   "a3cbaaa3decfaf006915ab4ef758cb381ee047adb4983bbe36ae43004aaafb67",
         intel: "dc38f91a6f9a8e6c4bbfcd2420dbb21b43a7e1e1553989197543d836851477d9"

  url "https://s3.bitfocus.io/builds/companion/companion-mac-#{arch}-#{version}.dmg"
  name "Bitfocus Companion"
  desc "Streamdeck extension and emulation software"
  homepage "https://bitfocus.io/companion"

  livecheck do
    url "https://api.bitfocus.io/v1/product/companion/packages?branch=experimental&limit=150"
    strategy :json do |json|
      json["packages"].select { |c| c["target"] == "mac-intel" }.map { |c| c["version"] }
    end
  end

  auto_updates true

  app "Companion.app", target: "Companion Experimental.app"

  # No zap stanza required
  # Shares settings with companion-beta - so don't remove
  # To forcibly clean up, run brew uninstall --cask --force --zap companion-beta
end
