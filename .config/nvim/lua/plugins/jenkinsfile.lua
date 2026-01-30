-- Jenkinsfile is Groovy-based; use treesitter groovy parser for highlighting
return {
    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            vim.filetype.add({
                filename = {
                    ["Jenkinsfile"] = "groovy",
                },
                pattern = {
                    ["Jenkinsfile.*"] = "groovy",
                },
            })
        end,
    },
}
