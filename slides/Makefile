SVG=$(wildcard *.svg)
PNG=$(wildcard *.png)

index.html: slides.md $(SVG) $(PNG)
	landslide -i -o slides.md | grep -v "Embedded image" >$@


clean:
	rm index.html

