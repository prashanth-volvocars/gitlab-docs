module Nanoc::Helpers
  module ChildParentBetter
    def parent_path_array(item)
      parent_array = Array.new
      current_item = item
      until (parent_path(current_item).nil?) do
        if (parent_array.length == 0)
          parent = parent_path(item)
          parent_array.push(parent) if parent
        else
          parent = parent_path(parent_array.last)
          current_item = parent_array.last
          parent_array.push(parent) if parent
        end
      end
      parent_array
    end

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
        return get_nearest_parent(parent_dir)
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
