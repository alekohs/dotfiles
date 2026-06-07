alias fzfp="fzf --preview 'bat --color=always {}' --preview-window '~5' --height 50% --layout=reverse --prompt 'Files> ' --bind 'ctrl-r:reload:rg --files --hidden --glob \"!.git/*\"'"
alias t="kokoarch-tmux-session"
alias ls="eza --icons"
alias ll="ls --long"
alias lla="ll -a"
alias tree="ls --tree"
alias ss="snitch"
alias ss-real="command -v ss"
alias sql="sqlcmd"
alias lazypodman="DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker"
alias ducks="du -cks * | sort -rn | head"
alias dash="gh dash"
alias bc="bc -l"
alias cc="qalc"
alias calc="qalc"
alias wp="waypipe ssh"

abbr lzg lazygit
abbr lzp lazypodman
abbr ff fastfetch

abbr ga ""
abbr gc "git commit -m"
abbr gd "git dft"
abbr gl "git dl"
abbr gsh "git ds"
abbr gs "git status"
abbr gss "git status --short"
abbr gsw "git switch"
abbr gswn "git switch -c"
abbr gfo "git fetch origin"
abbr gp "git push"
abbr gpd "git push --dry-run"
abbr gpf "git push --force-with-lease"
abbr gpt "git push origin tag"
abbr gpl "git pull"
abbr gplp "git pull -p"
abbr gplr "git pull --rebase"
abbr gpsu "git push --set-upstream origin (git branch --show-current)"
abbr gr "git restore"
abbr gt "git tag"
abbr gw "git worktree list"
abbr gwa "git worktree add"
abbr gwr "git worktree remove"

abbr oll "ollama launch pi"
abbr ollq "ollama launch pi --model qwen3-coder:30b" # main coding
abbr ollqn "ollama launch pi --model qwen3-coder-next" # main coding next
abbr olld "ollama launch pi --model deepseek-r1:32b" # reasoning / planning
abbr oll4 "ollama launch pi --model llama4" # general + fallback
abbr ollds "ollama launch pi --model devstral-small-2" # local baseline coding

abbr genkey "openssl rand -hex 32"

if not contains $HOME/.local/bin $fish_user_paths
    set -gx fish_user_paths $HOME/.local/bin $fish_user_paths
end

# Add cargo bin to PATH for rust tools like tree-sitter-cli
if not contains $HOME/.cargo/bin $fish_user_paths
    set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths
end

# The next line updates PATH for the Google Cloud SDK.
if test -f "$HOME/.local/share/google-cloud-sdk/path.fish.inc"
    source "$HOME/.local/share/google-cloud-sdk/path.fish.inc"
end

# Newt colors (nmtui etc.)
set -x NEWT_COLORS "root=,default:window=white,default:border=white,default:shadow=,default:title=white,default:listbox=white,default:label=white,default:checkbox=white,default:actcheckbox=white,magenta:entry=white,default:button=white,magenta:actbutton=white,magenta:compactbutton=white,default:textbox=white,default:acttextbox=white,magenta:helpline=white,default:roottext=white,default:sellistbox=white,magenta:actsellistbox=white,magenta:emptyscale=,default:fullscale=,magenta"

# DOTNET config
set dp $HOME/.dotnet
set -x DOTNET_ROOT $dp
if test -d $dp; and not contains $dp $PATH
    set -gx PATH $PATH $dp
    set -gx PATH $PATH "$dp/tools"
end

if command -q mise
    if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end
end

if not contains $HOME/.opencode/bin $fish_user_paths
    set -gx fish_user_paths $HOME/.opencode/bin $fish_user_paths
end

