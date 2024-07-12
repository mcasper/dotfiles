return {
    {
        "junegunn/seoul256.vim",
        lazy = false,
        config = function()
            -- TODO: light mode
            vim.cmd([[let g:seoul256_background = 234]])
            vim.cmd([[colo seoul256]])
            vim.cmd([[set background=dark]])
        end,
    }
}
