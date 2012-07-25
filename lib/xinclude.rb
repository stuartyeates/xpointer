require "rexml/document"
require "rexml/xpath"
require 'open-uri'
require 'lib/xpointer'


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
    raise "XInclude::process expects an REXML::Document" unless parsedXMLdocument.is_a?(REXML::Document)
    newDoc = REXML::Document.new(nil,parsedXMLdocument.context.clone)
    copyElementWithReplacements(parsedXMLdocument, newDoc)
    return newDoc
  end
  
  #an internal function for deep-copying the XML document
  def copyElementWithReplacements(element, newElement)
    raise "element is not an REXML::Element (#{element})" unless element.is_a?(REXML::Element)
    raise "newElement is not an REXML::Element (#{newElement})"unless newElement.is_a?(REXML::Element)

    element.children.each() do |child|
      if (child.is_a?(REXML::Element)) then
        if (child.expanded_name == "xi:xinclude") then
          newChild = processInclude(child)
        else
          newChild = REXML::Element.new(child)
          copyElementWithReplacements(child,newChild)
        end
        newElement.add(newChild)        
      elsif (child.is_a?(REXML::Text))
        newElement.add(REXML::Text.new(child))
      elsif (child.is_a?(REXML::Comment))
        newElement.add(REXML::Comment.new(child))
      end
      #puts "==" + child.to_s() + "=="
    end
  end

  #A function to process a single element in an  REXML-parsed XML doc
  #returns the new element
  def processInclude(element)
    raise "bad element in XInclude::processInclude(element)" unless element.is_a?(REXML::Element)
    raise "bad element name in XInclude::processInclude(element)" unless element.expanded_name == 'xi:xinclude'

    begin
      newElement =  processURI(element,
                               element.attributes["href"],
                               element.attributes["parse"],
                               element.attributes["xpointer"],
                               element.attributes["encoding"],
                               element.attributes["accept"],
                               element.attributes["accept-language"])
    rescue REXML::ParseException, Exception => exception
      fallback = REXML::XPath.first(element, "xi:fallback")
#      raise exception
      raise "XInclude Error processing '#{element.attributes["href"]}' (was '#{exception}'), and no xi:fallback found" unless fallback
      return fallback
    end
  end
  
  # Build the inclusion. throws any errors that might occur
  #
  # The encoding, accept, acceptlanguage options are ignored, but are 
  # present to match the standard
  def processURI(element, href, parse, xpointer, encoding, accept, acceptlanguage)
    raise "bad element in XInclude::parse()" unless (element) 
    # catch some fatal errors specified by the spec
    raise "bad parse in XInclude::parse()" if (parse != nil && parse != "text" && parse != "xml")
    raise "bad text parse in XInclude::parse()" if (parse == "text" && xpointer != nil)
    # we can't do anything without an href
    #raise "bad href in XInclude::parse()" if (href == nil)

    case href
    when nil
      doc = element.root
    when /^http:/i,  /^https:/i, /^ftp:/i
      doc = REXML::Document.new(open(href));
    when /^file:/i, 
      doc = REXML::Document.new(File.new(href));
    end
 
    if (xpointer) then
      p =  XPointer.new()
      doc = p.process(doc, xpointer)
    end
    return doc
  end  
end

