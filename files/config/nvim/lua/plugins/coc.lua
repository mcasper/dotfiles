return {
  "neoclide/coc.nvim",
  branch = "release",
  event = "VeryLazy",
  config = function()
    vim.cmd([[
    "COC
    inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> <F3> <Plug>(coc-rename)

    " Find symbol of current document.
    nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>

    nmap <silent> <F2> <Plug>(coc-diagnostic-next)

    let g:coc_filetype_map = {
      \ 'rspec.ruby': 'ruby',
      \ }
  ]])
  end,
}
