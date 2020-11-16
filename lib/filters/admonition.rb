# Adapted from the admonition code on http://nanoc.ws/
class AdmonitionFilter < Nanoc::Filter
  identifier :admonition

  BOOTSTRAP_MAPPING = {
    'tip' => 'success',
    'note' => 'info',
    'caution' => 'warning',
    'danger' => 'danger'
  }.freeze

  FONT_AWESOME_MAPPING = {
    'note' => 'info-circle',
    'tip' => 'pencil',
    'caution' => 'exclamation-triangle',
    'danger' => 'bolt'
  }.freeze

  def run(content, params = {})
    # `#dup` is necessary because `.fragment` modifies the incoming string. Ew!
    # See https://github.com/sparklemotion/nokogiri/issues/1077
    doc = Nokogiri::HTML.fragment(content.dup)
    doc.css('p').each do |para|
      content = para.inner_html
      next if content !~ /\A(TIP|NOTE|CAUTION|DANGER): (.*)\Z/m

      new_content = generate($1.downcase, $2)
      para.replace(new_content)
    end
    doc.to_s
  end

  def generate(kind, content)
    %(<div class="admonition-wrapper #{kind}">) +
      %(<div class="admonition alert alert-#{BOOTSTRAP_MAPPING[kind]}">) +
      %(<i class="fa fa-#{FONT_AWESOME_MAPPING[kind]} fa-fw" aria-hidden="true"></i>#{content}</div></div>)
  end
end
