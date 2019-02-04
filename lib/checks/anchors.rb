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

    class Element
      def initialize(name, attributes)
        @name = name
        @attributes = attributes
      end

      def link?
        @name == 'a' && !href.to_s.empty?
      end

      def has_id?
        !id.to_s.empty?
      end

      def href
        @href ||= attribute('href')
      end

      def id
        @id ||= attribute('id')
      end

      private

      def attribute(name)
        @attributes.find { |attr| attr.first == name }&.last
      end
    end

    class Document < Nokogiri::XML::SAX::Document
      def initialize(page)
        @page = page
      end

      def start_element(name, attributes = [])
        Gitlab::Docs::Element.new(name, attributes).tap do |element|
          @page.hrefs << element.href if element.link?
          @page.ids << element.id if element.has_id?
        end
      end
    end

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

      def content
        raise unless exists?

        @content ||= File.read(@file)
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

    class Link
      attr_reader :link, :href, :page

      def initialize(link, page)
        @href = link
        @page = page
      end

      def to_anchor?
        @href.to_s.include?('#')
      end

      def anchor_name
        raise ArguentError unless to_anchor?

        @href.to_s.partition('#').last.downcase
      end

      def internal_anchor?
        raise ArguentError unless to_anchor?

        @href.to_s.partition('#').first.empty?
      end

      def internal?
        @href.to_s.length > 0 && !@href.include?(':')
      end

      def path
        @href.to_s.partition('#').first
      end

      def absolute_path
        raise unless internal?

        if @href.start_with?('/')
          Gitlab::Docs::Nanoc.output_dir + path
        else
          ::File.expand_path(path, @page.directory)
        end
      end

      def destination_page
        if internal_anchor?
          @page
        else
          Gitlab::Docs::Page.build(absolute_path)
        end
      end

      def source_file
        @page.file
      end

      def destination_file
        destination_page.file
      end

      def destination_page_not_found?
        !destination_page.exists?
      end

      def destination_anchor_not_found?
        !destination_page.has_anchor?(anchor_name)
      end
    end
  end
end

Nanoc::Check.define(:internal_anchors) do
  output_html_filenames.each do |file|
    Gitlab::Docs::Page.new(file).links.each do |link|
      next unless link.internal?
      next unless link.to_anchor?
      next if link.anchor_name == 'markdown-toc'

      if link.destination_page_not_found?
        add_issue <<~ERROR
          Destination page not found!
                - link `#{link.href}`
                - destination `#{link.destination_file}`
                - source file `#{link.source_file}`
        ERROR
      elsif link.destination_anchor_not_found?
        add_issue <<~ERROR
          Broken anchor detected!
                - anchor `##{link.anchor_name}`
                - link `#{link.href}`
                - source file `#{link.source_file}`
                - destination `#{link.destination_file}`
        ERROR
      end
    end
  end

  add_issue "#{issues.count} offenses found!"
end
