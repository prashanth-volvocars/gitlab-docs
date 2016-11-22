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
    anchor = text.downcase.strip.split(" ").join("-")

    "<h#{header_level} id='#{anchor}'>#{text} <a class='anchor' href='##{anchor}' title='Permalink'>&para;</a></h#{header_level}>"
  end
end
