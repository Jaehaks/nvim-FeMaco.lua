local M = {}

---@param target string target node name to check this region under cursor is the node
--- @return boolean Whether the node which is same with target exists.
--- @return TSNode? Object of treesitter tree
M.is_node = function(target)
	local snode = vim.treesitter.get_node() -- get smallest node of current buffer and cursor
	if not snode then
		return false, nil
	end

	local node = nil
	while not node do
		if snode:type() == target then
			node = snode
		end
		snode = snode:parent()
	end

	return true, node
end

return M

