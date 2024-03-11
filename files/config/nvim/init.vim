" Matt Casper's nvim config
" https://github.com/mcasper/dotfiles

" Use vim-plug for plugin management (:Plug[Install|Update])
" https://github.com/junegunn/vim-plug

" TODO: Support this windows version
" " Plugins
" if filereadable(expand("$LOCALAPPDATA/nvim/plugins.vim"))
"   source $LOCALAPPDATA/nvim/plugins.vim
" endif

" " Functions
" if filereadable(expand("$LOCALAPPDATA/nvim/functions.vim"))
"   source $LOCALAPPDATA/nvim/functions.vim
" endif

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

set relativenumber
set wildmenu
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set cursorline
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
set clipboard=unnamed

" Color and UI
if $LIGHT_SHELL
  " Light
  let g:seoul256_background = 255
  colo seoul256-light
  set background=light
else
  " Dark
  let g:seoul256_background = 234
  colo seoul256
  set background=dark
endif

set colorcolumn=80
set ruler
set synmaxcol=250

set guicursor=a:hor10
autocmd VimLeave * set guicursor=a:hor10
autocmd BufEnter * set guicursor=a:hor10
autocmd BufLeave * set guicursor=a:hor10
autocmd VimLeave * call system('printf "\e[5 q" > $TTY')

" 4 spaces for cpp
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4

" Plugin Settings

" FZF
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

let g:jsx_ext_required = 0
let g:mix_format_silent_errors = 1

" let g:python2_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

set shortmess+=c
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
let g:rust_src_path = '/Users/mattcasper/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src'


" Verify These

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3

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
" TODO: Windows versions
" map <Leader>vi :tabe $LOCALAPPDATA/nvim/init.vim<CR>
" map <Leader>vl :tabe $LOCALAPPDATA/nvim/lua/init.lua<CR>
" map <Leader>vp :tabe $LOCALAPPDATA/nvim/plugins.vim<CR>
" map <Leader>vs :source $LOCALAPPDATA/nvim/init.vim<CR>
map <Leader>vi :tabe ~/.config/nvim/init.vim<CR>
map <Leader>vl :tabe ~/.config/nvim/lua/init.lua<CR>
map <Leader>vp :tabe ~/.config/nvim/plugins.vim<CR>
map <Leader>vs :source ~/.config/nvim/init.vim<CR>
map <Leader>c  :bp\|bd #<CR>
map <Leader>ws :%s/\s\+$//<CR>
map <Leader>le :%s/\r$//<CR>
map <Leader>hs :s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>
map <Leader>i :call CorrectIndentation()<CR>
map <Leader>n :call RenameFile()<CR>
map <Leader>p :call AddDebugger("o")<CR>
map <Leader>P :call AddDebugger("O")<CR>
map <Leader>d :call RemoveAllDebuggers()<CR>
map <Leader>a :CocAction<CR>

try
    nmap <silent> aa :call CocAction('diagnosticNext')<cr>
endtry

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

" Start to migrate over to lua based config
lua require('init')
