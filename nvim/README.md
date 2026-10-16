# nvim

## Three-way merge with jj

`jj resolve` and `git mergetool` share a dedicated Neovim layout:

```text
┌─────────────┬─────────────┬─────────────┐
│ LEFT        │ BASE        │ RIGHT       │
│ read-only   │ read-only   │ read-only   │
├─────────────┴─────────────┴─────────────┤
│ RESULT — editable                     │
│                                       │
└───────────────────────────────────────┘
```

The normal colorscheme is preserved. Colored panel labels identify the source
versions, matching distinct blue LEFT / green RIGHT background tints inside unresolved
conflicts in RESULT, with stronger marker/header bands like VS Code. The source
panes use the same colors for their diff hunks. BASE has a muted tint. These highlights follow edits and
undo, disappear on resolution, and adapt when changing colorscheme. They identify
conflict alternatives, not the provenance of already accepted lines.
Diagonal filler marks show where a side has no matching lines, while stronger
word-level highlights identify changes within source hunks, inspired by Diffview.
With Polarskal active, merge tints use its actual panel background (including
transparent setups), muted/text colors and green `alt` accent. LEFT keeps a blue
softened with the theme's text color, since `ice` is not necessarily blue.
The palette is reread on `ColorScheme`, including Polarskal's live reloads.
A bottom help bar shows the remaining conflict count and keymaps.
Focus starts at the first conflict in RESULT. Diagnostics, blame text and
automatic formatting are disabled for this dedicated merge session.

The leader is **Space**. All merge actions work from any of the four panels:
Press keys in sequence, not simultaneously: `Space`, then `m`, then `l`.
The existing `mini.clue` popup shows the `+merge` group and available actions;
pause after `Space m` to see it (200 ms delay in merge buffers).

| Keys | Action |
| --- | --- |
| `]c` / `[c` | Next / previous conflict in RESULT, wrapping at the ends |
| `<leader>ml` | Accept LEFT for the current conflict |
| `<leader>mb` | Accept BASE for the current conflict |
| `<leader>mr` | Accept RIGHT for the current conflict |
| `<leader>ma` | Accept both: LEFT then RIGHT |
| `<leader>mA` | Accept both: RIGHT then LEFT |
| `<leader>me` | Focus RESULT |
| `<leader>mf` | Check markers, save RESULT and exit |
| `<leader>mq` | Abort with a nonzero exit code, without saving pending edits |
| `u` in RESULT | Undo a choice |

Accepting a side replaces the **whole conflict region**, including its markers.
Choices use the conflict at the RESULT cursor, even when invoked from a source
panel. The cursor stays at the change so you can review it before moving on.
“Accept both” concatenates the two sides in the specified order, without adding
blank lines, deduplicating shared lines or including BASE. Review the result:
combining both sides does not guarantee valid syntax or correct behavior.
The whole choice can be undone with `u`, just like accepting a single side.
The older `]x` / `[x` aliases also navigate conflicts. These mappings are local
to merge buffers; normal diff sessions keep native `[c` / `]c` hunk navigation.
For fine-grained diff editing in merge mode, use `:diffget`.

### Pick a hunk or selected lines

- In a **source panel**, place the cursor on a diff hunk and press `<leader>mh`
  to copy that hunk into RESULT. To copy just part of it, select lines with `V`,
  extend the selection with `j` / `k`, then press `<leader>mh`.
- In **RESULT**, select lines with `V` and press `<leader>ml`, `<leader>mb`, or
  `<leader>mr` to pull the corresponding lines from that source.
- Normal-mode `<leader>ml/mb/mr` still accepts an entire conflict region.

These are line-based native `:diffget` / `:diffput` operations, not character-wise
copies. Source picks return focus to RESULT, and `u` undoes the edit there.
Partial picks can leave conflict markers: review and finish resolving the region
before `<leader>mf` will accept it. The Visual-mode `mini.clue` popup lists the
available selection actions.

Both tools supply Git-style conflict markers; accepting BASE needs a diff3 BASE
section. jj uses the tool's `conflict-marker-style = "git"`, and Git uses
`merge.conflictstyle = diff3`. LEFT and RIGHT describe positions, not “ours” /
“theirs”, whose meaning can depend on the operation.

Use `<leader>mf` to check, save and finish. `:qa!` without a saved resolution
automatically reports cancellation: unchanged output, discarded pending edits,
and saved files that still contain conflict markers cannot report success.
Git trusts this exit status, so it does not ask whether the merge was successful.
Manual `:wqa` succeeds when the saved result is changed and has no conflict markers.
Aborting does not undo any earlier explicit `:write`.
Ordinary `nvim -d` sessions are unaffected.

Regression tests (Neovim and Python 3 required; the jj integration test is skipped
when jj is unavailable, and the rendered-color test needs optional Python `msgpack`):

```sh
python3 -B -m unittest discover -s nvim/tests -v
```

## C/C++ projects

`clangd` needs a compilation database to resolve includes and flags. Without one
it guesses, and you get bogus "file not found" diagnostics.

Generate `compile_commands.json` in the project root:

```sh
# CMake
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json .

# Make / anything else
bear -- make
```

For small projects a `compile_flags.txt` is enough — one flag per line:

```
-std=c++23
-Iinclude
```

Formatting uses `clang-format`, which reads the nearest `.clang-format`. Without
one it falls back to LLVM style. Create a project default with:

```sh
clang-format -style=llvm -dump-config > .clang-format
```

`CMakeLists.txt` is handled by `neocmakelsp`, including formatting — no separate
formatter needed.

## Markdown preview over SSH

`<leader>mp` starts the browser preview (`markdown-preview.nvim`) on port 8421
and notifies the URL instead of opening a browser. The server only listens on
localhost, so forward the port from the machine you connect from:

```
# ~/.ssh/config
Host <host>
  LocalForward 8421 localhost:8421
```

Then open the notified `http://127.0.0.1:8421/?t=…` locally. The `?t=` token is
required.

Without a tunnel, set `host = "0.0.0.0"` in `markdown-preview.spec.lua` and open
`http://<host-ip>:8421/?t=…` from the LAN. The token keeps others out, but the
traffic is plain HTTP.
