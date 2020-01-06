" Use vim-plug for plugin management (:Plug[Install|Update])
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

" misc
Plug 'junegunn/vim-easy-align'

" Completion
" Plug 'ervandew/supertab'
" Plug 'valloric/youcompleteme'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'roxma/nvim-completion-manager'
" Requirement of ncm2
" Plug 'ncm2/ncm2'
" Plug 'roxma/nvim-yarp'
" Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
" Plug 'ncm2/ncm2-racer'
" Plug 'racer-rust/vim-racer'
" Plug 'ncm2/ncm2-cssomni'
" Plug 'ncm2/ncm2-tmux'
" Plug 'ncm2/ncm2-match-highlight'
" Plug 'ncm2/ncm2-bufword'

" Plug 'othree/csscomplete.vim'
" Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
" Plug 'roxma/ncm-elm-oracle'
" Plug 'racer-rust/vim-racer'
" Plug 'roxma/nvim-cm-racer'
" Plug 'roxma/ncm-rct-complete'
"
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
" Plug 'pbogut/deoplete-elm', { 'do': 'npm install -g elm-oracle' }

" Asynchronous Building/Linting
Plug 'neomake/neomake'

"tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'

" colors
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/seoul256.vim'
Plug 'reedes/vim-colors-pencil'

"Fuzzy Finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Elixir
Plug 'elixir-lang/vim-elixir'
" Plug 'mhinz/vim-mix-format'

" Terraform
Plug 'hashivim/vim-terraform'

"Ruby/Rails Testing
Plug 'benmills/vimux'
Plug 'janko-m/vim-test'
Plug 'ngmy/vim-rubocop'

"Crystal
Plug 'rhysd/vim-crystal'

"File Utils
Plug 'pbrisbin/vim-mkdir'

"Debugging
Plug 'mcasper/vim-infer-debugger'

"Puppet
Plug 'rodjek/vim-puppet'

"Rust
Plug 'rust-lang/rust.vim'

"Haskell
Plug 'neovimhaskell/haskell-vim'

"Go
Plug 'fatih/vim-go'

"Elm
" Plug 'lambdatoast/elm.vim'
Plug 'ElmCast/elm-vim'
" Plug 'mdxprograms/elm-vim', { 'branch': 'patch-1' }

"Swift
Plug 'toyamarinyon/vim-swift'

"Javascript
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'

"Status Bar
" Plug 'vim-airline/vim-airline'

"Searching
Plug 'rking/ag.vim'

"AutoFormat
" Plug 'Chiel92/vim-autoformat'

call plug#end()
