require "lib/xinclude"
require "test/unit"
require "rexml/document"

 
class TestXinclude < Test::Unit::TestCase
  
  def test_instantiation
    assert_not_nil(XInclude.new())
    assert_not_nil(REXML::Document.new())
  end

   XINCLUDEDOC="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml'/></doc>"

 def test_instantiation2
    doc = REXML::Document.new(XINCLUDEDOC)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/tahi, rua, toru,/.match(asstring))
  end

end
