require('dap-python').setup('~/.nix-profile/bin/python3/')
require('telescope').load_extension('dap')
require("dapui").setup()
	local dap, dapui = require("dap"), require("dapui")
	dap.listeners.before.attach.dapui_config = function()
		dap.repl.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		dap.repl.open()
	end
	--dap.listeners.after.launch.dapui_config = function()
	--end
	--dap.listeners.after.event_initialized.dapui_config = function()
		--os.execute("sleep " .. tonumber(3))
		--vim.cmd('wincmd J')
		--vim.cmd('startinsert')
	--end
	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
		dap.repl.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
		dap.repl.close()
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

--below are in lspconfig.lua file, locally activated
--
--vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
--vim.keymap.set('n', '<F6>', function() require('dap').restart() end)
--vim.keymap.set('n', '<F3>', function() require('dap').step_over() end)
--vim.keymap.set('n', '<F1>', function() require('dap').step_into() end)
--vim.keymap.set('n', '<F2>', function() require('dap').step_out() end)
--vim.keymap.set('n', '<leader>s', function() require('dap').terminate() end)
--vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
--vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
--vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
--vim.keymap.set('n', '<leader>lb', function() require('dap').list_breakpoints() end)
--vim.keymap.set('n', '<leader>cb', function() require('dap').clear_breakpoints() end)
--vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
--vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
--vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
--vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() require('dap.ui.widgets').preview() end)
--vim.keymap.set('n', '<Leader>df', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.frames) end)
--vim.keymap.set('n', '<Leader>ds', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.scopes) end)
--vim.keymap.set("n", "<leader>dc", ":lua require'dap'.repl.close()<CR>")
--vim.keymap.set("n", "<leader>dt", ":lua require'dapui'.toggle()<CR>")
