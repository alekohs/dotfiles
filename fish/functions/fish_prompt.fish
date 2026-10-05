function fish_prompt
    set -l last_status $status
    if test $__ak_stale = 1
        set -g __ak_status $last_status
        set -g __ak_vcs (__ak_vcs_root | string split ' ')
        set -g __ak_info
        test (count $__ak_vcs) -eq 2; and set -g __ak_info (__ak_$__ak_vcs[1])
        set -g __ak_stale 0
    end

    if set -q SSH_TTY
        set_color $__ak_dim
        echo -n (whoami)@(prompt_hostname)' '
    end

    if set -q VIRTUAL_ENV
        set_color $__ak_dim
        echo -n (path basename $VIRTUAL_ENV)' '
    end

    if test (count $__ak_vcs) -eq 2
        set -l root $__ak_vcs[2]
        set -l rel (string replace -- $root '' $PWD)
        set_color --bold $__ak_ink
        echo -n (path basename $root)
        set_color normal
        set_color $__ak_meta
        echo -n $rel
        if test -n "$__ak_info"
            set_color $__ak_dim
            echo -n " $__ak_vcs[1]:"
            set_color $__ak_amber
            echo -n $__ak_info
        end
    else
        set_color $__ak_ink
        echo -n (prompt_pwd --full-length-dirs 2)
    end

    set -l ch ›
    set -l c $__ak_amber
    switch $fish_bind_mode
        case default
            set ch ‹
            set c $__ak_meta
        case visual
            set ch ‹
            set c $__ak_ink
        case replace_one replace
            set ch ›
            set c $__ak_err
    end
    test $__ak_status -ne 0; and test $fish_bind_mode = insert; and set c $__ak_err
    set_color $c
    echo -n " $ch "
    set_color normal
end
