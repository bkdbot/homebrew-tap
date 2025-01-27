cask "boom-3d-audio-component" do
  version "1.4.5"
  sha256 "d5c6a1029205498156c21e7c7c89bdc14f8c9f5222b55a9eb6feca2be47768dc"

  url "https://d3jbf8nvvpx3fh.cloudfront.net/device-assets/boom3d/catalina/v#{version}_tagged/Audio_Component_Installer.zip",
      verified: "d3jbf8nvvpx3fh.cloudfront.net/device-assets/boom3d/",
      referer:  "https://www.globaldelight.com"
  name "Boom 3D Component Installer"
  desc "Component installer for Boom 3D"
  homepage "https://www.globaldelight.com/boom3d"

  livecheck do
    url :homepage
    strategy :page_match do |_page|
      main_cask = CaskLoader.load("boom-3d")
      main_cask_version = Homebrew::Livecheck::Strategy::ExtractPlist.find_versions(cask: main_cask)[:matches]
                                                                     .values
                                                                     .first
      next if main_cask_version.blank?

      main_cask_version_major = main_cask_version.to_s.split(",").first
      audio_component_url =
        "https://www.globaldelight.com/boom3d/mas-content/catalina/device-installer.php" \
        "?language=en-AU&app_version=#{main_cask_version_major}"
      audio_component_regex =
        %r{href=.*?v?(\d+(?:\.\d+)+)(?:_)(?:.+)/Audio((%20)|[_-])Component((%20)|[_-])Installer\.zip}i

      Homebrew::Livecheck::Strategy::PageMatch.find_versions(url:   audio_component_url,
                                                             regex: audio_component_regex)[:matches].values
    end
  end

  app_path = "Audio Component Installer.app"

  app app_path,
      target: "#{staged_path}/#{app_path} #{version}.app"

  postflight do
    system "open '#{staged_path}/#{app_path} #{version}.app' -W"
  end
end
