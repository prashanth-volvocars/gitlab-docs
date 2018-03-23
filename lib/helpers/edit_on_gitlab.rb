module Nanoc::Helpers
  module EditOnGitLab
    def edit_on_gitlab(item)
      # Make an array out of the content's source path.
      content_filename_array = @item[:content_filename].split('/')
      # Remove "/content/"
      content_filename_array.shift
      # Get the product name.
      product = content_filename_array.shift
      # This should be the path from the doc/ directory for a given file.
      docs_content_filename = content_filename_array.join("/")

      if product == "omnibus"
        # omnibus-gitlab repo
        gitlab_url = "https://gitlab.com/gitlab-org/#{product}-gitlab/edit/master/doc/#{docs_content_filename}"
      elsif product == "runner"
        # gitlab-runner repo
        gitlab_url = "https://gitlab.com/gitlab-org/gitlab-#{product}/edit/master/docs/#{docs_content_filename}"
      elsif (product == "ce" or product == "ee")
        # gitlab-ce and gitlab-ee repos
        gitlab_url = "https://gitlab.com/gitlab-org/gitlab-#{product}/edit/master/doc/#{docs_content_filename}"
      else
        # gitlab-docs pages
        gitlab_url = "https://gitlab.com/gitlab-com/gitlab-docs/edit/master/#{@item[:content_filename]}"
      end

      result = "<a href='#{gitlab_url}'>Edit this page</a>"
    end
  end
end
