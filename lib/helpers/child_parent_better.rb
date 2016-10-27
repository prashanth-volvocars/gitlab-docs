module Nanoc::Helpers
  module ChildParentBetter
    def parent_path(item)
      if item.identifier.to_s.end_with?('README.md')
        path_without_last_component = item.identifier.to_s.sub(/[^\/]+$/, '').chop
        path_without_last_component = path_without_last_component.to_s.sub(/[^\/]+$/, '').chop
        parent = @items[path_without_last_component + '/README.*']
      else
        path_without_last_component = item.identifier.to_s.sub(/[^\/]+$/, '').chop
        parent = @items[path_without_last_component + '/README.*']
      end

      if parent.nil?
        path_without_last_component = path_without_last_component.sub(/[^\/]+$/, '').chop
        parent = @items[path_without_last_component + '/README.*']
      end
      # puts "#{item.identifier.to_s}, #{parent.identifier.to_s if parent}"
      parent
    end

    def children_of(item)
      if item.identifier.legacy?
        item.children
      else
        pattern = item.identifier.without_ext + '/*'
        @items.find_all(pattern)
      end
    end
  end
end
