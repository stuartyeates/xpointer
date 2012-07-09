require "rexml/document"
require "rexml/xpath"


# A class implementing XML Inclusions (XInclude)
#
# A pure-ruby implementation using the pure-ruby REXML libraries.
#
# See [http://www.w3.org/TR/xinclude/] for the spec
class XInclude
  NAMESPACE = "http://www.w3.org/2001/XInclude"

  #A function to process all the includes in an REXML-parsed XML doc
  #and return a new REXML document with XIncludes processed
  def process(parsedXMLdocument)
    raise unless parsedXMLdocument.is_a?(REXML::Document)
    newDoc = REXML::Document.new(nil,parsedXMLdocument.context.clone)
    copyElementWithReplacements(parsedXMLdocument, newDoc)
    return newDoc
  end
  
  #an internal function for deep-copying the XML document
  def copyElementWithReplacements(element, newElement)
    raise unless element.is_a?(REXML::Element)
    raise unless newElement.is_a?(REXML::Element)

    element.children.each() do |child|
      if (child.is_a?(REXML::Element)) then
        if (child.expanded_name == 'xi:xinclude') then
          child = processInclude(child)
        end
        newChild = REXML::Element.new(child)
        newElement.add(newChild)
        
        copyElementWithReplacements(child,newChild)
      elsif (child.is_a?(REXML::Text))
        newChild = REXML::Text.new(child)
        newElement.add(newChild)
      end
      #puts "==" + child.to_s() + "=="
    end
  end

  #A function to process a single element in an  REXML-parsed XML doc
  #returns the new element
  def processInclude(element)
    raise unless element.is_a?(REXML::Element)
    raise unless element.expanded_name == 'xi:xinclude'
    
    begin
      newElement =  processURI(element.attributes["href"],
                               element.attributes["parse"],
                               element.attributes["xpointer"],
                               element.attributes["encoding"],
                               element.attributes["accept"],
                               element.attributes["accept-language"]).root
    rescue REXML::ParseException, Exception => exception
      #      fallback = REXML::XPath.first(element, "./xi:fallback" )
 #     fallback = element.xpath('xi:fallback').first() 
      fallback = REXML::XPath.first(element, "xi:fallback")
      raise Exception "XInclude Error, and no xi:fallback found" unless fallback
      return fallback
    end
  end
  
  # Build the inclusion. throws any errors that might occur
  #
  # The encoding, accept, acceptlanguage options are ignored, but are 
  # present to match the standard
  def processURI(href, parse, xpointer, encoding, accept, acceptlanguage)
    # catch some fatal errors specified by the spec
    raise if (parse != nil && parse != "text" && parse != "xml")
    raise if (parse == "text" && xpointer != nil)
    # we can't do anything without an href
    raise if (href == nil)
    doc = REXML::Document.new(File.new(href));
  end  
end
