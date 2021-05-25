# frozen_string_literal: true

module Nanoc::Helpers
  module VersionsDropdown
    STABLE_VERSIONS_REGEX = /^\d{1,2}\.\d{1,2}$/.freeze

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
    # Determines whether or not to display the version banner on the frontend.
    #
    # Note: We only want the banner to display on production.
    # Production is the only environment where we serve multiple versions.
    #
    def show_version_banner?
      production? && !latest?
    end

    #
    # Check if the current version is the latest.
    #
    def latest?
      latest_version = @items['/_data/versions.yaml'][:online][0]
      ENV['CI_COMMIT_REF_NAME'] == ENV['CI_DEFAULT_BRANCH'] || ENV['CI_COMMIT_REF_NAME'] == latest_version
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

    def data_versions
      @items['/_data/versions.yaml']
    end

    def next_version
      latest_stable = data_versions[:online].first
      latest_major, latest_minor = latest_stable.split('.')
      _, last_minor = data_versions[:last_before_new_major].first.split('.')

      #
      # If the minor version of the latest online version
      # is equal to last_minor, bump the major version
      # and set patch to 0. This is for the case where a new
      # major version is the next version to be released.
      #
      if latest_minor == last_minor
        "#{latest_major.to_i + 1}.0"
      else
        "#{latest_major}.#{latest_minor.to_i + 1}"
      end
    end

    def dotcom
      "GitLab.com (#{next_version}-pre)"
    end

    def version_dropdown_title
      return 'Archives' if archives?
      return 'Versions' unless production?

      if ENV['CI_COMMIT_REF_NAME'] == ENV['CI_DEFAULT_BRANCH']
        dotcom
      else
        ENV['CI_COMMIT_REF_NAME']
      end
    end

    def display_previous_versions?
      !omnibus?
    end
  end
end
