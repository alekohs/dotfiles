# nvim

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
