#!/usr/bin/ruby -w 
# -*- coding: utf-8 -*-

require "rexml/document"
require "lib/xinclude"
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


