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
    assert_not_nil(/ kore /.match(asstring))
    assert_nil(/fallback/.match(asstring))
  end
  
  XINCLUDEBAD1="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/kino.xml'><xi:fallback/></xi:xinclude></doc>"
  def test_instantiation3
    assert_raise(REXML::ParseException) { REXML::Document.new(File.new("./test/samples/kino.xml")) }
  end

  def test_instantiation4
    doc = REXML::Document.new(XINCLUDEBAD1)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_nil(/ kore /.match(asstring))
    assert_not_nil(/fallback/.match(asstring))

  end
  
  XINCLUDEBAD2="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/kino.xml'><xi:fallback><XXX/></xi:fallback></xi:xinclude></doc>"

  def test_instantiation5
    doc = REXML::Document.new(XINCLUDEBAD2)    
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_nil(/ kore /.match(asstring))
    assert_not_nil(/fallback/.match(asstring))
    assert_not_nil(/XXX/.match(asstring))
  end
  
end
