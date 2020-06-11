# frozen_string_literal: true

module Nanoc::Filters
  # @api private
  class GitLabKramdown < Nanoc::Filter
    requires 'kramdown'

    identifier :gitlab_kramdown

    TOC_PATCH = <<~PATCH
      * TOC
      {:toc}

    PATCH

    # Runs the content through [GitLab Kramdown](https://gitlab.com/brodock/gitlab_kramdown).
    # Parameters passed to this filter will be passed on to Kramdown.
    #
    # @param [String] raw_content The content to filter
    #
    # @return [String] The filtered content
    def run(raw_content, params = {})
      params = params.dup
      warning_filters = params.delete(:warning_filters)
      with_toc = params.delete(:with_toc)

      content = with_toc ? TOC_PATCH+raw_content : raw_content
      document = ::Kramdown::Document.new(content, params)

      if warning_filters
        r = Regexp.union(warning_filters)
        warnings = document.warnings.reject { |warning| r =~ warning }
      else
        warnings = document.warnings
      end

      if warnings.any?
        $stderr.puts "\nkramdown warning(s) for #{@item_rep.inspect}"
        warnings.each do |warning|
          $stderr.puts "  #{warning}"
        end
      end

      document.to_html
    end
  end
end
