function __ak_jj
    set -l lines (jj log -r '@ | heads(::@ & bookmarks())' --ignore-working-copy --no-graph --color never -T 'if(current_working_copy, "@", "-") ++ "\t" ++ change_id.shortest(4) ++ "\t" ++ if(conflict, "×") ++ "\t" ++ if(!empty, "*") ++ "\t" ++ if(divergent, "divergent") ++ "\t" ++ local_bookmarks.join(" ") ++ "\n"' 2>/dev/null)
    or return
    set -l bookmarks
    set -l head
    for line in $lines
        set -l f (string split \t -- $line)
        set -a bookmarks (string split ' ' -- $f[6] | string match -v '')
        test "$f[1]" = @; and set head $f[2..5]
    end
    string join ' ' (string match -v '' -- $head[1] $bookmarks $head[2..4])
end
