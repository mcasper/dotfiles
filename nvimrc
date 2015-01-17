"
" Matt Casper's vimrc
"
" github.com/mcasper/dotfiles

"Colorscheme settings
let g:gruvbox_italic=0

"==============
" Vundle setup
"==============
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

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
colorscheme gruvbox
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

if executable('ag')
    " Use Ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
endif

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
map <Leader>ar :topleft :split config/routes.rb<CR>
map <Leader>f  :CtrlPRoot<CR>
map <Leader>aa :CtrlP app<CR>
map <Leader>as :CtrlP spec<CR>
map <Leader>ad :CtrlP db<CR>
map <Leader>af :CtrlP engines/checklist<CR>
map <Leader>av :CtrlP app/views<CR>
map <Leader>ac :CtrlP app/controllers<CR>
map <Leader>am :CtrlP app/models<CR>
map <Leader>ag :topleft 20 :split Gemfile<CR>
map <Leader>b :CtrlPBuffer<CR>
map <Leader>p obinding.pry<C-c>
map <Leader>P Obinding.pry<C-c>
map <Leader>vi :tabe ~/.nvimrc<CR>
map <Leader>vs :source ~/.nvimrc<CR>
map <Leader>c :bp\|bd #<CR>
map <Leader>ws :%s/\s\+$//<CR>
map <Leader>le :%s/\r$//<CR>

"====================
"Thoughtbot vim-rspec
"====================

map <Leader>t :call RunLastSpec()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>a :call RunAllSpecs()<CR>

let g:rspec_command = "!bin/rspec {spec}"


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
map <Leader>n :call RenameFile()<cr>

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

map <Leader>
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
