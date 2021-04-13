" Use vim-plug for plugin management (:Plug[Install|Update])
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

" misc
Plug 'junegunn/vim-easy-align'

" https://github.com/neoclide/coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
Plug 'josa42/coc-go'

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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
Plug 'ElmCast/elm-vim'

"Swift
Plug 'toyamarinyon/vim-swift'

"Javascript
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'

"Status Bar
" Plug 'vim-airline/vim-airline'

call plug#end()
