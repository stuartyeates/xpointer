require "lib/xpointer"
require "test/unit"
require "rexml/document"
require "lib/xinclude"

 
class TestXPointer < Test::Unit::TestCase
  
  def test_instantiation
    assert_not_nil(XPointer.new())
  end

  XINCLUDEDOC1="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer=''/></doc>"
  
  def test_1
    doc = REXML::Document.new(XINCLUDEDOC1)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/ kore /.match(asstring))
  end

  XINCLUDEDOC2="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer='element()'/></doc>"
  
  def test_2
    doc = REXML::Document.new(XINCLUDEDOC2)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/ kore /.match(asstring))
  end

  XINCLUDEDOC3="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer='#'/></doc>"
  
  def test_3
    doc = REXML::Document.new(XINCLUDEDOC3)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/ kore /.match(asstring))
  end

  XINCLUDEDOC4="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer='element(one)'/></doc>"
  
  def test_4
    doc = REXML::Document.new(XINCLUDEDOC4)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/ kore /.match(asstring))
  end


end
