require('dap-python').setup('~/.nix-profile/bin/python3/')
require('telescope').load_extension('dap')
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true }, })
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace"
			}
		}
	}
})
require('nvim-dap-virtual-text').setup()

vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F1>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

