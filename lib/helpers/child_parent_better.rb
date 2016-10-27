module Nanoc::Helpers
  module ChildParentBetter
    # Returns an array of ancestor pages for the given page.
    def ancestor_path_array(item)
      parent_array = Array.new
      current_item = item
      # Until the current item has no parent, keep running.
      until (get_nearest_parent(current_item.identifier.to_s).nil?) do
        # Set the current item to the last item in the array
        # unless this is the first item.
        current_item = parent_array.last unless parent_array.empty?
        # Get the nearest parent of the current item.
        parent = get_nearest_parent(current_item.identifier.to_s)
        # Push the parent of the current item into the array.
        parent_array.push(parent) if parent
      end

      parent_array
    end

    # A recursive function which returns the nearest parent item for the
    # given path.
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
