module Gitlab
  module Docs
    class Page
      attr_reader :file
      attr_accessor :hrefs, :ids

      def initialize(file)
        @file = file
        @hrefs = []
        @ids = []

        return unless exists?

        Nokogiri::HTML::SAX::Parser
          .new(Gitlab::Docs::Document.new(self))
          .parse(File.read(file))
      end

      def exists?
        File.exists?(@file)
      end

      def directory
        File.dirname(@file)
      end

      def links
        @links ||= @hrefs.map do |link|
          Gitlab::Docs::Link.new(link, self)
        end
      end

      def has_anchor?(name)
        @ids.include?(name)
      end

      def self.build(path)
        if path.end_with?('.html')
          new(path)
        else
          new(File.join(path, 'index.html'))
        end
      end
    end
  end
end
