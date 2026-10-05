function __ak_vcs_root --description 'Hitta närmaste .jj eller .git'
    set -l d $PWD
    while test "$d" != /
        if test -d $d/.jj
            echo jj $d
            return
        else if test -e $d/.git
            echo git $d
            return
        end
        set d (path dirname $d)
    end
    return 1
end
