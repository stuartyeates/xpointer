require "lib/xpointer"
require "test/unit"

 
class TestXPointer < Test::Unit::TestCase
  
  def test_instantiation
    assert_not_nil(XPointer.new())
  end

end
