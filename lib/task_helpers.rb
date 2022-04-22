require 'yaml'

PRODUCTS = %w[ee omnibus runner charts operator].freeze
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
    when 'operator'
      "master"
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

#
# The charts versions do not follow the same GitLab major number, BUT
# they do follow a pattern https://docs.gitlab.com/charts/installation/version_mappings.html:
#
# 1. The minor version is the same for both
# 2. The major version augments for both at the same time
#
# This means we can deduct the charts version from the GitLab version, since
# the major charts version is always 9 versions behind its GitLab counterpart.
#
def chart_version(gitlab_version)
  major, minor = gitlab_version.split('.')

  # Assume major charts version is nine less than major GitLab version.
  # If this breaks and the version isn't found, it might be because they
  # are no longer exactly 9 releases behind. Ask the distribution team
  # about it.
  major = major.to_i - 9

  "#{major.to_s}.#{minor}"
end

def default_branch(repo)
  # Get the URL-encoded path of the project
  # https://docs.gitlab.com/ee/api/README.html#namespaced-path-encoding
  url_encoded_path = repo.sub('https://gitlab.com/', '').sub('.git', '').gsub('/', '%2F')

  `curl --silent https://gitlab.com/api/v4/projects/#{url_encoded_path} | jq --raw-output .default_branch`.tr("\n", '')
end
