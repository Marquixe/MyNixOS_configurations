return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		window = {
			mappings = {
				["<cr>"] = function(state)
					local node = state.tree:get_node()
					if node.type == "file" then
						local preview = require("neo-tree.sources.common.preview")
						if preview.is_active() then
							-- second enter: jump into file
							require("neo-tree.command").execute({ action = "focus" })
							vim.cmd("wincmd p")
						else
							-- first enter: preview, stay in explorer
							require("neo-tree.command").execute({
								command = "open",
								toggle_preview = true,
							})
						end
					end
				end,
			},
		},
	},
}
