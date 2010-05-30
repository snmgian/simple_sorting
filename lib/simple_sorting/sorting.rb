module SimpleSorting 

  # This module utilizes method_missing to hook a posible invocation to a sorting method, 
  # creates a named scope with sorting capabilities and with the invoked name,
  # finally invokes the newly created named scope.
  #
  # The sorting methods that handles are whose sort by a column of a model.
  module Sorting

    private
    def method_missing(name, *args, &block)
      name = name.to_s
      details = sorting_condition_details(name)
      if details
        create_sorting_conditions(name, details[:column], details[:order_as])
        send(name, *args)
      else
        super
      end
    end

    # Parse the name argument and retrieves order_as and column values.
    # For order_as the posible values are: ASC, DESC 
    # 
    # The name argument must match the following format:
    #   (asc|desc)_by_(column_name)
    # else returns nil
    def sorting_condition_details(name)
      if name =~ /^(asc|desc)_by_(#{column_names.join("|")})$/
        {:order_as => $1.upcase, :column => $2}
      end
    end
    
    # Creates a named scope for sorting purposes: 
    # named_scope :asc_by_column, :order => "people.id ASC"
    def create_sorting_conditions(name, column, order_as)
        named_scope(name.to_sym, {:order => "#{table_name}.#{column} #{order_as}"})
    end
  end
end
