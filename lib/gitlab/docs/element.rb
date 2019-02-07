module Gitlab
  module Docs
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
  end
end
