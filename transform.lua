-----------------------------------------------------------------------------------------------------------------
-- Transform module
----------------------------------------------------------------------------------------------------------------    
    
local transform = {}

local dm = require("data_management")

function transform:Transform_SquareY(data)
    new_data = {}--dm:Table_Copy(data)
    for x = 1, #data do
        print("data[x].y: " .. data[x].y)
		new_data[x] = {x = data[x].x, y= data[x].y * data[x].y, flag = data[x].flag}
		print("transform square: " .. new_data[x].y)
	end
	return new_data
end

return transform
