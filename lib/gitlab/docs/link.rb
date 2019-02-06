module Gitlab
  module Docs
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
        raise ArgumentError unless to_anchor?

        @href.to_s.partition('#').last.downcase
      end

      def internal_anchor?
        raise ArgumentError unless to_anchor?

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

