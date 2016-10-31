include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::ChildParentBetter

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
