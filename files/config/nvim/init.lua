-- Matt Casper's neovim config
-- https://github.com/mcasper/dotfiles

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

-- Plugins

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Arg (un)wrapping
    {
      "FooSoft/vim-argwrap",
    },

    -- Formatting
    {
      "stevearc/conform.nvim",
      config = function()
        -- Command to enable/disable autoformat-on-save
        vim.api.nvim_create_user_command("FormatDisable", function(args)
          if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat-on-save",
          bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
          desc = "Re-enable autoformat-on-save",
        })

        require("conform").setup({
          formatters_by_ft = {
            eruby = { "erb_format", "rustywind" },
            javascript = { "biome", "biome-check", "biome-organize-imports", "rustywind" },
            lua = { "stylua" },
            python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
            -- ruby = { "syntax_tree", " rubocop" },
            rust = { "rustfmt", lsp_format = "fallback" },
            toml = { "taplo" },
            typescript = { "biome", "biome-check", "biome-organize-imports", "rustywind" },
            typescriptreact = { "biome", "biome-check", "biome-organize-imports", "rustywind" },
          },
          format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end,
        })
      end,
    },

    -- Git
    {
      "tpope/vim-fugitive"
    },

    -- Fuzzy search
    {
        "junegunn/fzf",
    },
    {
        "junegunn/fzf.vim",
    },

    -- Golang
    {
      "fatih/vim-go"
    },

    -- Terraform/Packer
    {
      "jvirtanen/vim-hcl"
    },

    -- Breakpoints
    {
      "mcasper/vim-infer-debugger"
    },

    -- LSP
    {
      "neovim/nvim-lspconfig",
      config = function()
        vim.lsp.enable("ruby_lsp")
        vim.lsp.enable("ts_ls")
        vim.lsp.enable("tailwindcss")
        vim.lsp.enable("basedpyright")

        vim.diagnostic.config({
          virtual_lines = {
            current_line = true,
          },
        })
      end,
    },

    -- Mkdir
    {
      "pbrisbin/vim-mkdir"
    },

    -- Colors
    {
        "junegunn/seoul256.vim",
        lazy = false,
        config = function()
            -- TODO: light mode
            -- vim.cmd([[let g:seoul256_background = 255]])
            -- vim.cmd([[colo seoul256-light]])
            -- vim.cmd([[set background=light]])

            vim.cmd([[let g:seoul256_background = 234]])
            vim.cmd([[colo seoul256]])
            vim.cmd([[set background=dark]])
        end,
    },

    -- Autocomplete
    {
        {
          "supermaven-inc/supermaven-nvim",
          commit = "40bde487fe31723cdd180843b182f70c6a991226",
          config = function()
            require("supermaven-nvim").setup({})
          end,
        }
    },

    -- Tests
    {
        "vim-test/vim-test",
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      event = "BufRead",
      config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = {
            "lua",
            "javascript",
            "html",
            "css",
            "typescript",
            "tsx",
            "ruby",
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    },

    -- Terraform again?
    {
      'hashivim/vim-terraform'
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
})
