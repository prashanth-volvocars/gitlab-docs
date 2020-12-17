# frozen_string_literal: true

module Nanoc::Helpers
  module Generic
    #
    # Check if NANOC_ENV is set to production
    #
    def production?
      ENV['NANOC_ENV'] == 'production'
    end

    def omnibus?
      ENV['NANOC_ENV'] == 'omnibus'
    end
  end
end
