require 'yaml'

PRODUCTS = %w[ee omnibus runner charts].freeze
VERSION_FORMAT = /^(?<major>\d{1,2})\.(?<minor>\d{1,2})$/.freeze

def config
  # Parse the config file and create a hash.
  @config ||= YAML.load_file('./nanoc.yaml')
end

def products
  return @products if defined?(@products)

  # Pull products data from the config.
  @products = PRODUCTS.each_with_object({}) do |key, result|
    result[key] = config['products'][key]
  end
end

def retrieve_branch(slug)
  # If CI_COMMIT_REF_NAME is not defined (run locally), set it to the default branch.
  if ENV["CI_COMMIT_REF_NAME"].nil?
    default_branch(products[slug].fetch('repo'))
  # If we're on a gitlab-docs stable branch according to the regex, catch the
  # version and assign the product stable branches correctly.
  elsif version = ENV["CI_COMMIT_REF_NAME"].match(VERSION_FORMAT)
    case slug
    # EE has different branch name scheme
    when 'ee'
      "#{version[:major]}-#{version[:minor]}-stable-ee"
    when 'omnibus', 'runner'
      "#{version[:major]}-#{version[:minor]}-stable"
    # Charts don't use the same version scheme as GitLab, we need to
    # deduct their version from the GitLab equivalent one.
    when 'charts'
      chart = chart_version(ENV["CI_COMMIT_REF_NAME"]).match(VERSION_FORMAT)
      "#{chart[:major]}-#{chart[:minor]}-stable"
    end
  # If we're NOT on a gitlab-docs stable branch, fetch the BRANCH_* environment
  # variable, and if not assigned, set to the default branch.
  else
    ENV.fetch("BRANCH_#{slug.upcase}", default_branch(products[slug].fetch('repo')))
  end
end

def git_workdir_dirty?
  status = `git status --porcelain`
  !status.empty?
end

def local_branch_exist?(branch)
  status = `git branch --list #{branch}`
  !status.empty?
end

def chart_version_added?(gitlab_version)
  config = YAML.load_file('./content/_data/chart_versions.yaml')
  config.key?(gitlab_version)
end

def chart_version(gitlab_version)
  config = YAML.load_file('./content/_data/chart_versions.yaml')

  config.fetch(gitlab_version)
end

def default_branch(remote_url)
  `git remote show #{remote_url} | grep 'HEAD branch' | cut -d' ' -f5`.tr("\n", '')
end
