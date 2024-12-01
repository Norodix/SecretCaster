name = SecretCaster

zips = $(name)_linux.zip $(name)_win.zip

%.zip:
	zip -r $@ $(basename $@)*

all: $(zips)
