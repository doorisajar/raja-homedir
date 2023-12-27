SHELL=/bin/bash
FILES=.Rprofile .gitconfig .zshrc

# Prepend homedir path to each file
FILE_PATHS=$(patsubst %,$(HOME)/%,$(FILES))

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
	echo $(FILE_PATHS)

# Rule: $(HOME)/%
# Copies the corresponding file from the current directory to the home directory
$(HOME)/%: %
	cp $< $@

brew:
	./install-brew.sh

omz:
	./install-zsh.sh

configs:
	./install-configs.sh

dotfiles: $(FILE_PATHS)
