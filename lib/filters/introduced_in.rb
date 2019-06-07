# encoding: utf-8

# Adapted from the admonition code on http://nanoc.ws/
class IntroducedInFilter < Nanoc::Filter

  identifier :introduced_in

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('blockquote').each do |blockquote|
      content = blockquote.inner_html
      next if content !~ /(<a href="[^"]+">)?Introduced(<\/a>)? in (<a href="[^"]+">)?GitLab/mi
      new_content = generate(content)
      blockquote.replace(new_content)
    end
    doc.to_s
  end

  def generate(content)
    %[<div class="introduced-in">] +
    content +
    %[</div>]
  end

end
