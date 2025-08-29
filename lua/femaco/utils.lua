local M = {}

-- If you execute vim.cmd('write') independently, it invokes BufWritePost/BufWritePre.
-- But it doesn't If it called in function. autocmds must be called explicitly
---@param bufnr number buffer id
M.save_buf = function (bufnr)
	vim.api.nvim_exec_autocmds('BufWritePre', {buffer = bufnr}) -- force execute BufWritePre event
	local ok, _ = pcall(function () vim.cmd('write') end)
	if not ok then -- when write is protected, do not write anymore in this buffer
		vim.notify('Femaco : Failed to write floating buffer', vim.log.levels.WARN)
	end
	vim.api.nvim_exec_autocmds('BufWritePost', {buffer = bufnr}) -- force execute BufWritePost event
end

return M
