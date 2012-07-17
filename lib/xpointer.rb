
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
      processElement(document, xpointer)
    when /^string-range\(/i
      processStringRange(document, xpointer)
    else
      raise "Bad xpointer at XPointer::process(#{xpointer})"
    end
  end
  
  def processElement(document, xpointer)
    raise "nil document at XPointer::processElement()" unless document 
    case xpointer
    when nil, '', '#', '/'
      document
    when  '/\Aelement\(\)\z'
      document.root
    when /\Aelement\(([^\)]*)\)\z/i
      processElementInner(document.root, $1)
    else
      raise "Bad xpointer at XPointer::processElement(#{xpointer})"
    end
  end

  def processElementInner(document, xpointer)
    raise "nil document at XPointer::processElementInner()" unless document 
    case xpointer
    when nil, '', '#', '/'
      document
    when /\A\/?([A-Z][^\/]*)(\/.*)?\z/i
       processElementInner(REXML::XPath.first( document, "//#{$1}"),$2)
    when /\A\/?([0-9]+)(\/.*)?\z/i
      children = document.elements.clone
      count = 0
      child = children.find { |child|
        if (child.is_a?(REXML::Element)) then      
          (count += 1) === $1.to_i()
        end
      }
      if (child) then
        return processElementInner(child,$2) 
      else
        return nil
      end
      
    else
      raise "Bad xpointer at XPointer::processElement(#{xpointer})"
    end
  end


  def processStringRange(document, xpointer)
    return document
  end

end 
