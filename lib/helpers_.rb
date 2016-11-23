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

  PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u

  def header(text, header_level)
    # https://gitlab.com/gitlab-org/gitlab-ce/blob/0676c5c7140ccf5b809eddab79b6fb78b7db0a66/lib/banzai/filter/table_of_contents_filter.rb#L29-32
    anchor = text.downcase
    anchor.gsub!(PUNCTUATION_REGEXP, '-') # replace punctuation with dash
    anchor.tr!(' ', '-') # replace spaces with dash
    anchor.squeeze!('-') # replace multiple dashes with one

    "<h#{header_level} id='#{anchor}'>#{text} <a class='anchor' href='##{anchor}' title='Permalink'>&para;</a></h#{header_level}>"
  end

  def image(link, title, alt_text)
    %(<a target="_blank" href="#{link}"><img src="#{link}" title="#{title}" alt="#{alt_text}"/></a>)
  end
end
