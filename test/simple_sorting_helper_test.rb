require File.dirname(__FILE__) + '/test_helper.rb'
include SimpleSortingHelper

#class SimpleSortingHelperTest < Test::Unit::TestCase 
class SimpleSortingHelperTest < ActionController::IntegrationTest 
  def test_t
    assert true
  end

  def test_tweet 
    assert true
  end 

  def test_sort_link
    # puts sort_link('hi', 'name')
    assert true
  end
end 
