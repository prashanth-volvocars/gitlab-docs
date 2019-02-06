module Gitlab
  module Docs
    module Nanoc
      def self.config
        @config ||= YAML.load(File.read('nanoc.yaml'))
      end

      def self.output_dir
        config.fetch('output_dir')
      end
    end
  end
end
