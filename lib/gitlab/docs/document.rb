module Gitlab
  module Docs
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
  end
end
