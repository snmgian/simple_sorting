require File.dirname(__FILE__) + '/test_helper.rb'

class AssociationSortingTest < Test::Unit::TestCase

  def test_order_for_has_one
    load_schema

    foo = Person.new(:name => 'Foo', :age => 38)
    bar = Person.new(:name => 'Bar', :age => 30)
    moo = Person.new(:name => 'Moo', :age => 54)
    foo.save; bar.save; moo.save
    
    blue = Tie.new(:color => 'blue', :person => foo)
    green = Tie.new(:color => 'green', :person => bar)
    red = Tie.new(:color => 'red', :person => moo)
    red.save; blue.save; green.save

    p = Person.asc_by_tie_color.all

    assert_equal p[0].tie.color, blue.color
    assert_equal p[1].tie.color, green.color
    assert_equal p[2].tie.color, red.color

    p = Person.desc_by_tie_color.all

    assert_equal p[0].tie.color, red.color
    assert_equal p[1].tie.color, green.color
    assert_equal p[2].tie.color, blue.color
  end

  def test_order_for_has_one_null
    load_schema

    foo = Person.new(:name => 'Foo', :age => 38)
    bar = Person.new(:name => 'Bar', :age => 30)
    moo = Person.new(:name => 'Moo', :age => 54)
    foo.save; bar.save; moo.save
    
    blue = Tie.new(:color => 'blue', :person => foo)
    yellow = Tie.new(:color => 'yellow')
    green = Tie.new(:color => 'green')
    red = Tie.new(:color => 'red', :person => moo)
    red.save; blue.save; green.save; yellow.save

    p = Person.asc_by_tie_color
    assert p.size == 3

    assert_nil p[0].tie
    assert_equal p[1].tie.color, blue.color
    assert_equal p[2].tie.color, red.color

    p = Person.desc_by_tie_color
    assert p.size == 3

    assert_equal p[0].tie.color, red.color
    assert_equal p[1].tie.color, blue.color
    assert_nil p[2].tie
  end

  def test_order_for_has_one_with_fk
    load_schema

    foo = Person.new(:name => 'Foo', :age => 38)
    bar = Person.new(:name => 'Bar', :age => 30)
    moo = Person.new(:name => 'Moo', :age => 54)
    foo.save; bar.save; moo.save
    
    blue = Umbrella.new(:color => 'blue', :person => foo)
    green = Umbrella.new(:color => 'green', :person => bar)
    red = Umbrella.new(:color => 'red', :person => moo)
    red.save; blue.save; green.save

    p = Person.asc_by_umbrella_color.all

    assert_equal p[0].umbrella.color, blue.color
    assert_equal p[1].umbrella.color, green.color
    assert_equal p[2].umbrella.color, red.color

    p = Person.desc_by_umbrella_color.all

    assert_equal p[0].umbrella.color, red.color
    assert_equal p[1].umbrella.color, green.color
    assert_equal p[2].umbrella.color, blue.color
  end
end
