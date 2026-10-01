COMPLETE=fish jj | source

function __jj_revisions
    set -l limit -n 15
    test -n (commandline -ct); and set limit
    command jj log --no-graph --ignore-working-copy --color never $limit -r '::@ | mutable()' \
        -T 'change_id.shortest(8) ++ "\t" ++ if(description, description.first_line(), "(no description)") ++ " · " ++ committer.timestamp().ago() ++ if(bookmarks, " · " ++ bookmarks.join(" ")) ++ if(conflict, " · conflict") ++ if(empty, " · empty") ++ "\n"' 2>/dev/null
end

function __jj_needs_revision
    set -l prev (commandline -xpc)[-1]
    contains -- $prev -r --revision --revisions -o --onto -A --insert-after -B --insert-before -f --from -t --to -d --destination --into
    and return 0
    string match -q -- '-*' $prev
    and return 1
    __fish_seen_subcommand_from abandon arrange describe desc duplicate edit metaedit new parallelize show
end

complete -c jj -f -k -n __jj_needs_revision -a '(__jj_revisions)'
