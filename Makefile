.PHONY: help nvim fish pi claude

help:
	@awk 'BEGIN{FS=":.*## "} /^[a-zA-Z_-]+:.*## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fish:
	@plugins="gazorby/fish-abbreviation-tips pure-fish/pure rose-pine/fish PatrickF1/fzf.fish oh-my-fish/plugin-foreign-env jorgebucaran/nvm.fish icezyclon/zoxide.fish"; \
	for plugin in $$plugins; do \
		echo "Fish installing $$plugin"; \
		fish -c "fisher install $$plugin"; \
	done

nvim:
	mkdir -p "${HOME}/.config/nvim"
	rsync -a --delete ./nvim/ "${HOME}/.config/nvim/"

claude:
	mkdir -p "${HOME}/.claude/skills" "${HOME}/.claude/skills"
	rsync -a claude/CLAUDE.md "${HOME}/.claude/CLAUDE.md"
	rsync -a claude/skills/ "${HOME}/.claude/skills/"

pi:
	mkdir -p "${HOME}/.pi/agent/skills" "${HOME}/.pi/agent/prompts"
	rsync -a pi/settings.json pi/models.json pi/keybindings.json "${HOME}/.pi/agent/"
	rsync -a pi/skills/ "${HOME}/.pi/agent/skills/"
	rsync -a pi/prompts/ "${HOME}/.pi/agent/prompts/"

brew:
	echo "Installing brew apps"
	brew install bat bitwarden-cli coreutils eza fastfetch fd \
	fish fisher fzf imagemagick jq lazydocker lazygit librsvg \
	mono-libgdiplus neovim opencode podman \
	swiftlint telnet tmux tree-sitter-cli xcbeautify \
	xcode-build-server xcodegen mise difftastic

	brew install --cask aerospace claude-code gcloud-cli hyperkey \
	obsidian sf-symbols tailscale-app \
	android-platform-tools cyberduck ghostty microsoft-edge \
	raycast slack temurin@21 zed claude discord \
	google-chrome mitmproxy rectangle tailscale tuist

install:
	@if [ -z "$(APP)" ]; then \
	    echo "Error: APP is required. Usage: make install APP=<app-folder>"; \
	    exit 1; \
	fi
	mkdir -p "${HOME}/.config/$(APP)"
	rsync -a ./$(APP)/ "${HOME}/.config/$(APP)/"

copy:
	mkdir -p "./$(APP)"
	rsync -a "${HOME}/.config/$(APP)/" ./$(APP)/
