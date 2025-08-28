local M = {}

---@param targets string|table target node to check this region under cursor is the node
--- @return TSNode? Object of treesitter tree
M.is_node = function(targets)
	local snode = vim.treesitter.get_node() -- get smallest node of current buffer and cursor
	if not snode then
		return nil
	end

	local node = nil
	while node do
		if snode:type() == targets then
			node = snode
		end
		node = node:parent()
	end

	return node
end

return M

