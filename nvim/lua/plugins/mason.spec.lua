return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "jq",

        -- LSP
        "bash-language-server",
        { "clangd", condition = function() return vim.fn.executable("clangd") == 0 end },
        { "docker-language-server", condition = function() return vim.fn.executable("docker") == 1 or vim.fn.executable("podman") == 1 end },
        { "gopls", condition = function() return vim.fn.executable("go") == 1 end },
        "fish-lsp",
        "html-lsp",
        "lemminx",
        "json-lsp",
        "lua-language-server",
        "vim-language-server",
        "markdown-oxide",
        { "neocmakelsp", condition = function() return vim.fn.executable("cmake") == 1 end },
        "yaml-language-server",
        "taplo",
        "rust-analyzer",
        "tailwindcss-language-server",
        "typescript-language-server",
        "python-lsp-server",
        { "sqls", condition = function() return vim.fn.executable("go") == 1 end },
        "qmlls",
        { "roslyn", condition = function() return vim.fn.executable("dotnet") == 1 end },
        { "powershell-editor-services", condition = function() return vim.fn.executable("pwsh") == 1 end },

        -- Formatters
        "stylua",
        { "clang-format", condition = function() return vim.fn.executable("clang-format") == 0 end },
        "codespell",
        "prettierd",
        "ruff",
        "stylua",
        "shfmt",
        "yamlfmt",

        -- LINT
        "jsonlint",
        "markdownlint-cli2",
        "markdownlint",
        "biome",
        "htmlhint",
        "stylelint",
        "yamllint",
        "editorconfig-checker",
        "shellcheck",
        "sqlfluff",
      },
    },
  },
}
