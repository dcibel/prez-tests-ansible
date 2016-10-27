SVG=$(wildcard *.svg)

index.html: slides.md $(SVG)
	landslide -i -o slides.md | grep -v "Embedded image" >$@


clean:
	rm index.html

