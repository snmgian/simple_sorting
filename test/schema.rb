ActiveRecord::Schema.define(:version => 0) do
  create_table :associations, :force => true do |t|
    t.string :name
  end

  create_table :planets, :force => true do |t|
    t.string :name
  end

  create_table :people, :force => true do |t|
    t.string :name
    t.integer :age
    t.integer :association_id
    t.integer :planet_of 
  end

  create_table :ties, :force => true do |t|
    t.string :color
    t.integer :person_id
  end

  create_table :umbrellas, :force => true do |t|
    t.string :color
    t.integer :owner_id
  end
end 

