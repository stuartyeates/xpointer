#!/usr/bin/ruby -w 
# -*- coding: utf-8 -*-

require "rexml/document"
include REXML 

TINY_DOC = "<doc><one></one><two></two></doc>"  

TEST_DOC = 
"<doc xml:id='doc' xml:lang='mi'>
  tahi, rua, toru, 
  <one xml:id='one'>whā, rima, ono,</one>whitu
  <two xml:id='two'>waru, iwa, tekau,</two>
  <three xml:id='three'>tekau mā tahi,
     <four xml:id='four'>tekau mā <five xml:id='five'/><six xml:id='six'/>rua, tekau mā toru</four>
     tekau mā whā <seven xml:id='seven'/> t<eight xml:id='eight'/>e<nine xml:id='nine'/>k<ten xml:id='ten'/>au mā rima
  </three>
</doc>"

XINCLUDEDOC="<doc xmlns:xi='http://www.w3.org/2001/XInclude'><xi:xinclude href='./test/samples/tahi.xml'/></doc>"

#file = File.new( "mydoc.xml" )
doc = REXML::Document.new(TEST_DOC)
puts "===========full doc ==========="
puts doc
puts "=========== find an item ==========="
four = XPath.first( doc, "//four[@xml:id='four']" ) 
puts four
puts "=========== end ==========="

# A class implementing XML Inclusions (XInclude)
#
# See:
# [http://www.w3.org/TR/xinclude/] for the standard
class XInclude
  NAMESPACE = "http://www.w3.org/2001/XInclude"
  @replacements = {}

  #a function to process all the includes in an REXML-parsed XML doc
  #returns the number of includes processed
  def process(doc)
    @replacements = {}
    puts doc

    puts  XPath.first( doc, "//xi:xinclude", {'xi' => NAMESPACE} )
    #XPath.match( doc, "//xi:xinclude", {'xi' => NAMESPACE} ).each() { |element| processInclude(element) }
    copyDocumentWithReplacements(doc)
  end

  def copyElementWithReplacements(element, newElement)
    element.elements.each() do |thisElement|
      if (thisElement.expanded_name == 'xi:xinclude') then
        thisElement = processInclude(thisElement)
      end
      newThisElement = Element.new(thisElement)
      newElement.add_element(newThisElement)
      copyElementWithReplacements(thisElement,newThisElement)
    end
  end

  #a function to process a single element in an  REXML-parsed XML doc
  #returns the new element
  def processInclude(element)
    puts element
    newElement =  processURI(element.attributes["href"],
                             element.attributes["parse"],
                             element.attributes["xpointer"],
                             element.attributes["encoding"],
                             element.attributes["accept"],
                             element.attributes["accept-language"])
    @replacements[element] = newElement.root
  end
  
  #build the inclusion. throws any errors that might occur
  def processURI(href, parse, xpointer, encoding, accept, acceptlanguage)
    #catch some fatal errors specified by the spec
    if (parse != nil && parse != "text" && parse != "xml")
        raise new Exception
    end
    if (parse == "text" && xpointer != nil)
        raise new Exception
    end
    puts href
    doc = REXML::Document.new(File.new(href));
  end  
end


doc = REXML::Document.new(XINCLUDEDOC)
xinclude = XInclude.new()
doc = xinclude.process(doc)
puts doc

# A class implementing XPointer
#
# See:
# [http://www.w3.org/TR/xptr-xpointer/] for the standard
# [https://en.wikipedia.org/wiki/XPointer] on Wikipedia
#
class XPointer
  NAMESPACE = "http://www.w3.org/2001/05/XPointer"
  

end 


