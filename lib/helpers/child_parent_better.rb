module Nanoc::Helpers
  module ChildParentBetter
    def parent_path(item)
      parent = get_nearest_parent(item.identifier.to_s)
      parent
    end

    # Recursion!
    def get_nearest_parent(item_identifier)
      if (item_identifier.nil? || (item_identifier.to_s.end_with?('README.md') && item_identifier.to_s.split('/').length == 3))
        return
      elsif item_identifier.to_s.end_with?('README.md')
        parent_dir = item_identifier.sub(/[^\/]+$/, '').chop
        get_nearest_parent(parent_dir)
      else
        parent_dir = item_identifier.sub(/[^\/]+$/, '').chop
        parent = @items[parent_dir + '/README.*']
        if parent.nil?
          get_nearest_parent(parent_dir)
        else
          return parent
        end
      end
    end
  end
end
