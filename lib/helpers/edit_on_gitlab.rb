module Nanoc::Helpers
  module EditOnGitLab
    def edit_on_gitlab(item, editor: :simple)
      # Make an array out of the content's source path.
      content_filename_array = @item[:content_filename].split('/')
      # Remove "/content/"
      content_filename_array.shift
      # Get the product name.
      product = content_filename_array.shift
      # This should be the path from the doc/ directory for a given file.
      docs_content_filename = content_filename_array.join("/")
      root_dir = File.expand_path('../../', __dir__)

      if product == "omnibus"
        # omnibus-gitlab repo
        gitlab_url = "https://gitlab.com/gitlab-org/#{product}-gitlab/blob/master/doc/#{docs_content_filename}"
        gitlab_ide_url = "https://gitlab.com/-/ide/project/gitlab-org/#{product}-gitlab/edit/master/-/doc/#{docs_content_filename}"
      elsif product == "runner"
        # gitlab-runner repo
        gitlab_url = "https://gitlab.com/gitlab-org/gitlab-#{product}/blob/master/docs/#{docs_content_filename}"
        gitlab_ide_url = "https://gitlab.com/-/ide/project/gitlab-org/gitlab-#{product}/edit/master/-/docs/#{docs_content_filename}"
      elsif product == "charts"
        # GitLab Helm chart repo
        gitlab_url = "https://gitlab.com/#{product}/gitlab/blob/master/doc/#{docs_content_filename}"
        gitlab_ide_url = "https://gitlab.com/-/ide/project/#{product}/gitlab/edit/master/-/doc/#{docs_content_filename}"
      elsif %w[ce ee].include?(product)
        # gitlab-ce and gitlab-ee repos
        if product == "ee"
          ce_file = File.join(root_dir, @item[:content_filename].sub(@config[:products][:ee][:dirs][:dest_dir], @config[:products][:ce][:dirs][:dest_dir]))
          product = "ce" if File.exists?(ce_file)
        end
        gitlab_url = "https://gitlab.com/gitlab-org/gitlab-#{product}/blob/master/doc/#{docs_content_filename}"
        gitlab_ide_url = "https://gitlab.com/-/ide/project/gitlab-org/gitlab-#{product}/edit/master/-/doc/#{docs_content_filename}"
      elsif product == "debug"
        gitlab_url = "https://gitlab.com/debugging/#{product}/blob/master/content/#{docs_content_filename}"
        gitlab_ide_url = "https://gitlab.com/-/ide/project/debugging/#{product}/edit/master/-/content/#{docs_content_filename}"
      else
        # gitlab-docs pages
        gitlab_url = "https://gitlab.com/gitlab-com/gitlab-docs/blob/master/#{@item[:content_filename]}"
        gitlab_ide_url = "https://gitlab.com/-/ide/project/gitlab-com/gitlab-docs/edit/master/-/#{@item[:content_filename]}"
      end

      case editor
      when :simple
        gitlab_url
      when :webide
        gitlab_ide_url
      else
        raise "Unknown editor: #{editor}"
      end
    end
  end
end
