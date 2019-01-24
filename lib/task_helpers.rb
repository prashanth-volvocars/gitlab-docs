require 'yaml'

PRODUCTS = %W[ce ee omnibus runner debug].freeze
VERSION_FORMAT = /^(\d{1,2})\.(\d{1,2})$/

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
      "#{version[1]}-#{version[2]}-stable-ee"
    when 'ce', 'omnibus', 'runner'
      "#{version[1]}-#{version[2]}-stable"
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
