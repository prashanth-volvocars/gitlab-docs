# Adapted from the admonition code on http://nanoc.ws/
class AdmonitionFilter < Nanoc::Filter
  identifier :admonition

  BOOTSTRAP_MAPPING = {
    'note' => 'info',
    'warning' => 'warning'
  }.freeze

  GITLAB_SVGS_MAPPING = {
    'note' => 'information-o',
    'warning' => 'warning'
  }.freeze

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('p').each do |para|
      content = para.inner_html
      match = content.match(/\A(?<type>NOTE|WARNING):\s?(?<content>.*)\Z/m)
      next unless match

      new_content = generate(match[:type].downcase, match[:content])
      para.replace(new_content)
    end
    doc.to_s
  end

  def generate(kind, content)
    %(<div class="admonition-wrapper #{kind}">) +
      %(<div class="admonition alert alert-#{BOOTSTRAP_MAPPING[kind]}">) +
      %(#{icon(GITLAB_SVGS_MAPPING[kind])}#{content}</div></div>)
  end
end
