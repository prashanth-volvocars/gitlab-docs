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
  # If CI_COMMIT_REF_NAME is not defined, set it to master.
  if ENV["CI_COMMIT_REF_NAME"].nil?
    'master'
  # If we're on a gitlab-docs stable branch according to the regex, catch the
  # version and assign the product stable branches correctly.
  elsif version = ENV["CI_COMMIT_REF_NAME"].match(VERSION_FORMAT)
    case slug
    # EE has different branch name scheme
    when 'ee'
      "#{version[:major]}-#{version[:minor]}-stable-ee"
    when 'ce', 'omnibus', 'runner'
      "#{version[:major]}-#{version[:minor]}-stable"
    # For all other products (see charts), use master
    else
      'master'
    end
  # If we're NOT on a gitlab-docs stable branch, fetch the BRANCH_* environment
  # variable, and if not assigned, set to master.
  else
    ENV.fetch("BRANCH_#{slug.upcase}", 'master')
  end
end

def git_workdir_dirty?
  status = `git status --porcelain`
  !status.empty?
end
