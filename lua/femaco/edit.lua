local M = {}
local Parser = require('femaco.parser')
local Config = require('femaco.config')

-- set window options to open floating window
---@param lang string content of language
---@pram code string content of code block
---@return table code block contents sliced by '\n'
---@return table window options for nvim_open_win()
local function set_win_opts(lang, code)
	local config = Config.get()

	-- default size of floating window
	local max_width = vim.api.nvim_win_get_width(0) -- max width is width of current file
	local max_height = vim.api.nvim_win_get_height(0)
	local width = math.floor(max_width * 0.9)
	local height = math.floor(max_height * 0.9)

	-- set window height / width to fit file contents
	local lines = vim.split(code or '', '\n')
	if config.window.fit_contents then
		local num_lines = #lines

		local max_num_col = 0
		for _, line in ipairs(lines) do
			if #line > max_num_col then
				max_num_col = #line
			end
		end
		num_lines = math.floor(num_lines * 2)
		max_num_col = math.floor(max_num_col * 1.5)

		if num_lines > 0 then
			width = math.min(max_num_col, max_width)
			height = math.min(num_lines, max_height)
		end
	end

	-- set floating window location
	local row = math.floor((max_height - height) / 2)
	local col = math.floor((max_width - width) / 2)

	-- set options of floating windows style
	local opts = {
		relative  = 'editor',
		row       = row,            -- start of x(right) index from cursor
		col       = col,            -- start of y(below) index from cursor
		width     = width,          -- width of floating window
		height    = height,         -- height of floating window
		border    = 'rounded',      -- single round corner
		title     = lang or 'None', -- title in window border,
		title_pos = 'left',
		style 	  = 'minimal',      -- not show relative number / statuscolumn
	}

	return lines, opts
end

-- open floating window with contents of code block
---@return femaco.details?
local function open_float()
	-- get contents from node under cursor
	local node = Parser.is_node('fenced_code_block')
	if not node then
		vim.notify('Femaco: Call in code-block section!', vim.log.levels.ERROR)
		return
	end
	local lang = Parser.get_childtext(node, 'language') or ''
	local code = Parser.get_childtext(node, 'code_fence_content') or ''
	local file_bufnr = vim.api.nvim_get_current_buf() -- get bufnr .md

	local start_row, _, end_row, _ = node:range() -- get line number of range of code block

	-- set floating window options
	local lines, winopts = set_win_opts(lang, code)

	-- open floating window
	local bufnr = vim.api.nvim_create_buf(false, true) -- set buffer temporarily
	local winid = vim.api.nvim_open_win(bufnr, true, winopts) --  open window and enter
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_set_option_value('filetype', lang, { buf = bufnr })

	-- return window data
	---@class femaco.details
	---@field lang string language of code block
	---@field file_bufnr number buffer id of original markdown file
	---@field win_bufnr number buffer id of floating window
	---@field win_winid number window id of floating window
	---@field start_row number start line number of code block of original markdown file
	---@field end_row number end line number of code block of original markdown file
	local details = {
		lang = lang,
		file_bufnr = file_bufnr,
		win_bufnr = bufnr,
		win_winid = winid,
		start_row = start_row + 2, -- remove ```filetype
		end_row = end_row - 1,     -- remove ```
	}
	return details
end

-- save floating window and closed
---@param details femaco.details
local function save_and_close(details)
	-- get contents of floating buffer
	local code = vim.api.nvim_buf_get_lines(details.win_bufnr, 0, -1, false)

	-- set contents to original markdown file
	vim.api.nvim_buf_set_lines(details.file_bufnr, details.start_row-1, details.end_row, false, code)

	-- close window
	vim.api.nvim_win_close(details.win_winid, true)
	vim.api.nvim_buf_delete(details.win_bufnr, {force = true})
end

-- open code block with floating window
M.edit_code_block = function()

	-- open floating window
	local details = open_float()
	if not details then
		vim.notify('Femaco: Floating buffer cannot opened', vim.log.levels.ERROR)
		return
	end

	-- 'q' always save the window, you need to 'u' to undo after saved
	vim.keymap.set('n', 'q', function ()
		save_and_close(details)
	end, {buffer = details.win_bufnr, silent = true, desc = 'quit buffer'})

end


return M
