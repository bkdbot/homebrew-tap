cask "enttec-emu" do
  version "23.07.15.1"
  sha256 "bec1db44b76dc729ab5427e97f5e3d38a9ec4398649692a10dd5d173abb95e1d"

  url "https://s3-us-west-2.amazonaws.com/enttec-software-builds/emu/EMU-#{version}.pkg",
      verified: "s3-us-west-2.amazonaws.com/enttec-software-builds/emu/"
  name "ENTTEC Emu"
  desc "Setup and manage ENTTEC DMX devices"
  homepage "https://www.enttec.com.au/product/dmx-lighting-control-software/emu-sound-to-light-controller/"

  livecheck do
    url "https://s3-us-west-2.amazonaws.com/enttec-software-builds/emu/emu-versions.json"
    regex(/EMU[._-]v?(\d+(?:\.\d+)+)\.pkg","Stages":\["Beta","Production/i)
  end

  pkg "EMU-#{version}.pkg"

  uninstall pkgutil: [
    "com.enttec.emu.au",
    "com.enttec.emu.vst3",
    "com.enttec.emu",
  ]

  zap trash: "~/Library/Preferences/com.enttec.emu.plist"
end