if status is-interactive

    # Commands to run in interactive sessions can go here
    ## Fix path for ssh connection
    # if status is-login; or test -n "$SSH_CONNECTION"
    #     set -gx PATH /run/current-system/sw/bin /home/$USER/.nix-profile/bin $PATH
    # end

    # Pure prompt
    set -g fish_prompt pure
    set -g pure_enable_nixdevshell true
    set -g pure_show_system_time true
    set -g pure_show_jobs true

    fish_vi_key_bindings # Start vi mode
    if functions -q fzf_configure_bindings
        fzf_configure_bindings --git_log=\cl --git_status=\cg --history=\cr --variables=\cv --processes=\cp --directory=\cf
    end

    # function fish_user_key_bindings
    #   bind \cs "tmux switch-client -t $(tmux ls | fzf | cut -d: -f1)"
    # end

    if set -q GHOSTTY_RESOURCES_DIR
        source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
    end

    if command -q direnv
        direnv hook fish | source
    end

    if test "$TERM_PROGRAM" = ghostty
        set -x TERM xterm-256color
    end

    set -l fzf_opts_file "$HOME/.config/kokoarch/fzf-default-opts"
    if test -f "$fzf_opts_file"
        set -gx FZF_DEFAULT_OPTS (cat "$fzf_opts_file")
    else
        set -gx FZF_DEFAULT_OPTS "--color=fg:8,bg:-1,hl:5 --color=fg+:7,bg+:236,hl+:5 --color=border:8,header:3,gutter:-1 --color=spinner:5,info:4 --color=pointer:4,marker:1,prompt:8 --ansi --border --bind ctrl-j:down,ctrl-k:up --bind enter:accept"
    end

    function nix_develop
        if test (count $argv) -gt 0
            nix develop ~/Developer/Github/devshells/$argv[1] -c fish
        else
            nix develop
        end
    end

    #-------------------------------------------------------------------------------
    # Custom Functions
    #-------------------------------------------------------------------------------
    # Bat functions
    function bat_diff
        git diff --name-only --relative --diff-filter=d | xargs bat --diff
    end

    function bat_tail
        tail -f $argv[1] | bat --paging=never -l log
    end

    function bat_helper
        $argv --help 2>&1 | bat --plain --language=help
    end

    # FZF functions
    function fif
        if test (count $argv) -eq 0
            echo "No search parameter"
            return 1
        end
        rg --files-with-matches --no-messages --ignore-case "$argv[1]" | fzf --preview "rg --ignore-case --pretty --context 10 '$argv[1]' {} || echo 'No matches in file'" --preview-window=right:70%
    end

    function fzfc
        fzf \
            --delimiter ":" \
            --with-nth 1,2 \
            --preview "bat --color=always --style=numbers --highlight-line {2} {1} | rg --color=always --context 3 {q}" \
            --preview-window '~5' \
            --bind "change:reload:rg --column --line-number --color=always --hidden --glob '!.git/*' {q} || true" \
            --prompt "Search content> " \
            --height 60% \
            --layout=reverse
    end

    function fcd
        set -l fzf_args +m --height 60% --layout=reverse
        if test (count $argv) -gt 0
            set fzf_args $fzf_args --query "$argv[1]"
        end

        set selection (fd . . --type directory --hidden --exclude .git --exclude node_modules | fzf $fzf_args)

        if test -n "$selection"
            cd $selection
        end
    end

    function ffcd
        set -l fd_args --type directory --hidden --exclude .git --exclude node_modules
        if test (count $argv) -gt 1
            set fd_args $argv[1] $argv[2] $fd_args
        else if test (count $argv) -gt 0
            set fd_args . $argv[1] $fd_args
        end

        set selection (fd $fd_args | fzf +m --height 60% --layout=reverse)

        if test -n "$selection"
            cd $selection
        end
    end

    function dcd
        if test (count $argv) -gt 0
            ffcd $argv[1] ~/Developer
        else
            ffcd . ~/Developer
        end
    end

    # Tmux functions
    alias ta="kokoarch-tmux-session -c"

    function ts
        if set -q TMUX
            # Use tmux popup when inside tmux
            set session (tmux display-popup -E "tmux ls 2>/dev/null | fzf --reverse | cut -d: -f1")
            if test -n "$session"
                tmux switch-client -t $session
            end
        else
            # Use regular fzf when not in tmux
            set session (tmux ls 2>/dev/null | fzf --reverse | cut -d: -f1)
            if test -n "$session"
                tmux attach-session -t $session
            end
        end
    end

    #-------------------------------------------------------------------------------
    # Prompt
    #-------------------------------------------------------------------------------
    # Do not show any greeting
    set --universal --erase fish_greeting
    function fish_greeting
    end
    funcsave fish_greeting -q

    set -gx LIBVIRT_DEFAULT_URI qemu:///system
    set -x XDG_CONFIG_HOME "$HOME/.config"
    set -x BIOME_CONFIG_PATH "$HOME/.config/biome.json"

    # manpager
    set -gx MANPAGER "sh -c 'col -bx | bat -l man --paging=always'"

    # Editor
    set -gx EDITOR nvim
end
