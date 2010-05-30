require File.dirname(__FILE__) + '/test_helper.rb'

class AssociationBTSortingTest < Test::Unit::TestCase

  def test_order_for_belongs_to
    load_schema

    geek = Association.new(:name => 'GEEK')
    rails = Association.new(:name => 'RAILS')
    ruby = Association.new(:name => 'RUBY')
    geek.save; rails.save; ruby.save

    foo = Person.new(:name => 'Foo', :age => 38, :association => rails)
    bar = Person.new(:name => 'Bar', :age => 30, :association => geek)
    moo = Person.new(:name => 'Moo', :age => 54, :association => ruby)
    foo.save; bar.save; moo.save
    
    p = Person.asc_by_association_name.all

    assert_equal p[0].association.name, geek.name
    assert_equal p[1].association.name, rails.name
    assert_equal p[2].association.name, ruby.name

    p = Person.desc_by_association_name.all

    assert_equal p[0].association.name, ruby.name
    assert_equal p[1].association.name, rails.name
    assert_equal p[2].association.name, geek.name
  end

  def test_order_for_belongs_to_null
    load_schema

    geek = Association.new(:name => 'GEEK')
    ruby = Association.new(:name => 'RUBY')
    geek.save; ruby.save

    foo = Person.new(:name => 'Foo', :age => 38)
    bar = Person.new(:name => 'Bar', :age => 30, :association => geek)
    moo = Person.new(:name => 'Moo', :age => 54, :association => ruby)
    foo.save; bar.save; moo.save
    
    p = Person.asc_by_association_name.all
    assert p.size == 3

    assert_nil p[0].association
    assert_equal p[1].association.name, geek.name
    assert_equal p[2].association.name, ruby.name

    p = Person.desc_by_association_name.all
    assert p.size == 3

    assert_equal p[0].association.name, ruby.name
    assert_equal p[1].association.name, geek.name
    assert_nil p[2].association
  end

  def test_order_for_belongs_to_with_fk
    load_schema

    earth = Planet.new(:name => 'Earth')
    mars = Planet.new(:name => 'Mars')
    jupiter = Planet.new(:name => 'Jupiter')
    earth.save; mars.save; jupiter.save

    foo = Person.new(:name => 'Foo', :age => 38, :planet => mars)
    bar = Person.new(:name => 'Bar', :age => 30, :planet => earth)
    moo = Person.new(:name => 'Moo', :age => 54, :planet => jupiter)
    foo.save; bar.save; moo.save
    
    p = Person.asc_by_planet_name.all

    assert_equal p[0].planet.name, earth.name
    assert_equal p[1].planet.name, jupiter.name
    assert_equal p[2].planet.name, mars.name

    p = Person.desc_by_planet_name.all

    assert_equal p[0].planet.name, mars.name
    assert_equal p[1].planet.name, jupiter.name
    assert_equal p[2].planet.name, earth.name
  end
end
