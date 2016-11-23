include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::ChildParentBetter
include Nanoc::Helpers::EditOnGitLab

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def image(link, title, alt_text)
    %(<a target="_blank" href="#{link}"><img src="#{link}" title="#{title}" alt="#{alt_text}"/></a>)
  end
end
