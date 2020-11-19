" Use vim-plug for plugin management (:Plug[Install|Update])
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

" misc
Plug 'junegunn/vim-easy-align'

" Completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

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
Plug 'mhinz/vim-mix-format'

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
Plug 'ElmCast/elm-vim'

"Swift
Plug 'toyamarinyon/vim-swift'

"Javascript
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'

"Status Bar
" Plug 'vim-airline/vim-airline'

call plug#end()
