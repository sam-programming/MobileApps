-----------------------------------------------------------------------------------------------------------------
-- Chart Module
-- Contains functions
-----------------------------------------------------------------------------------------------------------------

local chart = {}

-- Works
local dm = require("data_management")

-- The big one - creates a chart with lines and plots the data to it
function chart:Chart_And_Plot(data)
	
	for x = 1, #data do
		print("in chart: " .. data[x].y)
	end

	local min_x, min_y, max_x, max_y = dm:Min_Max(data)	
	min_x = math.floor(min_x)
	max_x = math.ceil(max_x)
	min_y = math.floor(min_y)
	max_y = math.ceil(max_y)

    local y_range = 0--max_y - min_y -- 7
    local x_range = 0--max_x - min_x -- 9 

	 -- get actual range: not counting like this skips 0 in neg to pos ranges
	for x = min_x, max_x do
		x_range = x_range + 1
	end
	for x = min_y, max_y do
		y_range = y_range + 1
		--print(x)
	end    
    --print("y_range: " .. y_range)
    --print("x_range: " .. x_range)
    
	local x_offset = 25
	local y_offset = 50
	local width = 270
	local height = 220
    
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
	
	local start_x = border.x + 5-- 0
	local start_y = border.y - 5-- 0

	--print("min x: " .. min_x)
	-- Standardise the ranges so they start at 0 
	local range_diff_x = 0 - min_x
	local range_diff_y = 0 - min_y  --y_range - max_y
	--print("range_diff_x: " .. range_diff_x)
	
	-- If ranges need standarding, do the same to the data
	-- retain old data by standardising a new data table
	local old_data = dm:Table_Copy(data)
	
	local stand_min_x, stand_max_x, stand_min_y, stand_max_y

	if range_diff_x ~= 0 then  -- data[].x values
		stand_min_x = min_x + range_diff_x
		stand_max_x = max_x + range_diff_x
		--print('Min x: ' .. stand_min_x .. ', Max x: ' .. stand_max_x)
		for x = 1, #data do
			data[x].x = data[x].x + range_diff_x
			--print(new_data[x].x)
		end
	else
		stand_min_x = min_x
		stand_max_x = max_x
	end

	if range_diff_y ~= 0 then  -- data[].y values
		stand_min_y = min_y + range_diff_y
		stand_max_y = max_y + range_diff_y
		--print('Min y: ' .. stand_min_y .. ', Max y: ' .. stand_max_y)
		for x = 1, #data do
			data[x].y = data[x].y + range_diff_y
			--print(data[x].y)
		end
	else
		stand_min_y = min_y
		stand_max_y = max_y
	end	

	--chop a bit off height and width to look nice
	width = 260
	height = 210
	
	-- 10% for each step (rounded up) - max 10 values
	local step = dm:Round((10/100) * y_range)
	--print("Step: " .. step)
	local y_range_val = min_y;
	
	-- place numbers at 10% of width on Y-Axis
	for x = stand_min_y , stand_max_y, step do
		-- percentage of step to actual range
		local inc_percent = (x / (y_range - 1)) * 100	
		-- same percentage of height 
		local inc = (inc_percent/100) * height
		local num = display.newText(y_range_val, start_x - 15, (height - inc - start_y ))
		num:setFillColor(0.3, 0.3, 0.3)
		num.size = 10
		chartGroup:insert(num)
		y_range_val = y_range_val + step
	end

	-- place numbers at 10% of height on X-Axis
	local step = dm:Round((10/100) * x_range)
	local x_range_val = min_x;
	for y = stand_min_x, stand_max_x, step do
		local inc_percent = (y / (x_range - 1)) * 100
		local inc = (inc_percent/100) * width
		local num = display.newText(x_range_val, (inc + start_x), height + 20 )
		num:setFillColor(0.3, 0.3, 0.3)
		num.size = 10
		chartGroup:insert(num)
		x_range_val = x_range_val + step
	end		

	-- reference for the onTouch event
	local point_ref = {}
	
	--Remove the object and prevent memory leaks
	local function remove_obj( obj )
		obj:removeSelf()
		obj = nil
	end

	local function onTouch( event )
		if event.phase == "began" then			
			local cords = point_ref[event.target.y].cords
			local info = display.newText(cords, event.x + 4, event.y - 10)
			info:setFillColor(0.1, 0.1, 0.1)
			info.size = 12
			transition.to(info, {time = 1500, onComplete = remove_obj})
		end
	end

    local points = {}
	-- To find where the data point needs to be drawn, we find the 
	-- percentage it represents on the length or width of the axis
	-- Display.newCircle(x, y, radius)
	for x = 1, #data do 
		local y_inc_percent = (data[x].y / (y_range - 1)) * 100
		local y_inc = (y_inc_percent/100) * height
		local x_inc_percent = ((data[x].x / (x_range - 1)) * 100)
		local x_inc = (x_inc_percent/100 * width)
		--print(x_inc + start_x)
		local point = display.newCircle( x_inc + start_x, height - y_inc - start_y, 4)	
		point_ref[point.y] = {cords = "x: " .. old_data[x].x .. ", y: " .. old_data[x].y, flag = false}
		if data[x].flag == 'B' then point:setFillColor(0, 0, 1) end
		if data[x].flag == 'Z' then point:setFillColor(0, 1, 0) end
		if data[x].flag == 'M' then point:setFillColor(1, 0, 0) end	
		point:addEventListener("touch", onTouch)
		point.isVisible = false
       -- chartGroup:insert(point)
        points[x] = point
    end
    -- becuase the data gets standardised, return it in original state
    return old_data, chartGroup, points
end

return chart
