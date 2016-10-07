module Nanoc::Filters
  class MarkdownToHtmlExt < Nanoc::Filter
    identifier :md_to_html_ext

    # Convert internal URLs that link to `.md` files to instead link to
    #{ }`.html` files since that's what Nanoc actually serves.
    def run(content, params = {})
      content.gsub(/href="(\S*.md\S*)"/) do |result| # Fetch all links in the HTML Document
        if /http/.match(result).nil? # Check if link is internal
          result.gsub!(/\.md/, '.html') # Replace the extension if link is internal
        end
        result
      end
    end
  end
end
