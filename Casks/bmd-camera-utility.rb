cask "bmd-camera-utility" do
  require "net/http"

  version "8.4.0,c7f22f46807749288e796330de73cc77,d42f58e83f044f3aa1821108bb8b91d1"
  sha256 "6032b504541e0e6bd144d92b79ca3376123261220d9a5f04314989b136805e81"

  url do
    params = {
      "platform"     => "Mac OS X",
      "downloadOnly" => "true",
      "country"      => "us",
      "policy"       => "true",
    }.to_json

    uri = URI("https://www.blackmagicdesign.com/api/register/us/download/#{version.csv.third}")
    resp = Net::HTTP.post(uri, params, { "Content-Type" => "application/json" })

    resp.body
  end
  name "Blackmagic Camera Utility"
  desc "Update and manage Blackmagic Cameras"
  homepage "https://www.blackmagicdesign.com/"

  livecheck do
    url "https://www.blackmagicdesign.com/"
    strategy :page_match do
      res, _err, _st =
        Open3.capture3("curl -X POST -H \"Content-Type: application/json\" -d '{\"product\":\"camera\", " \
                       "\"platform\":\"mac\"}' \"https://www.blackmagicdesign.com/api/support/latest-version\"")
      version_info = JSON.parse(res)["mac"]
      next if version_info.blank?

      "#{version_info["major"]}.#{version_info["minor"]}.#{version_info["releaseNum"]},#{version_info["releaseId"]},#{version_info["downloadId"]}"
    end
  end

  # Doesn't automatically update, but set to true to prevent `brew upgrade` from forcing an update
  auto_updates true
  container nested: "Blackmagic_Camera_Setup_#{version.csv.first.chomp(".0")}.dmg"

  pkg "Install Cameras #{version.csv.first.chomp(".0")}.pkg"

  uninstall pkgutil: [
    "com.blackmagic-design.CameraControllers",
    "com.blackmagic-design.MiniRecorder",
    "com.blackmagic-design.BlackmagicRawSDK",
    "com.blackmagic-design.BlackmagicRaw",
    "com.blackmagic-design.SMPTEFiber",
    "com.blackmagic-design.CamerasUninstaller",
    "com.blackmagic-design.CamerasAssets",
    "com.blackmagic-design.Cameras",
  ]

  zap trash: [
    "~/Library/Preferences/com.blackmagic-design.Camera Setup.plist",
  ]
end
