local options = { filetype = { "markdown" } }

local function init()
    vim.api.nvim_create_augroup("ZathuraMD", {
        clear = false,
    })

    local file_path
    local stripped_path
    local pdf_path
    local zathura_pid
    vim.api.nvim_create_autocmd("BufEnter", {
        group = "ZathuraMD",
        callback = function(arg)
            if vim.tbl_contains(options.filetype, vim.bo[arg.buf].filetype) then
                file_path = vim.fn.expand("%:p")
                stripped_path = file_path:match("^(.+)%..+$") or file_path
                pdf_path = stripped_path .. ".pdf"
                if vim.fn.filereadable(pdf_path) ~= 1 then
                    vim.fn.system("pandoc -V geometry:margin=1in -i " .. file_path .. " -o " .. pdf_path)
                end

                vim.fn.system("zathura " .. pdf_path .. " &")
                zathura_pid = vim.fn.system("pidof zathura")
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = "ZathuraMD",
        callback = function()
            vim.fn.system("pandoc -V geometry:margin=1in -i " .. file_path .. " -o " .. pdf_path)
        end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave", "VimLeave" }, {
        group = "ZathuraMD",
        callback = function()
            vim.fn.system("kill " .. zathura_pid)
        end,
    })
end

local M = {}

M.setup = function(opts)
    vim.tbl_extend("force", options, opts)

    init()
end

return M
