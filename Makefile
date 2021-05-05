SHELL=/bin/bash
FILES=.Rprofile .gitconfig .zshrc
FILEZ=$(patsubst %,$(HOME)/%,$(FILES))

install: brew omz dotfiles

check:
	@for f in $(FILES) ; do \
		diff -u $(HOME)/$$f $$f ; \
	done

colorcheck:
	make check | colordiff | less

getlatest:
	for i in $(FILES); do cp $(HOME)/$$i .; done

echo:
	echo $(FILEZ)

$(HOME)/%: %
	cp $< $@

brew:
	./install-brew.sh

omz:
	./install-zsh.sh

dotfiles: $(FILEZ)
