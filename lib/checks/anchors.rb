module Gitlab
  module Nanoc
    def self.config
      @config ||= YAML.load(File.read('nanoc.yaml'))
    end

    def self.output_dir
      config.fetch('output_dir')
    end
  end

  class Page
    attr_reader :file

    def initialize(file)
      @file = file
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

    def document
      raise if content.to_s.empty?

      @doc ||= Nokogiri::HTML(content)
    end

    def links
      @links ||= document.css(:a).map do |link|
        Gitlab::Link.new(link, self)
      end
    end

    def has_anchor?(name)
      document.at_css(%Q{[id="#{name}"]})
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
      @link = link
      @href = link[:href]
      @page = page
    end

    def to_anchor?
      @href.to_s.include?('#')
    end

    def anchor_name
      raise ArguentError unless to_anchor?

      @href.to_s.partition('#').last
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
        Gitlab::Nanoc.output_dir + path
      else
        ::File.expand_path(path, @page.directory)
      end
    end

    def destination_page
      if internal_anchor?
        @page
      else
        Gitlab::Page.build(absolute_path)
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

Nanoc::Check.define(:internal_anchors) do
  output_html_filenames.each do |file|
    Gitlab::Page.new(file).links.each do |link|
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
        (require 'pry'; binding.pry) if link.anchor_name == '1-stop-server'
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
end
