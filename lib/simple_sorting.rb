puts "in simple_sort"
puts ActiveSupport::Dependencies.load_paths

require 'simple_sorting/association_sorting'
require 'simple_sorting/simple_sorting_controller'
require 'simple_sorting/simple_sorting_helper'
require 'simple_sorting/sorting'

=begin
  path = File.join(File.dirname(__FILE__), 'app')  
  $LOAD_PATH << path 
  ActiveSupport::Dependencies.load_paths << path 
  ActiveSupport::Dependencies.load_once_paths.delete(path) 

%w{ models controllers helpers }.each do |dir| 
  path = File.join(File.dirname(__FILE__), 'app', dir)  
  $LOAD_PATH << path 
  ActiveSupport::Dependencies.load_paths << path 
  ActiveSupport::Dependencies.load_once_paths.delete(path) 
end
=end

puts ".."
puts ActiveSupport::Dependencies.load_paths
ActiveRecord::Base.extend(SimpleSorting::AssociationSorting)
ActiveRecord::Base.extend(SimpleSorting::Sorting)

ActionController::Base.send :include, SimpleSortingController
ActionView::Base.send :include, SimpleSortingHelper
