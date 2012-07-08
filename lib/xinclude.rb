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
    raise unless doc.is_a?(Document)

    #puts  XPath.first( doc, "//xi:xinclude", {'xi' => NAMESPACE} )
    #XPath.match( doc, "//xi:xinclude", {'xi' => NAMESPACE} ).each() { |element| processInclude(element) }
    newDoc = Document.new(nil,doc.context.clone)
    copyElementWithReplacements(doc, newDoc)
    return newDoc
 end

  def copyElementWithReplacements(element, newElement)
    raise unless element.is_a?(Element)
    raise unless newElement.is_a?(Element)

    element.children.each() do |child|
      if (child.is_a?(Element)) then
        if (child.expanded_name == 'xi:xinclude') then
          child = processInclude(child).root
        end
        newChild = Element.new(child)
        newElement.add(newChild)
        
        copyElementWithReplacements(child,newChild)
      elsif (child.is_a?(Text))
        newChild = Text.new(child)
        newElement.add(newChild)
      end
      #puts "==" + child.to_s() + "=="
    end
  end

  #a function to process a single element in an  REXML-parsed XML doc
  #returns the new element
  def processInclude(element)
    raise unless element.is_a?(Element)
    raise unless element.expanded_name == 'xi:xinclude'

    newElement =  processURI(element.attributes["href"],
                             element.attributes["parse"],
                             element.attributes["xpointer"],
                             element.attributes["encoding"],
                             element.attributes["accept"],
                             element.attributes["accept-language"])
  end
  
  #build the inclusion. throws any errors that might occur
  def processURI(href, parse, xpointer, encoding, accept, acceptlanguage)
    # catch some fatal errors specified by the spec
    raise if (parse != nil && parse != "text" && parse != "xml")
    raise if (parse == "text" && xpointer != nil)
    # we can't do anything without an href
    raise if (href == nil)
    doc = REXML::Document.new(File.new(href));
  end  
end
