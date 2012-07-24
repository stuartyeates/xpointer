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
    #puts "TEST " + asstring
    assert_not_nil(/kore/m.match(asstring))
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
    assert_nil(/ kore /.match(asstring))
    assert_not_nil(/tahi/.match(asstring))
  end


  XINCLUDEDOC5="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer='element(/)'/></doc>"
  
  def test_5
    doc = REXML::Document.new(XINCLUDEDOC5)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/ kore /.match(asstring))
  end

  XINCLUDEDOC6="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer='element(five/1)'/></doc>"
  
  def test_6
    doc = REXML::Document.new(XINCLUDEDOC6)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    #puts doc.to_s()
    assert_not_nil(/six/.match(asstring))
    assert_nil(/five/.match(asstring))
    assert_nil(/tahi/.match(asstring))
  end

  XINCLUDEDOC7="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml' xpointer='element(2/1)'/></doc>"
  
  def test_7
    doc = REXML::Document.new(XINCLUDEDOC7)
    assert_not_nil(doc)
    xinclude = XInclude.new()
    assert_not_nil(xinclude)
    doc = xinclude.process(doc)
    asstring = doc.to_s()
    assert_not_nil(/three/.match(asstring))
    assert_nil(/five/.match(asstring))
    assert_nil(/tahi/.match(asstring))
  end



  def test_fine_a
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.processElement(doc, '')
    assert_equal(doc,doc2,"#{doc} /// #{doc2}")
  end

  def test_fine_b
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.processElement(doc, nil)
    assert_equal(doc,doc2,"#{doc} /// #{doc2}")
  end

  def test_fine_c
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.processElement(doc, '/')
    assert_equal(doc,doc2,"#{doc} /// #{doc2}")
  end

  def test_fine_d
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.processElement(doc, 'element()')
    assert_equal(doc.root,doc2,"#{doc} /// #{doc2}")
  end

  def test_fine_e
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.processElement(doc, 'element(/4)')
    asstring = doc2.to_s()
    assert_not_nil(/nine/.match(asstring))
    assert_not_nil(/>e</.match(asstring))

  end

  def test_fine_ea
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.process(doc, 'element(/4)')
    asstring = doc2.to_s()
    assert_not_nil(/nine/.match(asstring))
    assert_not_nil(/>e</.match(asstring))

  end

  def test_fine_f
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.processElement(doc, 'element(/4/1)')
    assert_nil(doc2,"#{doc} /// #{doc2}")
  end

  def test_fine_fa
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.process(doc, 'element(/4/1)')
    assert_nil(doc2,"#{doc} /// #{doc2}")
  end


  def test_string_range_a
    doc = REXML::Document.new(File.new('./test/samples/tahi.xml'))
    assert_not_nil(doc)
    xpointer = XPointer.new()
    assert_not_nil(xpointer)
    doc2 = xpointer.process(doc, 'string-range(one,0,4)')
    assert_equal("tahi",doc2[0].to_s(),"#{doc2} /// \"tahi\"")
  end

end
