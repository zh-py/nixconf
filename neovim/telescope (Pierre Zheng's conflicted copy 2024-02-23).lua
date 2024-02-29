local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.api.nvim_set_keymap(
	"n",
	"<space>fb",
	":Telescope file_browser path=%:p:h select_buffer=true<CR>",
	{ noremap = true }
)
require('telescope').setup {
	defaults = {
		path_display = { "shorten" } -- or "truncate, smart"
	},
	extensions = {
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
				},
				["n"] = {
					-- your custom normal mode mappings
				},
			},
		},
	},
	["ui-select"] = {
		require("telescope.themes").get_dropdown {
			-- even more opts
		}
		-- pseudo code / specification for writing custom displays, like the one
		-- for "codeactions"
		-- specific_opts = {
		--   [kind] = {
		--     make_indexed = function(items) -> indexed_items, width,
		--     make_displayer = function(widths) -> displayer
		--     make_display = function(displayer) -> function(e)
		--     make_ordinal = function(e) -> string
		--   },
		--   -- for example to disable the custom builtin "codeactions" display
		--      do the following
		--   codeactions = false,
		-- }
	}
	-- To get ui-select loaded and working with telescope, you need to call
	-- load_extension, somewhere after setup function:
}
require("telescope").load_extension("ui-select")
