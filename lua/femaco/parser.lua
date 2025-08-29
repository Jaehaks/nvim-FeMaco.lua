local M = {}

-- Check the node under cursor is target node
---@param target string target node name to check this region under cursor is the node
--- @return TSNode? Object of treesitter tree
M.is_node = function(target)
	local snode = vim.treesitter.get_node() -- get smallest node of current buffer and cursor
	if not snode then
		return nil
	end

	local node = nil
	while not node do
		if snode:type() == target then
			node = snode
		end
		snode = snode:parent()
	end

	return node
end

-- get targeted child node from parent node
---@param node TSNode? parent node to get their child content
---@param target string child node name which you want to get contents
---@return TSNode? string child node name which you want to get contents
local function get_child(node, target)
	if not node then
		return nil
	end

	if node:type() == target then
		return node
	end

	for child in node:iter_children() do
		local cnode = get_child(child, target)
		if cnode then
			return cnode
		end
	end

	return nil
end

-- Get contents of child node which is target
---@param node TSNode? Parent node to get their child content
---@param target string Child node name which you want to get contents
---@return string? Contents of child node
M.get_childtext = function (node, target)
	local child = get_child(node, target)

	if child then
		return vim.treesitter.get_node_text(child, 0)
	else
		return nil
	end
end

return M

