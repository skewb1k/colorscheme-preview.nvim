local group = vim.api.nvim_create_augroup("nvim_colorscheme_preview", { clear = true })
local saved = nil
vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
	desc = "Preview colorscheme during :colorscheme, restore if aborted",
	group = group,
	callback = function(ev)
		local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
		if not ok or parsed.cmd ~= "colorscheme" or #parsed.args ~= 1 then
			return
		end
		local colorscheme = parsed.args[1]
		if #parsed.args > 1 or not colorscheme then
			return
		end
		if not saved then
			saved = vim.g.colors_name or "default"
		end
		if ev.event == "CmdlineLeave" then
			if vim.v.event.abort then
				colorscheme = saved
			end
			saved = nil
		end
		if not pcall(vim.cmd.colorscheme, colorscheme) then
			vim.cmd.colorscheme(saved)
		end
		vim.cmd.redraw()
	end,
})
