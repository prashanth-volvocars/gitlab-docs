# Adapted from the admonition code on http://nanoc.ws/
class AdmonitionFilter < Nanoc::Filter
  identifier :admonition

  BOOTSTRAP_MAPPING = {
    'note' => 'note',
    'warning' => 'warning',
    'flag' => 'flag',
    'info' => 'info'
  }.freeze

  GITLAB_SVGS_MAPPING = {
    'note' => 'information-o',
    'warning' => 'warning',
    'flag' => 'flag',
    'info' => 'tanuki'
  }.freeze

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('p').each do |para|
      content = para.inner_html
      match = content.match(/\A(?<type>NOTE|WARNING|FLAG|INFO):\s?(?<content>.*)\Z/m)
      next unless match

      new_content = generate(match[:type].downcase, match[:content])
      para.replace(new_content)
    end
    doc.to_s
  end

  def generate(kind, content)
    %(<div class="mt-3 admonition-wrapper #{kind}">) +
      %(<div class="admonition admonition-non-dismissable alert alert-#{BOOTSTRAP_MAPPING[kind]}">) +
      %(<div>#{icon(GITLAB_SVGS_MAPPING[kind], 16, 'alert-icon')}<div role="alert"><div class="alert-body">#{content}</div></div></div></div></div>)
  end
end
