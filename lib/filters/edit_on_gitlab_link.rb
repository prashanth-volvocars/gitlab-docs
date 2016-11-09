module Nanoc::Filters
  class EditOnGitLabLink < Nanoc::Filter
    identifier :edit_on_gitlab_link

    def run(content, params = {})
      # Returns the source content's path.
      content_filename = @item[:content_filename]
      # Make an array out of the path
      content_filename_array = content_filename.split('/')
      # Remove "/content/"
      content_filename_array.shift
      # Get the product name.
      product = content_filename_array.shift
      # This should be the path from the doc/ directory for a given file.
      content_filename = content_filename_array.join("/")

      # Replace `EDIT_ON_GITLAB_LINK` with the actual URL pointing to
      # the source file.
      content.gsub(/href="(EDIT_ON_GITLAB_LINK)"/) do |result|
        if product == "omnibus"
          # omnibus-gitlab repo
          result.gsub!(/EDIT_ON_GITLAB_LINK/, "https://gitlab.com/gitlab-org/#{product}-gitlab/blob/master/doc/#{content_filename}")
        elsif product == "runner"
          # omnibus-gitlab repo
          result.gsub!(/EDIT_ON_GITLAB_LINK/, "https://gitlab.com/gitlab-org/gitlab-ci-multi-#{product}/blob/master/docs/#{content_filename}")
        else
          # gitlab-ce and gitlab-ee repos
          result.gsub!(/EDIT_ON_GITLAB_LINK/, "https://gitlab.com/gitlab-org/gitlab-#{product}/blob/master/doc/#{content_filename}")
        end
        result
      end
    end
  end
end
