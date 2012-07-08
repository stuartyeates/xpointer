
all: doc test

doc:
	rdoc

test:
	ruby test/xinclude.rb

clean: 
	rm -rf doc

.PHONY: all clean test doc

