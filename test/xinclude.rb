require "lib/xinclude"
require "test/unit"
require "rexml/document"

 
class TestXinclude < Test::Unit::TestCase
  
  def test_instantiation
    assert_not_nil(XInclude.new())
    assert_not_nil(REXML::Document.new())
  end

end
