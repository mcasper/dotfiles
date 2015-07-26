"
" Matt Casper's vimrc
"
" github.com/mcasper/dotfiles

"Colorscheme settings
let g:gruvbox_italic=0

"==============
" Vundle setup
"==============
"
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" Let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

"misc
Plugin 'airblade/vim-gitgutter'
Plugin 'tomtom/tcomment_vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'rking/ag.vim'
Plugin 'ervandew/supertab'

"tpope
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'

"rails/ruby
Plugin 'thoughtbot/vim-rspec'

"colors
Plugin 'flazz/vim-colorschemes'

"Highlighting
Plugin 'Keithbsmiley/rspec.vim'

"rubocop
Plugin 'ngmy/vim-rubocop'

"Fuzzy Finder
Plugin 'junegunn/fzf'

"Elixir
Plugin 'elixir-lang/vim-elixir'

"Testing
Plugin 'janko-m/vim-test'

filetype on

"============================
" BASIC EDITING CONFIGURATION
"============================

syntax on
filetype plugin indent on
set nocompatible
set relativenumber
set wildmenu
set backspace=indent,eol,start

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent

set splitbelow
set splitright

set history=500
set autoread
set laststatus=2
set tags=./tags;
set hlsearch
set ignorecase smartcase
set hidden

"Color and UI
colorscheme hybrid
" colorscheme flattened_light
" colorscheme gruvbox
" set background=light
set background=dark
set colorcolumn=80
set cursorline
set ruler
set synmaxcol=250

"SPEEEEEEEEEEEEEED
" set re=1

let mapleader = " "

"===============
"PLUGIN SETTINGS
"===============

let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec2 {spec}"
let g:vimrubocop_config = "./.rubocop.yml"

"==================
"SETTINGS BY OTHERS
"==================

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

"=========
"AUTOCMDS
"=========

augroup vimrcEx
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,fdoc,html,javascript,sass,cucumber set ai sw=2 sts=2 et

  autocmd BufNewFile,BufRead *.fdoc setfiletype yaml
  autocmd Filetype yaml set nocursorline
  autocmd BufNewFile,BufRead *.sass setfiletype sass
augroup END

autocmd FileType gitcommit setlocal spell textwidth=72

""""""""""""""""""
" MY KEY BINDINGS
""""""""""""""""""

"LEADER
map <Leader>w :w!<CR>
map <Leader>q :bd<CR>
map <Leader>Q :q<CR>
map <Leader>ar :topleft :split config/routes.rb<CR>
map <Leader>f  :FZF<CR>
map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>vs :source ~/.vimrc<CR>
map <Leader>c  :bp\|bd #<CR>
map <Leader>ws :%s/\s\+$//<CR>
map <Leader>le :%s/\r$//<CR>
map <Leader>hs :s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
map <Leader>P :call Debugging("O")<cr>
map <Leader>p :call Debugging("o")<cr>
map <Leader>i :call CorrectIndentation()<cr>
map <Leader>n :call RenameFile()<cr>

"====================
"Thoughtbot vim-rspec
"====================

" map <Leader>t :call RunLastSpec()<CR>
" map <Leader>s :call RunNearestSpec()<CR>
" map <Leader>r :call RunCurrentSpecFile()<CR>
" map <Leader>a :call RunAllSpecs()<CR>

" let g:rspec_command = "!bin/rspec {spec}"

"============
"Test Running
"============
nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>r :TestFile<CR>

"""""""""""""""""""""
" Correct Indentation
"""""""""""""""""""""
function! CorrectIndentation()
  execute "silent normal! gg=G"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt) (Ben Orenstein)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""
" Infer debugger type from file extension
"""""""""""""""""""""""""""""""""""""""""
function! Debugging(direction)
  let file_path = expand('%')
  let file = split(file_path, "/")[-1]
  let rb = matchstr(file, "\.rb")
  let ex = matchstr(file, "\.ex")
  let erb = matchstr(file, "\.erb")
  let eex = matchstr(file, "\.eex")
  let json = matchstr(file, "\.json")
  let js = matchstr(file, "\.js")

  let @g = a:direction

  if rb == ".rb"
    normal! @grequire "pry"; binding.pry
  elseif ex == ".ex"
    normal! @grequire IEx; IEx.pry
  elseif erb == ".erb"
    normal! @g<% require "pry"; binding.pry %>
  elseif eex == ".eex"
    normal! @g<%= require IEx; IEx.pry %>
  elseif json == ".json"
    normal! @grequire "pry"; binding.pry
  elseif js == ".js"
    normal! @gdebugger;
  else
    normal! @gCouldn't figure out the debugger type, add support for this file extension
  endif
endfunction

"""""""""""""""""""""""""""""
"OTHER STUFF I STOLE FROM BEN
"""""""""""""""""""""""""""""
" Display extra whitespace
set list listchars=tab:»·,trail:·

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Make it more obvious which paren I'm on
hi MatchParen cterm=none ctermbg=black ctermfg=yellow

"OTHER
function! MapCR()
  nnoremap <CR> :nohlsearch<CR>
endfunction
call MapCR()

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
vmap <Enter> <Plug>(EasyAlign)
nmap k gk
nmap j gj
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <Right> :bn<CR>
map <Left> :bp<CR>
