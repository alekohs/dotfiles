nvim:
	mkdir -p "${HOME}/.config/nvim"
	rsync -a --delete ./nvim/ "${HOME}/.config/nvim/"
