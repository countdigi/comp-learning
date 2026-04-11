------------------------------------------------------------------------------------------------------
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
------------------------------------------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

------------------------------------------------------------------------------------------------------
-- Install package manager
------------------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    "--filter=blob:none",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  ---------------------------------------------------------------------------------------------------
  --- nvim-telescope
  ---------------------------------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  ---------------------------------------------------------------------------------------------------
  --- lualine
  ---------------------------------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      sections = {
        lualine_c = {
          { "filename", path = 1 },
        },
      },
    },
    config = true,
  },
  ---------------------------------------------------------------------------------------------------
  --- treesitter
  ---------------------------------------------------------------------------------------------------
  {
	  "nvim-treesitter/nvim-treesitter",
    lazy = false,
  	build = ":TSUpdate",
  },
  ---------------------------------------------------------------------------------------------------
  --- theme-nord
  ---------------------------------------------------------------------------------------------------
  {
    "shaunsingh/nord.nvim",
    lazy = false,          -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,       -- make sure to load this before all the other start plugins
    config = function()
      vim.g.nord_disable_background = true
      require("nord").set()
    end,
  },
  ---------------------------------------------------------------------------------------------------
  --- mrcjkb/nvim-lastplace
  ---------------------------------------------------------------------------------------------------
  {
    "mrcjkb/nvim-lastplace",
  },
})

------------------------------------------------------------------------------------------------------
--- Options
------------------------------------------------------------------------------------------------------

vim.opt.autoindent = true              -- copy indent from current line when starting new one
vim.opt.backspace = "indent,eol,start" -- allow backspace on
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = { "unnamedplus" }
vim.opt.cmdheight = 1                       -- more space in the neovim command line for displaying messages
vim.opt.colorcolumn = "102"
vim.opt.completeopt = { "menuone", "longest" }
vim.opt.conceallevel = 0                    -- so that `` is visible in markdown files
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.hlsearch = false                    -- Set highlight on search
vim.opt.ignorecase = true
vim.opt.linebreak = true                    -- companion to wrap don't split words
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.pumheight = 62        -- pop up menu height
vim.opt.relativenumber = true
vim.opt.scrolloff = 0         -- minimal number of screen lines to keep above and below the cursor
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.showmode = false      -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2       -- always show tabs
vim.opt.sidescrolloff = 8     -- minimal number of screen columns either side of cursor if wrap is `false`
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true     -- make indenting smarter again
vim.opt.softtabstop = 2
vim.opt.splitbelow = false     -- force all horizontal splits to go below current window
vim.opt.splitright = true      -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false       -- creates a swapfile
vim.opt.tabstop = 2
vim.opt.undofile = true
vim.opt.whichwrap = "bs<>[]hl" -- which "horizontal" keys are allowed to travel to prev/next line
vim.opt.wrap = true
vim.opt.writebackup = false    -- if file edited by another
vim.opt.iskeyword:append({"/", "-", "."})

------------------------------------------------------------------------------------------------------

function custom_gf_handler()
  local path = vim.fn.expand("<cfile>")
  if path:sub(1, 1) == '/' then
    path = path:sub(2)
  end
  vim.cmd("edit " .. path)
end

vim.keymap.set("n", "<leader>1", "<cmd>e ~/my/wrk/todo.md<cr>")
vim.keymap.set("n", "<leader>2", "<cmd>e ~/my/wrk/work.md<cr>")
vim.keymap.set("n", "<leader>3", "<cmd>e ~/my/wrk/pad.md<cr>")
vim.keymap.set("n", "<leader>4", "<cmd>e ~/my/wrk/name.txt<cr>")
vim.keymap.set("n", "<leader>5", "<cmd>e ~/my/wrk/msc/marks.md<cr>")
vim.keymap.set("n", "<leader>6", "<cmd>e ~/my/wrk/log.md<cr>")
vim.keymap.set("n", "<leader>/",  function() require("telescope.builtin").current_buffer_fuzzy_find() end)
vim.keymap.set("n", "<leader>?",  function() require("telescope.builtin").current_buffer_fuzzy_find({sorting_strategy="ascending"}) end)

vim.keymap.set("n", "<leader>qv", function() require("telescope.builtin").find_files({ cwd = "~/dev/countdigi/vid" }) end)
vim.keymap.set("n", "<leader>fo", function() require("telescope.builtin").oldfiles() end)
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end)
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end)

-- keys = {
--   { "<leader>fh", function() require("telescope.builtin").help_tags() end, },
--   { "<leader>fr", function() require("telescope.builtin").find_files({ no_ignore = true }) end, },
--   { "<leader>fn", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, },
--   { "<leader>fw", function() require("telescope.builtin").find_files({ cwd = "~/my/wrk" }) end, },
--   { "<leader>fd", function() require("telescope.builtin").find_files({ cwd = "~/my/docs" }) end, },
-- },


vim.keymap.set("n", "<leader>-", "O<esc>101i-<esc>")
vim.keymap.set("n", "<leader><tab>", ":bnext<enter>")
vim.keymap.set("n", "<leader>b", ":Telescope buffers<cr>")
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>o", "<C-w>o")
vim.keymap.set("n", "<leader>w", "<C-w>w")
vim.keymap.set("n", "<leader>z", "<C-z>")
vim.keymap.set("n", "<leader>r", ":.!z lang-tr<cr>")
vim.keymap.set("n", "<leader>d", ":lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "<leader>t", "<cmd>Outline<cr>")
vim.keymap.set("n", "<C-j>", "20jz.")
vim.keymap.set("n", "<C-k>", "20kz.")
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "<right>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<left>", "<cmd>cprev<cr>")
vim.keymap.set("n", "<leader>c", "<cmd>call system('snippet', getreg('0'))<cr>:echom 'copied'<cr>")
vim.keymap.set("n", "<leader>p", "<cmd>r!snippet paste<cr>")
vim.keymap.set("n", "gf", "<cmd>lua custom_gf_handler()<cr>")
vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gc", ":lua vim.lsp.buf.incoming_calls()<cr>")
vim.keymap.set("n", "gn", ":lua vim.lsp.buf.rename()<cr>")
vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<cr>")
vim.keymap.set("n", "=", ":!z.sys.sync.wrk<cr>")

------------------------------------------------------------------------------------------------------
-- autocommands
------------------------------------------------------------------------------------------------------

local mygrp = vim.api.nvim_create_augroup("mygrp", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  -- remove trailing whitespace from all lines before saving a file
  group = mygrp,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = mygrp,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 1000 })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = mygrp,
  pattern = "ledger",
  callback = function()
    vim.opt.iskeyword:append({":"})
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = mygrp,
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>r", ":! pandoc % > ~/tmp/README.html; open ~/tmp/README.html;<cr>")
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.tabstop = 2
    vim.opt.colorcolumn = "102"
    vim.keymap.set("n", "<leader>d", "<cmd>.!date +'\\#\\# \\%F'<cr>o<cr>", { buffer = 0 })
    vim.cmd("hi Normal guifg=darkgrey")
    vim.cmd("hi Special guifg=#ccc077")
    vim.cmd("hi Underlined guifg=darkcyan")
    vim.cmd("hi @markup.heading.3.markdown guifg=#509070")
    vim.cmd("hi @markup.link.markdown_inline guifg=white")
    vim.cmd("hi @markup.link.label.markdown_inline guifg=yellow")
    vim.cmd("hi @markup.link.url.markdown_inline guifg=lightblue")
  end,
})
