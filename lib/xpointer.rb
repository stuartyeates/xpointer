
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
    newElement = REXML::Element.new('CONTAINER')
    tags = {}

    if (element) then
      processStringRangeInnerR(element, newElement, offset, length, false, tags )
      processStringRangeInnerR(element, newElement, offset, length, true, tags )
      return newElement
    else 
      return document
    end
  end


  #element is the element we're starting at
  #offset is the offset into the textual content
  #length is the length of the textual content
  #forReal is whether this is a real run (or a tag counting run)
  #tags is the hash of tags

  def processStringRangeInnerR(element, newElement, offset, length, forReal, tags)
    raise "bad element in XPointer::processStringRangeInnerR \"" + element.name + "\"" unless (element and element.is_a?(REXML::Element))
    raise "bad newElement in XPointer::processStringRangeInner \"" + newElement.name + "\"" unless (newElement and newElement.is_a?(REXML::Element))
    raise "bad offset in XPointer::processStringRangeInnerR" unless (offset and offset.is_a?(Integer))
    raise "negative offset in XPointer::processStringRangeInnerR ? You're insane!" unless (offset >= 0)
    raise "bad length in XPointer::processStringRangeInnerR" unless (length and offset.is_a?(Integer))
    raise "bad tags in XPointer::processStringRangeInnerR" unless (tags and tags.is_a?(Hash))
 

    element.children.find{ |child|
      if (length <= 0)
        return newElement
      elsif (child.is_a?(REXML::Element)) then
        if (!tags[child]) then
          tags[child] = child
          newChild = REXML::Element.new(child)
          newElement.add(newChild)
          newChild.add_atributes(child.attributes())
          processStringRangeInnerR(child, newChild, offset, length, forReal, tags)
          if (length <= 0) then
            tags[child] = nil
          end
        end
      elsif (child.is_a?(REXML::Attribute)) then
        # handled already 
      elsif (child.is_a?(REXML::Text)) then
        if (offset >= child.to_s().length) then
          offset = offset - child.to_s().length
        else
          if (forReal) then 
            newElement.add(REXML::Text.new(child.to_s()[offset, length]));
          end
          oldoffset = offset
          offset = 0
          length = length - child.to_s().length - offset
        end
      elsif (child.is_a?(REXML::Comment)) then
        if (forReal) then 
          newElement.add(REXML::Comment.new(child));
        end
      else 
        raise "unknown node type in processStringRangeInnerR \"" + child.class + "\"" 
      end 
    } 
  end
  
end 
