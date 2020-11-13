module Gitlab
  class Navigation
    class Category
      def initialize(category)
        @category = category
      end

      def title
        category[:category_title]
      end

      def external_url
        category[:external_url]
      end

      def url
        category[:category_url]
      end

      def ee_only?
        category[:ee_only]
      end

      def ee_tier
        category[:ee_tier]
      end

      def has_children?
        !children.empty?
      end

      def children
        @children ||= category.fetch(:docs, []).map { |doc| Doc.new(doc) }
      end

      private

      attr_reader :category
    end
  end
end
