# frozen_string_literal: true

module Nanoc::Filters
  # @api private
  class GitLabKramdown < Nanoc::Filter
    identifier :gitlab_kramdown

    requires 'kramdown'

    # Runs the content through [GitLab Kramdown](https://gitlab.com/brodock/gitlab_kramdown).
    # Parameters passed to this filter will be passed on to Kramdown.
    #
    # @param [String] content The content to filter
    #
    # @return [String] The filtered content
    def run(content, params = {})
      params = params.dup
      warning_filters = params.delete(:warning_filters)
      toc_patch = <<~PATCH
      * TOC
      {:toc}

      PATCH

      document = ::Kramdown::Document.new(toc_patch+content, params)

      if warning_filters
        r = Regexp.union(warning_filters)
        warnings = document.warnings.reject { |warning| r =~ warning }
      else
        warnings = document.warnings
      end

      if warnings.any?
        $stderr.puts "kramdown warning(s) for #{@item_rep.inspect}"
        warnings.each do |warning|
          $stderr.puts "  #{warning}"
        end
      end

      document.to_html
    end
  end
end
