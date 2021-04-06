require_relative '../helpers/generic'
require_relative '../helpers/icons_helper'

module Gitlab
  class Navigation
    include Nanoc::Helpers::Generic
    include Nanoc::Helpers::IconsHelper

    def initialize(items, item)
      @items = items
      @item = item

      disable_inactive_sections!
      omnibus_only_items!
    end

    def nav_items
      @nav_items ||= items["/_data/navigation.yaml"]
    end

    def element_href(element)
      "/#{element.url}"
    end

    def show_element?(element)
      item.path == "/#{element.url}"
    end

    def id_for(element)
      element.title.gsub(/[\s\/\(\)]/, '')
    end

    def children
      @children ||= nav_items.fetch(:sections, []).map { |section| Section.new(section) }
    end

    private

    attr_reader :items, :item

    def disable_inactive_sections!
      return unless omnibus?

      children.each do |section|
        section.disable! unless has_active_element?([section])
      end
    end

    # Remove sections and categories menu items missing in Omnibus
    def omnibus_only_items!
      return unless omnibus?

      children.filter! do |section|
        if allowed_link?(section.url)
          section.children.filter! { |category| allowed_link?(category.url) }
          true
        end
      end
    end

    def allowed_link?(link)
      link.start_with?('ee/') || link.start_with?('http')
    end

    def has_active_element?(collection)
      return false unless collection

      collection.any? { |element| show_element?(element) || has_active_element?(element.children) }
    end

    def dir
      @dir ||= item.identifier.to_s[%r{(?<=/)[^/]+}]
    end

  end
end
