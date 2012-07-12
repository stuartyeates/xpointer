
# A class implementing XPointer
#
# See:
# [http://www.w3.org/TR/xptr-xpointer/] for the standard
# [https://en.wikipedia.org/wiki/XPointer] on Wikipedia
#
class XPointer
  NAMESPACE = "http://www.w3.org/2001/05/XPointer"
  
 def  process(document, xpointer)
   raise "Bad document passed to Xpointer::process" unless document

   case xpointer
   when nil, '', '#'
     document
   when /^element\(/i
     document = processElement(document, xpointer)
   when /^string-range\(/i
     document = processStringRange(document, xpointer)
   else
     raise "Bad xpointer at XPointer::process(#{xpointer})"
   end
 end

   def processElement(document, xpointer)
     case xpointer
     when nil, '', '#'
       document
     when /^element\(([A-Za-z0-9]*)((\/[0-9]*)*)\)/i
       puts "found a live one #{$1}"
       document =  REXML::XPath.first( document, "//#{$1}" ) 
       document
     else
       raise "Bad xpointer at XPointer::processElement(#{xpointer})"
   end

     return document
   end

   def processStringRange(document, xpointer)
     return document
   end

end 
