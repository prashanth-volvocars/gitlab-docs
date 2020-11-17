Nanoc::Check.define(:internal_anchors) do
  output_html_filenames.each do |file|
    Gitlab::Docs::Page.new(file).links.each do |link|
      next unless link.internal?
      next unless link.to_anchor?
      next if link.anchor_name == 'markdown-toc'

      if link.destination_page_not_found?
        add_issue <<~ERROR
          Destination page not found!
                - source file `#{link.source_file}`
                - destination `#{link.destination_file}`
                - link `#{link.href}`
        ERROR
      elsif link.destination_anchor_not_found?
        add_issue <<~ERROR
          Broken anchor detected!
                - source file `#{link.source_file}`
                - destination `#{link.destination_file}`
                - link `#{link.href}`
                - anchor `##{link.anchor_name}`
        ERROR
      end
    end
  end
  add_issue "#{issues.count} offenses found!" if issues.count.positive?
end
