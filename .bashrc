# Editor
export EDITOR=nvim

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# PATH
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"
[[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && export PATH="$HOME/.cargo/bin:$PATH"

# FZF
_fzf_opts_file="$HOME/.config/kokoarch/fzf-default-opts"
if [ -f "$_fzf_opts_file" ]; then
  export FZF_DEFAULT_OPTS="$(cat "$_fzf_opts_file")"
else
  export FZF_DEFAULT_OPTS="--color=fg:8,bg:-1,hl:5 --color=fg+:7,bg+:236,hl+:5 --color=border:8,header:3,gutter:-1 --color=spinner:5,info:4 --color=pointer:4,marker:1,prompt:8"
fi

# mise
if command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
