# frozen_string_literal: true

module Nanoc::Helpers
  module VersionsDropdown

    STABLE_VERSIONS_REGEX=/^\d{1,2}\.\d{1,2}$/

    #
    # Set the active class based on CI_COMMIT_REF_NAME and exclude if on
    # the archives page, otherwise we would end up with two active links.
    #
    def active_dropdown(selection)
      if archives?
        active_class if selection == 'archives'
      else
        active_class if selection == ENV['CI_COMMIT_REF_NAME']
      end
    end

    #
    # Check if we are on the /archives page
    #
    def archives?
      @item.identifier.to_s.split('/')[1] == 'archives'
    end

    #
    # Define the active CSS class
    #
    def active_class
      %( class="active")
    end

    #
    # Stable versions regexp
    #
    # At most two digits for major and minor numbers.
    #
    def stable_version?(version)
      version.match?(STABLE_VERSIONS_REGEX)
    end
  end
end
