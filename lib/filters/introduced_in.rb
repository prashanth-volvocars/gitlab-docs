# Adapted from the admonition code on https://nanoc.app
class IntroducedInFilter < Nanoc::Filter
  identifier :introduced_in

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('blockquote').each do |blockquote|
      content = blockquote.inner_html
      # Searches for a blockquote with either:
      # - "deprecated <optional text> in"
      # - "introduced <optional text> in"
      # - "moved <optional text> to"
      # - "recommended <optional text> in"
      # - "removed <optional text> in"
      # - "renamed <optional text> in"
      # - "changed <optional text> in"
      # ...followed by "GitLab"
      next unless content.match?(%r{(<a href="[^"]+">)?(introduced|(re)?moved|changed|deprecated|renamed|recommended)(</a>)?(.*)? (in|to).*GitLab}mi)

      new_content = generate(content)
      blockquote.replace(new_content)
    end
    doc.to_s
  end

  def generate(content)
    %(<div class="introduced-in">#{content}</div>)
  end
end
