# frozen_string_literal: true

require 'json'

module Nanoc::Helpers
  module IconsHelper
    extend self

    def icons_sprite
      sprite_path = "node_modules/@gitlab/svgs/dist/icons.svg"

      %(<div class="d-none">#{read_file(sprite_path)}</div>)
    end

    def icon(icon_name, size = nil, css_class = nil)
      unless known_sprites.include?(icon_name)
        exception = ArgumentError.new("#{icon_name} is not a known icon in @gitlab-org/gitlab-svg")
        raise exception
      end

      svg_class = [
        'gl-icon',
        'ml-1',
        'mr-1',
        "s#{size || 16}",
        *css_class
      ].join(' ')

      %(<svg class="#{svg_class}"><use href="##{icon_name}" /></svg>)
    end

    private

    def read_file(path)
      root = File.expand_path('../../', __dir__)
      File.read("#{root}/#{path}")
    end

    def known_sprites
      @known_sprites ||= JSON.parse(read_file('node_modules/@gitlab/svgs/dist/icons.json'))['icons']
    end
  end
end
