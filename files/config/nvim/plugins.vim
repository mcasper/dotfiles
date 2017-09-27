" Use vim-plug for plugin management (:Plug[Install|Update])
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

" misc
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'

" Completion
" Plug 'ervandew/supertab'
Plug 'valloric/youcompleteme'

"tpope
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" colors
Plug 'flazz/vim-colorschemes'
Plug 'reedes/vim-colors-pencil'
Plug 'junegunn/seoul256.vim'

"Fuzzy Finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Elixir
Plug 'elixir-lang/vim-elixir'

"Ruby/Rails Testing
Plug 'janko-m/vim-test'
Plug 'benmills/vimux'

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
" Plug 'ElmCast/elm-vim'
Plug 'mdxprograms/elm-vim', { 'branch': 'patch-1' }

"Swift
Plug 'toyamarinyon/vim-swift'

"Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

"Status Bar
" Plug 'vim-airline/vim-airline'

"Searching
Plug 'rking/ag.vim'

"AutoFormat
" Plug 'Chiel92/vim-autoformat'

call plug#end()
