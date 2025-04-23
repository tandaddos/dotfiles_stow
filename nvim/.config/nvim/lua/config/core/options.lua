vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- tree style presentation
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- tabs/indents
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.autoindent = true
opt.expandtab = true
opt.smarttab = true

-- search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- numbering
opt.number = true
opt.relativenumber = true

-- background/foreground color per colorsheme
opt.termguicolors = true
opt.background = "dark" -- prefer dark
opt.signcolumn = "yes"  -- turn on sign column so text doesn't shift

-- sessions
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.undofile = true -- store undos between sessions

-- window splits
opt.splitright = true
opt.splitbelow = true

opt.cursorline = true -- show line under cursor``
-- opt.cursorcolumn = true -- show column
opt.breakindent = true

opt.backspace = "indent,eol,start"  -- allow backspace in these cases
opt.clipboard:append("unnamedplus") -- add system clipboard as default
opt.wrap = false

opt.hidden = false         -- Required to keep multiple buffers open multiple buffers
opt.encoding = "utf-8"     -- The encoding displayed
opt.fileencoding = "utf-8" -- The encoding written to file
opt.ruler = true           -- Show the cursor position all the time

-- how whitespaces are displayed
opt.list = false
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.inccommand = "split" -- preview substitutions live, as you type
opt.scrolloff = 10       -- number of lines to keep above and below cursor
opt.cmdheight = 0        -- disable commandline till needed

-- misc
opt.iskeyword:append("-") -- treat dash separated words as a word text object--
opt.mouse = "nvica"       -- Enable your mouse e.g. nvichar
opt.updatetime = 300      -- Faster completion
opt.timeoutlen = 500      -- By default timeoutlen is 1000 ms

-- opt.formatoptions:append("-cro") -- Stop newline continuation of comments

opt.autochdir = false -- Your working directory will always be the same as your working directory
opt.title = true      -- title automatically

-- tag files
opt.tags.append("./tags,tags")
