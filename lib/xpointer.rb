
# A class implementing XPointer
#
# See:
# [http://www.w3.org/TR/xptr-xpointer/] for the standard
# [https://en.wikipedia.org/wiki/XPointer] on Wikipedia
#
class XPointer
  NAMESPACE = "http://www.w3.org/2001/05/XPointer"
  
  # a method to process any kind of xpointer. Returns the document
  # fragment pointed to. Gracefully handles empty xpointers, but raises
  # an error for non-understood non-trivial xpointers. 
  def  process(document, xpointer)
    raise "Bad document passed to Xpointer::process" unless document
    
    case xpointer
    when nil, '', '#'
      document
    when /\Aelement\(/i
      processElement(document, xpointer)
    when /\Astring-range\(/i
      processStringRange(document, xpointer)
    else
      raise "Bad xpointer at XPointer::process(#{xpointer})"
    end
  end

  # Process an element() xpointer. 
  #
  # strips the 'element() out and passes it to processElementInner 
  # which does the real work
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

  # Do the leg-work for an element() xpointer. Recursive.
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
    raise "nil document at XPointer::processElementInner()" unless document 
    case xpointer
    when nil, '', '#', '/'
      document
    when /\Astring-range\(([^,]+),([0-9]+)\)\z/
      processStringRangeInner(document, $1, $2.to_i(), 1)
    when /\Astring-range\(([^,]+),([0-9]+),?([0-9]+)?\)\z/
      processStringRangeInner(document, $1, $2.to_i(), $3.to_i())
    else
      raise "Bad xpointer at XPointer::processStringRange(#{xpointer})"
    end
  end

  def processStringRangeInner(document, fragmentIdentifier, offset, length)
    raise "nil document in XPointer::processStringRangeInner" unless document
    raise "nil fragmentIdentifier in XPointer::processStringRangeInner" unless fragmentIdentifier
    element = REXML::XPath.first( document, "//#{fragmentIdentifier}")
    text =  element.children.find { |child|
      child.is_a?(REXML::Text)
    }
    if (text) then  
      return text.to_s()[offset,(offset+length)]
    else
      nil
    end
  end
end 
