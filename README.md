# Docs

Personal dotfiles. Each folder holds the config for one tool and is copied into place with `make` (files are copied, not symlinked).

```sh
make help              # list targets
make fish              # fisher plugins + config.fish + functions
make nvim              # sync nvim config
make install APP=bat   # copy a folder to ~/.config/<APP>
make copy APP=bat      # copy ~/.config/<APP> back into the repo
```

After changing fish config: `make fish && source ~/.config/fish/config.fish`.

## jj

The repo is colocated with jj (`.git` and `.jj` side by side), so git tools still work. Everything is committed straight to `main`.

```sh
jj st                       # status (working copy is always a commit, no staging)
jj commit -m "feat(x): ..." # describe @ and start a new empty commit on top
jj tug                      # move main to @-
jj git push                 # push main
```

Other handy commands:

```sh
jj describe -m "..."   # change the message of @
jj squash              # fold @ into its parent
jj split               # split @ into several commits
jj undo                # undo the last jj operation
jj op log              # see everything jj has done
jj git fetch           # pull in remote changes
jj rebase -d main      # rebase onto updated main
```

`tug` comes from LazyJJ (`~/.config/jj/conf.d`). Git tools show "detached HEAD" while jj manages the repo, that's expected.
