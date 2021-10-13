module Gitlab
  class Navigation
    class Doc
      def initialize(doc)
        @doc = doc
      end

      def title
        doc[:doc_title]
      end

      def external_url
        doc[:external_url]
      end

      def url
        doc[:doc_url]
      end

      def ee_only?
        doc[:ee_only]
      end

      def ee_tier
        doc[:ee_tier]
      end

      def has_children?
        !children.empty?
      end

      def children
        @children ||= doc.fetch(:docs, []).map { |nested_doc| Doc.new(nested_doc) }
      end

      private

      attr_reader :doc
    end
  end
end
