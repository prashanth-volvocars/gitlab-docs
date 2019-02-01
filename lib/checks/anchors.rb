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

    def path
      File.dirname(@file)
    end

    def document
      raise ArgumentError unless exists?

      @doc ||= Nokogiri::HTML(File.read(@file))
    end

    def links
      @links ||= document.css(:a).map do |link|
        Gitlab::Link.new(link, self)
      end
    end

    def has_anchor?(name)
      document.at_css(%Q{[id="#{name}"]})
    end
  end

  class Link
    attr_reader :link, :href, :page

    def initialize(link, page)
      @link = link
      @href = link[:href]
      @page = page
    end

    def path
      @href.to_s.partition('#').first
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

    def destination_path
      raise unless internal?

      if @href.start_with?('/')
        Gitlab::Nanoc.output_dir + path
      else
        ::File.expand_path(path, @page.path)
      end
    end

    def destination_file
      if destination_path.end_with?('.html')
        destination_path
      else
        File.join(destination_path, 'index.html')
      end
    end

    def destination_page
      if internal_anchor?
        @page
      else
        Gitlab::Page.new(destination_file)
      end
    end
  end
end

Nanoc::Check.define(:internal_anchors) do
  @output_filenames.each do |file|
    Gitlab::Page.new(file).links.each do |link|
      next unless link.internal?
      next unless link.to_anchor?

      link.destination_page.yield_self do |page|
        next if link.anchor_name == 'markdown-toc'

        if !page.exists?
          add_issue("Page `#{page.file}` linked from `#{link.page.file}` not found!")
        elsif !page.has_anchor?(link.anchor_name)
          add_issue("Broken anchor `##{link.anchor_name}` found in `#{link.page.file}` to `#{link.destination_file}`")
        end
      end
    end
  end
end
