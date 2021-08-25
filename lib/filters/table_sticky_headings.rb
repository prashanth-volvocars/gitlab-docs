# frozen_string_literal: true

#
# Wrap tables inside a div so we can apply CSS styles to them
# https://gitlab.com/gitlab-org/gitlab-docs/-/issues/1076
#
class TableStickyHeadings < Nanoc::Filter
  identifier :table_sticky_headings

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('table').each do |table|
      content = table.to_html
      new_content = generate(content)
      table.replace(new_content)
    end
    doc.to_s
  end

  def generate(content)
    %(<div class="table-sticky-headings">#{content}</div>)
  end
end
