BIN_PATH := $(HOME)/.local/bin

all: mapperx umapperx cleanup

mapperx: mapper
	shc -f mapper -o mapperx

umapperx: umapper
	shc -f umapper -o umapperx

mapper: configure
	bash configure

umapper: configure
	bash configure

cleanup:
	rm -f mapper.x.c mapper umapper.x.c umapper

install:
	mkdir -p $(BIN_PATH)
	mv mapperx umapperx $(BIN_PATH)

uninstall:
	rm -rf $(BIN_PATH)/{umapperx,mapperx}

clean:
	rm -f mapperx umapperx
