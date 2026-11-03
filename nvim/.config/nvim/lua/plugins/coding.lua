local manual_format_filetypes = { java = true, kotlin = true, c = true, cpp = true }

-- jdtls needs JDK 25+, but the shell keeps JAVA_HOME on 17 for Android builds.
local function language_server_java_env()
  if vim.fn.executable("/usr/libexec/java_home") == 0 then return nil end
  local java_home = vim.trim(vim.fn.system({ "/usr/libexec/java_home", "-v", "25+" }))
  if vim.v.shell_error ~= 0 then return nil end
  return { JAVA_HOME = java_home, PATH = java_home .. "/bin:" .. vim.env.PATH }
end

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      local java_env = language_server_java_env()
      -- Only the server runs on JDK 25. Gradle imports keep the shell's JAVA_HOME (17), and
      -- Eclipse project files stay out of the repo, so Android builds and git status are untouched.
      vim.lsp.config("jdtls", {
        cmd_env = java_env,
        settings = {
          java = {
            import = {
              generatesMetadataFilesAtProjectRoot = false,
              gradle = { java = { home = vim.env.JAVA_HOME } },
            },
          },
        },
      })

      -- Xcode's clangd knows where the macOS SDK headers live; Mason's build does not.
      local clangd_cmd = vim.fn.executable("xcrun") == 1 and { "xcrun", "clangd" } or { "clangd" }
      vim.lsp.config("clangd", {
        cmd = vim.list_extend(clangd_cmd, {
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
        }),
      })
      vim.lsp.enable("clangd")

      require("mason-tool-installer").setup({
        ensure_installed = {
          "jdtls",
          "kotlin-lsp",
          "lua-language-server",
          "ktlint",
          "stylua",
          "tree-sitter-cli",
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "jdtls", "kotlin_lsp", "lua_ls" },
        automatic_enable = { exclude = { "kotlin_language_server" } },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local telescope = require("telescope.builtin")
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("gd", telescope.lsp_definitions, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", telescope.lsp_references, "Go to references")
          map("gI", telescope.lsp_implementations, "Go to implementation")
          map("gy", telescope.lsp_type_definitions, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>ls", telescope.lsp_document_symbols, "Symbols in file")
          map("<leader>lS", telescope.lsp_dynamic_workspace_symbols, "Symbols in project")
          map("<leader>lci", telescope.lsp_incoming_calls, "Who calls this")
          map("<leader>lco", telescope.lsp_outgoing_calls, "What this calls")
          map("<leader>lts", function() vim.lsp.buf.typehierarchy("supertypes") end, "Parent types")
          map("<leader>ltb", function() vim.lsp.buf.typehierarchy("subtypes") end, "Child types")
          map("<leader>lH", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
          end, "Toggle inlay hints")

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "clangd" then
            map("<leader>lh", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch source/header")
          end
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        if manual_format_filetypes[vim.bo[bufnr].filetype] then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      formatters_by_ft = { kotlin = { "ktlint" }, lua = { "stylua" } },
    },
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { desc = "Disable autoformat", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Enable autoformat" })
    end,
  },
}
