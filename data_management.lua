	-----------------------------------------------------------------------------------------------------------------
-- Data Management Module
-- Contains functions Get_Data( string path ) and Data_Transformation functions
-----------------------------------------------------------------------------------------------------------------

local data_management = {}

-- gets data from a CSV file with exact formatting
function data_management:Get_Data(path)
	print('Running Get_Data()')
	local data = {}
	local i = 1
	local path = system.pathForFile(path, system.ResourceDirectory)
	local file, err = io.open(path, "r")	
	-- if file is empty, return empty
	if not file then
		err =  'File is empty. Message: ' .. err
		print(err)
		return err
	else
		-- read data from file
		for line in file:lines() do
			-- string match pattern for digit, digit with decimal point, single character
			x, y, flag = string.match(line, "(%d+),(-*%d*%.?%d+),(%a)")			
			flag = string.match(line, "(%a)")
			data[i] = {x = x, y= y, flag = flag}
			--print("x: " .. data[i].x .. ", y: " .. data[i].y .. ", Flag: " .. data[i].flag) -- debug			
			i = i + 1
		end
		io.close(file)
	end
	return data, err
end

function data_management:Round(num)
	--print('Running Round(' .. num .. ')')
	-- using modulo 1 will give us the remainder of the number	
	if (num % 1 >= 0.5) then
		return math.ceil( num )  -- round up
	else
		return math.floor( num ) -- round down
	end
end

-- finds the maximum and minimum values of the data
function data_management:Min_Max(data) 
	local min_x = tonumber(data[1].x)
	local min_y = tonumber(data[1].y)
	local max_x = tonumber(data[1].x)
	local max_y = tonumber(data[1].y)
	for index = 1, #data do
		if tonumber(data[index].x) < min_x then min_x = tonumber(data[index].x) end
		if tonumber(data[index].x) > max_x then max_x = tonumber(data[index].x) end
		if tonumber(data[index].y) < min_y then min_y = tonumber(data[index].y) end
		if tonumber(data[index].y) > max_y then max_y = tonumber(data[index].y) end
	end
	return min_x, min_y, max_x, max_y
end
-- try to copy a table
function data_management:Table_Copy(table)
	local table_copy = {}
	for x = 1, #table do
		table_copy[x] = {x = table[x].x, y = table[x].y, flag = table[x].flag }
		--print("Table copy.y: " .. table_copy[x].y)
	end
	return table_copy
  end

return data_management
