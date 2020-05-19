# frozen_string_literal: true

module Nanoc::Helpers
  module Generic
    #
    # Check if NANOC_ENV is set to production
    #
    def is_production?
      ENV['NANOC_ENV'] == 'production'
    end
  end
end
