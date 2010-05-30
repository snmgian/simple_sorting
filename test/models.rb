class HickWall < ActiveRecord::Base
end

class WickWall < ActiveRecord::Base
end

class Association < ActiveRecord::Base
  has_many :members, :class_name => :person
end

class Planet < ActiveRecord::Base
  has_many :people
end

class Person < ActiveRecord::Base
  belongs_to :association
  belongs_to :planet, :foreign_key => 'planet_of'
  has_one :tie
  has_one :umbrella, :foreign_key => 'owner_id'
end

class Tie < ActiveRecord::Base
  belongs_to :person
end

class Umbrella < ActiveRecord::Base
  belongs_to :person, :foreign_key => 'owner_id'
end
