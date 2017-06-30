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


  def header(text, header_level)
    # https://github.com/cookpad/garage/blob/c817733e382c734eedba743e9103cd8a124f24eb/lib/garage/docs/anchor_building.rb#L24
    anchor = text.gsub(/\s+/, '-').gsub(/<\/?[^>]*>/, '').downcase
    # https://github.com/rails/rails/blob/e491b2c06329afb3c989261a2865d2a93c8b84b8/activesupport/lib/active_support/inflector/transliterate.rb#L86
    anchor.gsub!(/[^a-z0-9\-_]+/i, '-')
    anchor.squeeze!('-')        # replace multiple dashes with one
    anchor.gsub!(/^-|-$/, '')   # remove any first or last dashes

    %(<h#{header_level} id='#{anchor}'>#{text} <a class='anchor' href='##{anchor}' title='Permalink'></a></h#{header_level}>)
  end

  def image(link, title, alt_text)
    %(<a target="_blank" href="#{link}"><img src="#{link}" title="#{title}" alt="#{alt_text}"/></a>)
  end
end
