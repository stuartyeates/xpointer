
all: doc test
	./Main.rb < test/samples/tahi.xml 

doc:
	rdoc

test:
	ruby test/xinclude.rb
	ruby test/xpointer.rb

clean: 
	rm -rf doc

.PHONY: all clean test doc

