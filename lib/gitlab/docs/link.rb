module Gitlab
  module Docs
    class Link
      PRODUCT_SUFFIX = /-(core|starter|premium|ultimate)(-only)?/.freeze

      attr_reader :link, :href, :page

      def initialize(link, page)
        @href = link.to_s
        @page = page
      end

      def to_anchor?
        !anchor_name.to_s.strip.empty?
      end

      def anchor_name
        return unless @href.include?('#')

        @href.partition('#').last
      end

      def internal_anchor?
        return false unless to_anchor?

        @href.partition('#').first.empty?
      end

      def internal?
        @href.length > 0 && !@href.include?(':')
      end

      def path
        @href.partition('#').first
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
        # TODO: Remove me when https://gitlab.com/gitlab-org/gitlab/-/merge_requests/39715 is merged
        anchor_without_suffix = anchor_name.gsub(PRODUCT_SUFFIX, '')

        !destination_page.has_anchor?(anchor_without_suffix)
      end
    end
  end
end
