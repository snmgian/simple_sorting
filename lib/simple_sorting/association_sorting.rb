module SimpleSorting

  # This module utilizes method_missing to hook a posible invocation to a sorting method, 
  # creates a named scope with sorting capabilities and with the invoked name,
  # finally invokes the newly created named scope.
  #
  # The sorting methods that handles are whose that sort by a column of a belongs_to or has_one association.
  module AssociationSorting

    private
    def method_missing(name, *args, &block)
      name = name.to_s
      details = association_sorting_condition_details_bt(name)
      details ||= association_sorting_condition_details_ho(name)
      if details
        create_association_sorting_condition(name, details[:order_as], details[:a_macro], details[:a_table], details[:a_pk], details[:a_fk], details[:column])
        send(name, *args)
      else
        super
      end
    end
    
    # Parse the name argument and retrieves:
    #   order_as -> ASC or DESC
    #   association_macro -> :belongs_to
    #   association_table
    #   association_primary_key
    #   association_foreign_key
    #   column from association table to apply the sorting operation
    #
    # This method applies to :belongs_to associations
    # The name argument must match the following format:
    #   (asc|desc)_by_(association_name)_(column_name)
    # else return nil
    def association_sorting_condition_details_bt(name)
      associations = reflect_on_all_associations :belongs_to
      association_names = associations.collect { |a| a.name }

      if name =~ /^(asc|desc)_by_(#{association_names.join("|")})_(\w+)$/

        a = associations.find { |a| a.name == $2.to_sym }
        a_table = a.klass.table_name
        a_pk = primary_key

        a_fk = if a.options.include? :foreign_key
          a.options[:foreign_key]
        else
          a.name.to_s + "_id"
        end

        a_join = 'LEFT'

        d = {:order_as => $1.upcase, :a_macro => a.macro, :a_table => a_table, :a_pk => a_pk, :a_fk => a_fk, :column => $3}
      end
    end
    
    # Parse the name argument and retrieves:
    #   order_as -> ASC or DESC
    #   association_macro -> :belongs_to
    #   association_table
    #   association_primary_key
    #   association_foreign_key
    #   column from association table to apply the sorting operation
    #
    # This method applies to :has_one associations
    # The name argument must match the following format:
    #   (asc|desc)_by_(association_name)_(column_name)
    # else return nil
    def association_sorting_condition_details_ho(name)
      associations = reflect_on_all_associations :has_one
      association_names = associations.collect { |a| a.name }

      if name =~ /^(asc|desc)_by_(#{association_names.join("|")})_(\w+)$/

        a = associations.find { |a| a.name == $2.to_sym }
        a_pk = table_name + "." + primary_key

        a_bt = (a.klass.reflect_on_all_associations(:belongs_to).select do |a_remote|
          a_remote.klass == self
        end).first

        a_table = a.klass.table_name

        a_fk = if a_bt.options.include? :foreign_key
          a_bt.options[:foreign_key]
        else
          a_bt.name.to_s + "_id"
        end

        d = {:order_as => ($1).upcase, :a_macro => a.macro, :a_table => a_table, :a_pk => a_pk, :a_fk => a_fk, :column => $3}
      end
    end

    # Creates a named scope for sorting purposes: 
    # named_scope :asc_by_asociation_column, :joins => 'LEFT JOIN ... ON ...', :order => "people.id ASC"
    def create_association_sorting_condition(name, order_as, a_macro, a_table, a_pk, a_fk, column)
      sql_join = if a_macro == :belongs_to
                   "LEFT JOIN #{a_table} ON #{a_table}.#{a_pk} = #{a_fk}"
                 elsif a_macro == :has_one
                   "LEFT JOIN #{a_table} ON #{a_table}.#{a_fk} = #{a_pk}"
                 end
      named_scope(name.to_sym, { :joins => sql_join, :order => "#{a_table}.#{column} #{order_as}" })
    end
  end
end
