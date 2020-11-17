module Gitlab
  class SymlinksConverter
    EXTENTIONS = ['png', 'jpg', 'gif', 'svg']

    def initialize(config, items)
      @config = config
      @items = items
    end

    def self.run(config, items)
      new(config, items).run
    end

    def run
      return unless Nanoc::Helpers::Generic.is_omnibus?

      items.each do |item|
        id = item.identifier

        if EXTENTIONS.include?(id.ext)
          file_path = File.join(ENV['PWD'], config.fetch(:content_dir), id.to_s)
          symlink = File.join(config.output_dir, id.to_s)

          # Replace a file with a symlink
          File.delete(symlink) && File.symlink(file_path, symlink) if File.exist?(symlink)
        end
      end
    end

    private

    attr_reader :config, :items
  end
end
