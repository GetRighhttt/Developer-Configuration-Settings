return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<CR>", desc = "File explorer" },
    },
    opts = { view_options = { show_hidden = true } },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find text" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
    },
    opts = {
      defaults = { path_display = { "smart" } },
      pickers = { find_files = { hidden = true } },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(gs.next_hunk)
          return "<Ignore>"
        end, "Next Git change")
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(gs.prev_hunk)
          return "<Ignore>"
        end, "Previous Git change")
        map("n", "<leader>gp", gs.preview_hunk, "Preview Git change")
        map("n", "<leader>gb", gs.blame_line, "Blame line")
      end,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
      require("nvim-treesitter").install({
        "bash", "c", "cmake", "cpp", "groovy", "java", "json", "kotlin", "lua",
        "make", "markdown", "markdown_inline", "query", "vim", "vimdoc", "xml", "yaml",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { max_lines = 3, multiline_threshold = 1 },
  },
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    cmd = { "AerialToggle", "AerialNavToggle" },
    keys = {
      { "<leader>lo", "<cmd>AerialToggle! right<CR>", desc = "Toggle code outline" },
      { "<leader>lO", "<cmd>AerialNavToggle<CR>", desc = "Browse code outline" },
    },
    opts = {
      backends = { "lsp", "treesitter" },
      layout = { min_width = 30 },
      show_guides = true,
    },
  },
}
