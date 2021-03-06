# frozen_string_literal: true

module Gitlab
  class SymlinksConverter
    include Nanoc::Helpers::Generic
    EXTENSIONS = %w[png jpg gif svg].freeze

    def initialize(config, items)
      @config = config
      @items = items
    end

    def self.run(config, items)
      new(config, items).run
    end

    def run
      return unless omnibus?

      items.each do |item|
        id = item.identifier

        next unless id.to_s.start_with?('/ee/')
        next unless EXTENSIONS.include?(id.ext)

        file_path = File.join(config.fetch(:content_dir), id.to_s)
        real_path = Pathname.new(file_path).realpath.to_s
        symlink = File.join(config.output_dir, id.to_s)

        # Replace a file with a symlink
        File.delete(symlink) && File.symlink(real_path, symlink) if File.exist?(symlink)
      end
    end

    private

    attr_reader :config, :items
  end
end
