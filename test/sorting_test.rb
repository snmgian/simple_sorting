require File.dirname(__FILE__) + '/test_helper.rb'

class SortingTest < Test::Unit::TestCase

  def test_order_by_basic_fields
    load_schema

    foo = Person.new(:name => 'Foo', :age => 38)
    bar = Person.new(:name => 'Bar', :age => 30)
    moo = Person.new(:name => 'Moo', :age => 54)
    foo.save; bar.save; moo.save
    
    p = Person.asc_by_name

    assert_equal p[0].name, bar.name
    assert_equal p[1].name, foo.name
    assert_equal p[2].name, moo.name

    p = Person.desc_by_age
    assert_equal p[0].age, moo.age
    assert_equal p[1].age, foo.age
    assert_equal p[2].age, bar.age
  end
end
