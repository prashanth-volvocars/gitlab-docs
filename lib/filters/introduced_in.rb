# Adapted from the admonition code on http://nanoc.ws/
class IntroducedInFilter < Nanoc::Filter
  identifier :introduced_in

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    @incremental_id = 0
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('blockquote').each do |blockquote|
      content = blockquote.inner_html
      next if content !~ /(<a href="[^"]+">)?((introduced(<\/a>)? in)|(moved(<\/a>)? to))(<a href="[^"]+">)?.*GitLab/mi
      new_content = generate(content)
      blockquote.replace(new_content)
    end
    doc.to_s
  end

  def generate(content)
    @incremental_id += 1
    # If the content is a list of items, collapse the content.
    if content =~ /<ul>/i
      %(<div class="introduced-in mb-3">Version history) +
        %(<button class="text-expander" data-toggle="collapse" href="#release_version_notes_#{@incremental_id}" role="button" aria-expanded="false">) +
        %(</button>) +
        %(<div class="introduced-in-content collapse" id="release_version_notes_#{@incremental_id}">#{content}</div></div>)
    else
      %(<div class="introduced-in">#{content}</div>)
    end
  end
end
