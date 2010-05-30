module SimpleSortingController

  # Sorts an active record finder with the given params sort_dir and sort_field
  def simple_sorting(finder, params = {})
    if !(params[:sort_dir] && params[:sort_field])
      finder.named_scope :no_simple_sorting
      return finder.no_simple_sorting
    end

    sorting_method = "#{params[:sort_dir]}_by_#{params[:sort_field]}"
    finder.send sorting_method
  end

end


