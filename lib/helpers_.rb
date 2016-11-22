include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::ChildParentBetter

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def header(text, header_level)
    anchor = text.downcase.strip.split(" ").join("-")

    "<h#{header_level} id='#{anchor}'>#{text} <a class='anchor' href='##{anchor}' title='Permalink'>&para;</a></h#{header_level}>"
  end

  def image(link, title, alt_text)
    %(<a target="_blank" href="#{link}"><img src="#{link}" title="#{title}" alt="#{alt_text}"/></a>)
  end
end
