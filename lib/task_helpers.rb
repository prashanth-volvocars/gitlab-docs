require 'yaml'

PRODUCTS = %W[ce ee omnibus runner charts debug].freeze
VERSION_FORMAT = /^(?<major>\d{1,2})\.(?<minor>\d{1,2})$/

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
  # If we're on a stable branch, catch the version and
  # assign the product branches correctly.
  if version = ENV["CI_COMMIT_REF_NAME"].match(VERSION_FORMAT)
    case slug
    when 'ee'
      "#{version[:major]}-#{version[:minor]}-stable-ee"
    when 'ce', 'omnibus', 'runner'
      "#{version[:major]}-#{version[:minor]}-stable"
    # Charts don't use the same version scheme as GitLab, we need to
    # deduct their version from the GitLab equivalent one.
    when 'charts'
      chart = chart_version(ENV["CI_COMMIT_REF_NAME"]).match(VERSION_FORMAT)
      "#{chart[:major]}-#{chart[:minor]}-stable"
    # For all other products use master
    else
      'master'
    end
  else
    ENV.fetch("BRANCH_#{slug.upcase}", 'master')
  end
end

def git_workdir_dirty?
  status = `git status --porcelain`
  !status.empty?
end

def chart_version(gitlab_version)
  config = YAML.load_file('./content/_data/chart_versions.yaml')

  config.fetch(gitlab_version)
end
