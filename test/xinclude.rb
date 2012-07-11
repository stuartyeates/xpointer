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


   HTTPSDOC="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='https://raw.github.com/stuartyeates/xpointer/master/test/samples/tahi.xml'/></doc>"
  
  def test_https
    doc = REXML::Document.new(HTTPSDOC)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/ kore /.match(asstring))
    assert_nil(/fallback/.match(asstring))
  end
  
  def test_compare_ https
    doc1 = REXML::Document.new(HTTPSDOC)
    doc2 = REXML::Document.new(XINCLUDEDOC)
    assert_not_nil(doc1)
    assert_not_nil(doc2)
    xinclude1 = XInclude.new()
    xinclude2 = XInclude.new()
    assert_not_nil(xinclude1)
    assert_not_nil(xinclude2)
    doc1 = xinclude.process(doc1)
    doc2 = xinclude.process(doc2)
    asstring1 = doc1.to_s()
    asstring2 = doc2.to_s()
    
    assert_equal(asstring1,asstring2)
    assert_equal(asstring2,asstring1)
  end
  
  
end
