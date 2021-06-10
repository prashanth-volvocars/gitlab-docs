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
      # Searches for a blockquote with either of the following:
      #
      # - Specific strings:
      #   - "introduced <optional text> in"
      #   - "removed <optional text> in"
      #   - "deprecated <optional text> in"
      #   - "moved <optional text> to"
      #   ...followed by "GitLab"
      #
      # - The presense of "**(VERSION_INFO)**" or "- **(VERSION_INFO)**"

      next unless content =~ %r{(<a href="[^"]+">)?(introduced|(re)?moved|deprecated)(</a>)?(.*)? (in|to).*GitLab}mi || content =~ %r{(<li>)?<strong>\(VERSION_INFO\)</strong>(</li>)?}mi

      content.gsub!(%r{(<li>)?<strong>\(VERSION_INFO\)</strong>(</li>)?}, "")
      new_content = generate(content)
      blockquote.replace(new_content)
    end
    doc.to_s
  end

  def generate(content)
    @incremental_id += 1
    # If the content is a list of items, collapse the content.
    if content.match?(/<ul>/i)
      %(<div class="introduced-in mb-3">Version information
          <button class="text-expander" type="button" data-toggle="collapse" data-target="#release_version_notes_#{@incremental_id}" aria-expanded="false" aria-controls="release_version_notes_#{@incremental_id}" aria-label="Version information">
          </button>
          <div class="introduced-in-content collapse" id="release_version_notes_#{@incremental_id}">
            #{content}
          </div>
        </div>)
    else
      %(<div class="introduced-in">#{content}</div>)
    end
  end
end
