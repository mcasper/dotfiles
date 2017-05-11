" Matt Casper's nvim config
" https://github.com/mcasper/dotfiles

" Use vim-plug for plugin management (:Plug[Install|Update])
" https://github.com/junegunn/vim-plug

" Plugins
if filereadable(expand("$HOME/.config/nvim/plugins.vim"))
  source $HOME/.config/nvim/plugins.vim
endif

" Functions
if filereadable(expand("$HOME/.config/nvim/functions.vim"))
  source $HOME/.config/nvim/functions.vim
endif

" Basic Config

syntax on
filetype plugin indent on

set nocompatible
set relativenumber
set wildmenu
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set softtabstop=2
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
set mouse=""
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Color and UI
" colorscheme hybrid
" colorscheme flattened_light
" https://github.com/junegunn/seoul256.vim
let g:seoul256_background = 234
colo seoul256

set background=dark
set colorcolumn=80
set cursorline
set ruler
set synmaxcol=250

" Plugin Settings
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

let g:jsx_ext_required = 0

let test#strategy = "neovim"

" Verify These

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3

let g:elm_format_autosave = 1

" Autocmds

augroup vimrcEx
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,fdoc,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType go set ai sw=4 sts=4 et nolist

  autocmd BufNewFile,BufRead *.fdoc setfiletype yaml
  autocmd Filetype yaml set nocursorline
  autocmd BufNewFile,BufRead *.sass setfiletype sass
augroup END

autocmd FileType gitcommit setlocal spell textwidth=72

" Mappings

let mapleader = "\<Space>"

map <Leader>w :w!<CR>
map <Leader>q :bd<CR>
map <Leader>Q :q<CR>
map <Leader>f  :FZF<CR>
map <Leader>vi :tabe ~/.config/nvim/init.vim<CR>
map <Leader>vs :source ~/.config/nvim/init.vim<CR>
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

nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>r :TestFile<CR>

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

" OTHER STUFF I STOLE FROM BEN
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
