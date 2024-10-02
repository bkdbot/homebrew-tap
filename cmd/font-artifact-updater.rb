# typed: true
# frozen_string_literal: true

require "abstract_command"
require "open3"
require "digest"
require "cask/download"

module Homebrew
  module Cmd
    class FontArtifactUpdater < AbstractCommand
      cmd_args do
        usage_banner <<~EOS
          `font-artifact-updater` <token>

          Generates cask stanzas from OTF/TTF files within <token>.
        EOS

        named_args :token, min: 1, max: 1
      end

      FONT_EXT_PATTERN = /.(otf|ttf)\Z/i

      FONT_WEIGHTS = [
        /black/i,
        /bold/i,
        /book/i,
        /hairline/i,
        /heavy/i,
        /light/i,
        /medium/i,
        /normal/i,
        /regular/i,
        /roman/i,
        /thin/i,
        /ultra/i,
      ].freeze

      FONT_STYLES = [
        /italic/i,
        /oblique/i,
        /roman/i,
        /slanted/i,
        /upright/i,
      ].freeze

      FONT_WIDTHS = [
        /compressed/i,
        /condensed/i,
        /extended/i,
        /narrow/i,
        /wide/i,
      ].freeze

      def mce(enum)
        enum.group_by(&:itself).values.max_by(&:size).first
      end

      def eval_bin_cmd(cmd, blob)
        IO.popen(cmd, "r+b") do |io|
          io.print(blob)
          io.close_write
          io.read
        end
      end

      # Determine archive type and return the appropriate command for listing files
      def list_cmd(archive)
        case File.extname(archive).downcase
        when ".zip"
          "zipinfo -1 #{archive}"
        when ".7z"
          "sh -c '7z l -ba #{archive} | grep -o \"[^ ]*$\"'"
        else
          raise "Unsupported archive type"
        end
      end

      def font_paths(archive)
        cmd = list_cmd(archive)

        IO.popen(cmd, "r") do |io|
          io.read.chomp.split("\n")
            .grep(FONT_EXT_PATTERN)
            .reject { |x| x.start_with?("__MACOSX") }
            .grep_v(%r{(?:\A|/)\._})
            .sort
        end
      end

      def update_cask_content(cask, fonts)
        content = cask.source.split("\n")
        font_content = fonts.map do |font|
          "  font \"#{font}\""
        end
        new_content = []
        last_match = nil
        content.each_with_index do |line, index|
          if line.match?(/^  font /)
            last_match = index
            next
          end
          new_content << font_content if last_match && last_match == index -1
          new_content << line
        end
        new_content << ""
        new_content.join("\n")
      end

      def run
        token = args.named.first

        cask = Cask::CaskLoader.load(token)
        path = Cask::Download.new(cask).fetch

        ohai "Finding font paths" if args.debug?
        fonts = font_paths(path)

        cask.token.split("-").first[0]

        if args.debug?
          ohai "Found fonts in archive:"
          puts fonts.join("\n")
        end

        new_content = update_cask_content(cask, fonts)

        File.write(cask.sourcefile_path, new_content)

        ohai "Running brew style --fix #{token}" if args.debug?
        system("brew", "style", "--fix", token)
      end
    end
  end
end
