build:
	rm -f src/templates/all.html
	cat src/templates/*.html > src/templates/all.html
	cd src && ruby ./builder.rb

scrape:
	cd src && ruby ./extract_examples.rb

clean:
	rm -f src/templates/*.html
	rm -f dist/*.html