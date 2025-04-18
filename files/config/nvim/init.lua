-- Matt Casper's neovim config
-- https://github.com/mcasper/dotfiles

-- lazy.nvim
require("config.lazy")

-- Mapping helpers
function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
    map("n", shortcut, command)
end

function vmap(shortcut, command)
    map("v", shortcut, command)
end

vim.cmd.filetype({ "plugin", "indent", "on" })

-- Options
vim.opt.relativenumber = true;
vim.opt.wildmenu = true
vim.opt.backspace = "indent,eol,start"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.history = 500
vim.opt.autoread = true
vim.opt.laststatus = 2
vim.opt.tags = "./tags"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hidden = true
vim.opt.mouse = ""
vim.opt.backup = true
vim.opt.backupdir = "~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp"
vim.opt.directory = "~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp"
vim.opt.clipboard = "unnamed"
vim.opt.colorcolumn = "80"
vim.opt.ruler = true
vim.opt.synmaxcol = 250
vim.opt.guicursor = "a:hor10"

-- Autocmds
vim.cmd([[
    " Try to preserve the underline cursor
    autocmd VimLeave * set guicursor=a:hor10
    autocmd BufEnter * set guicursor=a:hor10
    autocmd BufLeave * set guicursor=a:hor10
    autocmd VimLeave * call system('printf "\e[5 q" > $TTY')

    " 4 spaces for cpp
    autocmd FileType cpp setlocal shiftwidth=4 tabstop=4

    augroup vimrcEx
        "for ruby, autoindent with two spaces, always expand tabs
        autocmd FileType ruby,haml,eruby,yaml,fdoc,html,javascript,sass,cucumber set ai sw=2 sts=2 et
        autocmd FileType go set ai sw=4 sts=4 et nolist

        autocmd BufNewFile,BufRead *.fdoc setfiletype yaml
        autocmd Filetype yaml set nocursorline
        autocmd BufNewFile,BufRead *.sass setfiletype sass
    augroup END

    autocmd FileType gitcommit setlocal spell textwidth=72
    hi MatchParen cterm=none ctermbg=black ctermfg=yellow
]])

-- Mappings
nmap("<Leader>w", ":w!<CR>")
nmap("<Leader>q", ":bd<CR>")
nmap("<Leader>Q", ":q<CR>")
nmap("<Leader>f", ":FZF<CR>")
nmap("<Leader>vi", ":tabe ~/.config/nvim/init.lua<CR>")
nmap("<Leader>vp", ":tabe ~/.config/nvim/plugins.vim<CR>")
nmap("<Leader>vs", ":source ~/.config/nvim/init.lua<CR>")
nmap("<Leader>c", " :bp\\|bd #<CR>")
nmap("<Leader>ws", ":%s/\\s\\+$//<CR>")
nmap("<Leader>le", ":%s/\\r$//<CR>")
nmap("<Leader>hs", ":s/:\\([^ ]*\\)\\(\\s*\\)=>/\1:/g<CR>")
nmap("<Leader>i", ":lua CorrectIndentation()<CR>")
nmap("<Leader>n", ":lua RenameFile()<CR>")
nmap("<Leader>p", ":call AddDebugger(\"o\")<CR>")
nmap("<Leader>P", ":call AddDebugger(\"O\")<CR>")
nmap("<Leader>d", ":call RemoveAllDebuggers()<CR>")

nmap("<Leader>a", "<cmd>ArgWrap<CR>")
vim.g.argwrap_tail_comma = true

nmap("aa", ":call CocAction('diagnosticNext')<cr>")
nmap("<Leader>s", ":TestNearest<CR>")
nmap("<Leader>r", ":TestFile<CR>")

nmap("<C-\\>", ":tab split<CR>:exec(\"tag \".expand(\"<cword>\"))<CR>")
vmap("<Enter>", "<Plug>(EasyAlign)")
nmap("k", "gk")
nmap("j", "gj")
nmap("<C-j>", "<C-W>j")
nmap("<C-k>", "<C-W>k")
nmap("<C-h>", "<C-W>h")
nmap("<C-l>", "<C-W>l")
nmap("<Right>", ":bn<CR>")
nmap("<Left>", ":bp<CR>")

nmap("K", ":Rg <C-R><C-W><CR>")

-- FZF ripgrep command
vim.cmd([[
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
]])

vim.cmd([[
    " Enter should clear search
    function! MapCR()
        nnoremap <CR> :nohlsearch<CR>
    endfunction
    call MapCR()
]])

function CorrectIndentation()
  vim.cmd([[silent normal! gg=G]])
end

function RenameFile()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', old_name, 'file')
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd('saveas ' .. new_name)
    vim.cmd('silent !rm ' .. old_name)
  end
end
