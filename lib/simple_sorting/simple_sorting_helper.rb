module SimpleSortingHelper

  # Displays a link with sorting params
  #   text -> text to be displayed
  #   sort_field -> field name for sorting, its value could be in simple form like 'name' or in association form like 'tie.color'
  #   options -> options that will be passed to link_to helper
  #
  # The sorting direction is extracted from the request params or defaults to 'asc'
  def sort_link(text, sort_field, options = {})
    sort_field = sort_field.gsub '.', '_'
    
    sort_dir = params[:sort_field] == sort_field && params[:sort_dir] == 'asc' ? 'desc' : 'asc'

    link_to "#{text}", request.parameters.merge( {:sort_field => sort_field, :sort_dir => sort_dir} ), options 
  end

end

