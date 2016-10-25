.PHONY: slides.html

index.html: slides.md
	landslide -i -o slides.md | grep -v "Embedded image" >$@

