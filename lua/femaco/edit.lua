local M = {}
local Parser = require('femaco.parser')


M.test = function ()
	Parser.is_node('fenced_code_block')
end



return M
