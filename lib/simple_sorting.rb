require 'simple_sorting/association_sorting'
require 'simple_sorting/simple_sorting_controller'
require 'simple_sorting/simple_sorting_helper'
require 'simple_sorting/sorting'

ActiveRecord::Base.extend(SimpleSorting::AssociationSorting)
ActiveRecord::Base.extend(SimpleSorting::Sorting)

ActionController::Base.send :include, SimpleSortingController

ActionView::Base.send :include, SimpleSortingHelper
