xpointer
========

A ruby xpointer implementation. Hopefully this is going to be the first implementation 
to support most of the XPointer schemes at http://wiki.tei-c.org/index.php/XPointer In 
particular support for one of the string-range() schemes. For a description of the 
kinds of XML this will support see http://www.tei-c.org/release/doc/tei-p5-doc/en/html/SA.html

This is my first attemt to write ruby, so expect some language-learning related 
refacting to occur.

== Things that seem to work

* most of an xinclude implementation
* xi:fallback
* HTTP, HTTPS, FTP and file URIs supported
* Main the processes standard-in to standard-out.
* xpointer element() scheme (with a handful of test cases)
* xpointer string-range() scheme (with a handful of test cases, none spanning tags) 

== Things that don't appear to work

=== Xinclude
* xml:base URL interpretation
* xml:lang fix up
* namespace issues
* content negotiation (attributes accepted but ignored)

=== Xpointer
* multiple schemes
* a trivial number and scope of unit tests

== The Future ==

My plan is to give it up as too hard if I don't have the most complete xpointer 
suite within ~ two months. Also in that timeframe, I'll know whether ruby is a 
language I'm comfortable with.

=== The competition

The following are other implementations I'm aware of, to the best of my knowledge 
these don't include functional string-range() schemes.

* http://xmlsoft.org/index.html (C, isses discussed at http://wiki.tei-c.org/index.php/XPointer#libxml2)
* https://code.google.com/p/xincproc/ (Java, supports SAX)
* https://issues.apache.org/jira/browse/XERCESJ-873 (Java, no sign that the patch is likely to be applied)
* http://xpointerlib.mozdev.org/ (javascript)
* https://github.com/glro/xptr (javascript, includes xpath extensions?)