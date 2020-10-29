-----------------------------------------------------------------------------------------------------------------
-- Chart Module
-- Contains functions
-----------------------------------------------------------------------------------------------------------------

local chart = {}

-- Works
local dm = require("data_management")

-- The big one - creates a chart with lines and plots the data to it
function chart:Chart_And_Plot(data)
	local min_x, min_y, max_x, max_y = dm:MinMax(data)

	print("Rounded XMAX = " .. dm:Round(max_x) .. " XMIN = " .. min_x .. " YMIN = " .. 
		dm:Round(min_y) .. " YMAX = " .. dm:Round(max_y))

	min_x = dm:Round(min_x)
	max_x = dm:Round(max_x)
	min_y = dm:Round(min_y)
	max_y = dm:Round(max_y)

    local y_range = 0--max_y - min_y -- 7
    local x_range = 0--max_x - min_x -- 9 

	 -- get actual range: not counting like this skips 0 in neg to pos ranges

	for x = min_x, max_x do
		x_range = x_range + 1
	end
	for x = min_y, max_y do
		y_range = y_range + 1
	end
    
    --print("y_range: " .. y_range)
    --print("x_range: " .. x_range)
    
	local x_offset = 25
	local y_offset = 25
	local width = 270
	local height = 220
	local inc_x = width / (x_range + 1 ) -- amount to increment drawLine() on x axis each loop | range + 1 for extra space
	local inc_y = height / (y_range + 1) -- amount to increment on y axis each loop
	local next_x = inc_x  -- holds the value of the next increment
    local next_y = inc_y
    
    --display groups are can have their own anchors
	local chartGroup = display.newGroup()
	chartGroup.x = x_offset
	chartGroup.y = y_offset
	
	-- create a box for the graph with a thin grey border
	--local border = display.newRect(x_offset, y_offset, width, height)
	local border = display.newRect(0, 0, width, height)
	border.anchorX = 0
	border.anchorY = 0
	border:setFillColor(1.0, 1.0, 1.0) 
	border:setStrokeColor(0.85, 0.85, 0.85) 
	border.strokeWidth = 1
	chartGroup:insert(border)

	-- Variables representing left side, right side, top and bottom of border
	local start_x = border.x + border.strokeWidth
	local start_y = border.y
	local end_x = start_x + width
	local end_y = start_y + height
	
	-- if > 9
	local step = dm:Round((10/100) * y_range)
	local inc = (step / 100) * y_range
	
	-- every 3
	local line = display.newLine()



	-- Draw lines every 20% if the way
	local range_seg = 1
	local range_inc = 1
	if x_range > 9 then
		range_seg = math.floor((10 / 100) * x_range)
		range_inc = range_seg
	end
	local x_min = min_x
	for x = range_inc, x_range do 	
		print(range_seg)
		if range_seg == x then
			num = display.newText(x_min, start_x + next_x, end_y + 10)		
			num:setFillColor(0.3, 0.3, 0.3)
			num.size = 10
			graph = display.newLine(start_x + next_x, end_y, start_x + next_x, end_y - 4)
			--print(start_x + next_x .. ' ' .. start_y .. ' ' .. start_x + next_x .. ' ' .. end_y)
			graph:setStrokeColor(0.85, 0.85, 0.85)
			graph.strokeWidth = 0.9
			chartGroup:insert(num)
			chartGroup:insert(graph)
			range_seg = range_seg + range_inc
		end
		
		next_x = next_x + inc_x
		x_min = x_min + 1
	end

    -- Need to do something like: if range > 10 plot every 10% of range
	-- Draw evenly spaced horizontal lines (y-axis) in border	
	range_seg = 1
	range_inc = 1
	if y_range > 10 then
		range_seg = math.floor((10 / 100) * y_range)
		range_inc = range_seg
	end
	print("range_x: " .. x_range .. " y range: " .. y_range)
	local y_min = min_y

	-- make the step of the loop range_seg 
	for y = range_inc, y_range do
		if range_seg == y then
			print('rangeseg , y : ' .. range_seg .. ' ' .. y)
			num = display.newText(y_min, start_x + 10, (end_y - next_y) + inc_y)
			num:setFillColor(0.3, 0.3, 0.3)
			num.size = 10
			graph = display.newLine(start_x - 2, start_y + next_y, start_x + 4, start_y + next_y) 
			
			--print("Line " .. y .. "start: " .. (start_y + next_y) )
			graph:setStrokeColor(0.85, 0.85, 0.85)
			graph.strokeWidth = 0.9
			chartGroup:insert(graph)
			range_seg = range_seg + range_inc
		end
		next_y = next_y + inc_y
		y_min = y_min + 1
	end

	-- Standardise the ranges so they start at 0 
	local range_diff_x = x_range - max_x 
	local range_diff_y = y_range - max_y

	-- If ranges need standarding, do the same to the data
	-- retain old data by standardising a new data table
	local new_data = data
	if range_diff_x ~= 0 then  -- data[].x values
		min_x = min_x + range_diff_x
		max_x = max_x + range_diff_x
		print('Min x: ' .. min_x .. ', Max x: ' .. max_x)
		for x = 1, #new_data do
			new_data[x].x = new_data[x].x + range_diff_x
			print(new_data[x].x)
		end
	end

	if range_diff_y ~= 0 then  -- data[].y values
		min_y = min_y + range_diff_y
		max_y = max_y + range_diff_y
		print('Min y: ' .. min_y .. ', Max y: ' .. max_y)
		for x = 1, #new_data do
			new_data[x].y = new_data[x].y + range_diff_y
			print(new_data[x].y)
		end
	end

    local points = {}
	-- To find where the data point needs to be drawn, we find the 
	-- percentage it represents on the length or width of the axis
	-- Display.newCircle(x, y, radius)
	for x = 1, #data do 
		local point = display.newCircle( (new_data[x].x / (x_range + 1)   * width) ,
										end_y - (new_data[x].y / (y_range  + 1) * height), 3)		
		if data[x].flag == 'B' then point:setFillColor(0, 0, 1) end
		if data[x].flag == 'Z' then point:setFillColor(0, 1, 0) end
		if data[x].flag == 'M' then point:setFillColor(1, 0, 0) end		
        chartGroup:insert(point)
        points[x] = point
    end
    
    return chartGroup, points
end

return chart

