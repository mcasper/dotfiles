"Matt Casper's vimrc
"https://github.com/mcasper/dotfiles

"Use vim-plug for plugin management (Plug[Install|Update])
"https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

"misc
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/vim-easy-align'
Plug 'ervandew/supertab'

"tpope
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

"colors
Plug 'flazz/vim-colorschemes'
Plug 'reedes/vim-colors-pencil'
Plug 'junegunn/seoul256.vim'

"Highlighting
Plug 'Keithbsmiley/rspec.vim'

"Fuzzy Finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Elixir
Plug 'elixir-lang/vim-elixir'

"Ruby/Rails Testing
Plug 'janko-m/vim-test'

"File Utils
Plug 'pbrisbin/vim-mkdir'

"Debugging
Plug 'mcasper/vim-infer-debugger'

"Puppet
Plug 'rodjek/vim-puppet'

"Rust
Plug 'rust-lang/rust.vim'

"Go
Plug 'fatih/vim-go'

"Elm
" Plug 'lambdatoast/elm.vim'
Plug 'ElmCast/elm-vim'

"Swift
Plug 'toyamarinyon/vim-swift'

"Status Bar
Plug 'vim-airline/vim-airline'

"Searching
Plug 'rking/ag.vim'

"AutoFormat
" Plug 'Chiel92/vim-autoformat'

call plug#end()

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
" colorscheme hybrid
" colorscheme flattened_light
" https://github.com/junegunn/seoul256.vim
let g:seoul256_background = 234
colo seoul256
" colorscheme hybrid
set background=dark
set colorcolumn=80
set cursorline
set ruler
set synmaxcol=250

" Pencil Settings
let g:pencil_terminal_italics = 0
let g:pencil_neutral_code_bg = 1
let g:pencil_neutral_headings = 1
let g:pencil_higher_contrast_ui = 1
let g:airline_theme = 'pencil'

let mapleader = " "

"===============
"PLUGIN SETTINGS
"===============

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

let g:elm_format_autosave = 1

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
  autocmd FileType go set ai sw=4 sts=4 et nolist

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
map <Leader>f  :FZF<CR>
map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>vs :source ~/.vimrc<CR>
map <Leader>c  :bp\|bd #<CR>
map <Leader>ws :%s/\s\+$//<CR>
map <Leader>le :%s/\r$//<CR>
map <Leader>hs :s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
map <Leader>i :call CorrectIndentation()<cr>
map <Leader>n :call RenameFile()<cr>
map <Leader>p :call AddDebugger("o")<cr>
map <Leader>P :call AddDebugger("O")<cr>
map <Leader>d :call RemoveAllDebuggers()<cr>

" Turn into function
map <Leader>ar :topleft :split config/routes.rb<CR>

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
" RENAME CURRENT FILE (thanks Gary Bernhardt) (thanks Ben Orenstein)
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
