require File.dirname(__FILE__) + '/test_helper.rb'

class SimpleSortingTest < Test::Unit::TestCase

  def test_schema_has_loaded_correctly
    load_schema

    assert_equal [], Association.all
    assert_equal [], Person.all
    assert_equal [], Planet.all
    assert_equal [], Tie.all
    assert_equal [], Umbrella.all


    geek = Association.new(:name => 'GEEK')
    earth = Planet.new(:name => 'Earth')
    foo = Person.new(:name => 'foo', :association => geek, :planet => earth)
    red_tie = Tie.new(:color => 'red', :person => foo)
    black_umbrella = Umbrella.new(:color => 'black', :person => foo)

    geek.save; earth.save; foo.save; red_tie.save; black_umbrella.save

    assert_equal Person.all.first.association.name, geek.name
    assert_equal Person.all.first.planet.name, earth.name
    assert_equal Person.all.first.tie.color, red_tie.color
    assert_equal Person.all.first.umbrella.color, black_umbrella.color
  end

end
