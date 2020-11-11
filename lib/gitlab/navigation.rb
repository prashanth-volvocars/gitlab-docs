module Gitlab
  class Navigation
    def initialize(items, item)
      @items = items
      @item = item
    end

    def nav_items
      @nav_items ||= nav_items_exists ? items[nav_items_dir] : items["/_data/default-nav.yaml"]
    end

    def element_href(element)
      is_ee_prefixed ? "/ee/#{element.url}" : "/#{dir}/#{element.url}"
    end

    def show_element?(element)
      item.path == "/#{dir}/#{element.url}"
    end

    def id_for(element)
      element.title.gsub(/[\s\/\(\)]/, '')
    end

    def optional_ee_badge(element)
      return unless element.ee_only?

      %[<span class="badges-drop global-nav-badges" data-toggle="tooltip" data-placement="top" title="Available in #{element.ee_tier}"><i class="fa fa-info-circle" aria-hidden="true"></i></span>]
    end

    def children
      @children ||= nav_items.fetch(:sections, []).map { |section| Section.new(section) }
    end

    private

    attr_reader :items, :item

    def dir
      @dir ||= item.identifier.to_s[%r{(?<=/)[^/]+}]
    end

    def nav_items_dir
      @nav_items_dir ||= "/_data/#{dir}-nav.yaml"
    end

    def nav_items_exists
      !items[nav_items_dir].nil?
    end

    def is_ee_prefixed
      !nav_items_exists && dir != 'ce'
    end
  end
end
