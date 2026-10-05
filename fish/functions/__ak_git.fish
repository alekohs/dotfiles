function __ak_git
    set -l b (git branch --show-current 2>/dev/null)
    test -z "$b"; and set b (git rev-parse --short HEAD 2>/dev/null)
    test -z "$b"; and return
    set -l out $b
    if test -n "$(git status --porcelain --ignore-submodules 2>/dev/null | head -1)"
        set out "$out*"
    end
    set -l ab (git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null | string split \t)
    if test (count $ab) -eq 2
        test $ab[2] -gt 0; and set out "$out ↑$ab[2]"
        test $ab[1] -gt 0; and set out "$out ↓$ab[1]"
    end
    echo $out
end
