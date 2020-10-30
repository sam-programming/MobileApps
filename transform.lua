-----------------------------------------------------------------------------------------------------------------
-- Transform module
----------------------------------------------------------------------------------------------------------------    
    
local transform = {}

local dm = require("data_management")

function transform:Transform_SquareY(data)
    -- square the y axis
    for x = 1, #data do
        print("data[x].y: " .. data[x].y)
		data[x].y = data[x].y * data[x].y
		print("transform square: " .. data[x].y)
	end
	return data
end

return transform
