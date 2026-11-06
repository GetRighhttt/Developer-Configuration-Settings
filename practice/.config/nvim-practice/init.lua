vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 6
vim.opt.undofile = true
vim.opt.confirm = true
vim.cmd("syntax enable")

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Browse files" })
for _, direction in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. direction .. ">", "<C-w>" .. direction)
end
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal input" })
map("n", "<leader>r", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or not vim.tbl_contains({ "kotlin", "c", "cpp", "java", "python" }, vim.bo.filetype) then
    vim.notify("Open a C, C++, Java, Kotlin, or Python file first", vim.log.levels.WARN)
    return
  end
  vim.cmd.write()
  vim.cmd("botright 12split")
  vim.cmd.enew()
  vim.fn.jobstart({ vim.fn.expand("~/.local/bin/devrun"), file }, { term = true })
  vim.cmd.startinsert()
end, { desc = "Run current source file" })
