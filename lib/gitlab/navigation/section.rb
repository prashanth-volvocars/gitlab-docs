module Gitlab
  class Navigation
    class Section
      def initialize(section)
        @section = section
        @enabled = true
      end

      attr_reader :enabled

      def disable!
        @enabled = false
      end

      def title
        section[:section_title]
      end

      def ee_only?
        section[:ee_only]
      end

      def ee_tier
        section[:ee_tier]
      end

      def url
        section[:section_url]
      end

      def has_children?
        !children.empty?
      end

      def children
        @children ||= section.fetch(:section_categories, []).map { |cat| Category.new(cat) }
      end

      private

      attr_reader :section
    end
  end
end
