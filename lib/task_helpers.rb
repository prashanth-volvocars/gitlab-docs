require 'yaml'

PRODUCTS = %W[ce ee omnibus runner].freeze

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
  ENV.fetch("BRANCH_#{slug.upcase}", 'master')
end

def git_workdir_dirty?
  status = `git status --porcelain`
  !status.empty?
end
