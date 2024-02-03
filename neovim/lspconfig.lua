local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.nil_ls.setup {
	capabilities = lsp_capabilities,
	on_attach = on_attach,
}
lspconfig.marksman.setup {
	capabilities = lsp_capabilities,
	on_attach = on_attach,
}
lspconfig.pyright.setup {
	capabilities = lsp_capabilities,
	on_attach = function ()
		--vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
		--vim.keymap.set('n', '<F6>', function() require('dap').restart() end)
		--vim.keymap.set('n', '<F3>', function() require('dap').step_over() end)
		--vim.keymap.set('n', '<F1>', function() require('dap').step_into() end)
		--vim.keymap.set('n', '<F2>', function() require('dap').step_out() end)
		--vim.keymap.set('n', '<leader>s', function() require('dap').terminate() end)
		--vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
		--vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
		--vim.keymap.set('n', '<leader>dp', function() require("dap").pause() end)
		--vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
		--vim.keymap.set('n', '<leader>lb', function() require('dap').list_breakpoints() end)
		--vim.keymap.set('n', '<leader>cb', function() require('dap').clear_breakpoints() end)
		--vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.toggle() end)
		--vim.keymap.set("n", "<leader>du", function() require('dapui').toggle() end)
		--vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
		--vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
		--vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() require('dap.ui.widgets').preview() end)
		--vim.keymap.set({ 'n', 'v' }, '<Leader>de', function() require('dapui').eval() end)
		--vim.keymap.set('n', '<Leader>df', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.frames) end)
		--vim.keymap.set('n', '<Leader>ds', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.scopes) end)
	end,
	settings = {
		pyright = { autoImportCompletion = true, },
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = 'workspace',
				useLibraryCodeForTypes = true,
				typeCheckingMode = 'basic'
			}
		}
	}
}
lspconfig.lua_ls.setup {
	capabilities = lsp_capabilities,
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' },
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "space",
					indent_size = "8",
				}
			},
		},
	},
}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		--vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
		vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
			{ desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
