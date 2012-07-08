require "rexml/document"

# A class implementing XML Inclusions (XInclude)
#
# See:
# [http://www.w3.org/TR/xinclude/] for the standard
class XInclude
  NAMESPACE = "http://www.w3.org/2001/XInclude"

  #a function to process all the includes in an REXML-parsed XML doc
  #returns the number of includes processed
  def process(doc)

    #puts  XPath.first( doc, "//xi:xinclude", {'xi' => NAMESPACE} )
    #XPath.match( doc, "//xi:xinclude", {'xi' => NAMESPACE} ).each() { |element| processInclude(element) }
    newDoc = Document.new(nil,doc.context.clone)
    copyElementWithReplacements(doc, newDoc)
    return newDoc
 end

  def copyElementWithReplacements(element, newElement)
    element.elements.each() do |thisElement|
      if (thisElement.expanded_name == 'xi:xinclude') then
        thisElement = processInclude(thisElement).root
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
